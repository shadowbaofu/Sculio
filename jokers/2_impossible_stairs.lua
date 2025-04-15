SMODS.Joker {
  key = 'impossible_stairs',
  loc_txt = {
    name = 'Impossible Stairs',
    text = {
      'This Joker gains between {C:mult}#3#{}',
      'and {C:mult}#2#{} Mult per hand played',
      'Destroyed if Mult reaches {C:mult}#4#{} Mult',
      '{C:inactive}(Currently {C:mult}#1#{}{C:inactive} Mult)'
    }
  },

  config = { extra = { mult = 5, mult_add_min = -1, mult_add_max = 2, mult_min = 0 } },
  unlocked = true,
  discovered = true,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 1, y = 0 },
  cost = 3,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    mult_text = card.ability.extra.mult

    if mult_text >= 0 then
      mult_text = '+' .. mult_text
    end

    mult_add_min_text = card.ability.extra.mult_add_min

    if mult_add_min_text >= 0 then
      mult_add_min_text = '+' .. mult_add_min_text
    end

    mult_add_max_text = card.ability.extra.mult_add_max

    if mult_add_max_text >= 0 then
      mult_add_max_text = '+' .. mult_add_max_text
    end

    mult_min_text = card.ability.extra.mult_min

    if mult_min_text >= 0 then
      mult_min_text = '+' .. mult_min_text
    end

    return { vars = { mult_text, mult_add_min_text, mult_add_max_text, mult_min_text } }
  end,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      math.randomseed(pseudorandom('impossible_stairs'))
      add = math.random(card.ability.extra.mult_add_min, card.ability.extra.mult_add_max)
      card.ability.extra.mult = card.ability.extra.mult + add

      if card.ability.extra.mult <= card.ability.extra.mult_min then
        -- Delete Joker. Based off of Ice Cream.
        G.E_MANAGER:add_event(Event({
          func = function()
            play_sound('tarot1')
            card.T.r = -0.2
            card:juice_up(0.3, 0.4)
            card.states.drag.is = true
            card.children.center.pinch.x = true

            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
              func = function()
                G.jokers:remove_card(card)
                card:remove()
                card = nil
                return true
              end
            }))

            return true
          end
        }))
      end

      if add >= 0 then
        return {
          message = localize{type='variable', key='a_mult', vars={add}},
          colour = G.C.MULT
        }
      else
        return {
          message = localize{type='variable', key='a_mult_minus', vars={math.abs(add)}},
          colour = G.C.MULT
        }
      end
    end

    if context.joker_main then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end
  end
}
