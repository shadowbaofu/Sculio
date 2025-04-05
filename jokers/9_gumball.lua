SMODS.Joker {
  key = 'gumball',
  loc_txt = {
    name = 'Gumball Machine',
    text = {
      'Adds {C:mult}#2#{} Mult when a booster pack is opened',
      '{C:mult}#3#{} Mult when a booster pack is skipped',
      'Destroyed if Mult reaches {C:mult}#4#{} Mult',
      '{C:inactive}(Currently {C:mult}#1#{}{C:inactive})'
    }
  },

  config = { extra = { mult = 5, mult_add_open = 3, mult_add_skip = -6, mult_min = 0 } },
  unlocked = true,
  discovered = true,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 8, y = 0 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    mult_text = card.ability.extra.mult

    if mult_text >= 0 then
      mult_text = '+' .. mult_text
    end

    mult_add_open_text = card.ability.extra.mult_add_open

    if mult_add_open_text >= 0 then
      mult_add_open_text = '+' .. mult_add_open_text
    end

    mult_add_skip_text = card.ability.extra.mult_add_skip

    if mult_add_skip_text >= 0 then
      mult_add_skip_text = '+' .. mult_add_skip_text
    end

    mult_min_text = card.ability.extra.mult_min

    if mult_min_text >= 0 then
      mult_min_text = '+' .. mult_min_text
    end

    return { vars = { mult_text, mult_add_open_text, mult_add_skip_text, mult_min_text } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end

    if not context.blueprint then
      if context.open_booster then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_add_open

        G.E_MANAGER:add_event(Event({
          func = function() 
            card_eval_status_text(card, 'extra', nil, nil, nil, {
              message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_add_open } },
              colour = G.C.RED,
              delay = 0.45
            })

            return true
          end
        }))
      end

      if context.skipping_booster then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_add_skip

        G.E_MANAGER:add_event(Event({
          func = function()
            mult_add_skip_text = card.ability.extra.mult_add_skip

            if mult_add_skip_text >= 0 then
              mult_add_skip_text = '+' .. mult_add_skip_text
            end

            card_eval_status_text(card, 'extra', nil, nil, nil, {
              message = '' .. mult_add_skip_text,
              colour = G.C.RED,
              delay = 0.45
            })

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

            return true
          end
        }))
      end
    end
  end
}
