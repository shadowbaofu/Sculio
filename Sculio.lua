SMODS.Atlas {
  -- Key for code to find it with
  key = 'Sculio',
  -- The name of the file, for the code to pull the atlas from
  path = 'Sculio.png', -- Original file sourced from https://github.com/Steamodded/examples/tree/master/Mods/ExampleJokersMod/assets
  -- Width of each sprite in 1x size
  px = 71,
  -- Height of each sprite in 1x size
  py = 95
}

SMODS.Joker {
  key = 'schrodinger',
  loc_txt = {
    name = 'Schrodinger\'s Joker',
    text = {
      '{C:green}#1# in #2#{} chance',
      'for {X:mult,C:white}X#3#{} Mult'
    }
  },

  config = { extra = { odds = 2, x_mult = 2 } },
  unlocked = true,
  discovered = true,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 0, y = 0 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.x_mult } }
  end,
  calculate = function(self, card, context)
    if context.joker_main and pseudorandom('schrodinger') < G.GAME.probabilities.normal / card.ability.extra.odds then
      return {
        Xmult_mod = card.ability.extra.x_mult,
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
      }
    end
  end
}

SMODS.Joker {
  key = 'impossible_stairs',
  loc_txt = {
    name = 'Impossible Stairs',
    text = {
      'This Joker gains between {C:mult}#3#{}',
      'and {C:mult}#2#{} Mult per hand played.',
      'Destroyed if Mult reaches {C:mult}#4#{} Mult',
      '{C:inactive}(Currently {C:mult}#1#{}{C:inactive})'
    }
  },

  config = { extra = { mult = 5, mult_add_min = -1, mult_add_max = 2, mult_min = 0 } },
  unlocked = true,
  discovered = true,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 1, y = 0 },
  cost = 3,
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
    if context.joker_main then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end

    if context.after and not context.blueprint then
      math.randomseed(pseudorandom('impossible_stairs'))
      add = math.random(card.ability.extra.mult_add_min, card.ability.extra.mult_add_max)
      card.ability.extra.mult = card.ability.extra.mult + add

      if card.ability.extra.mult <= card.ability.extra.mult_min then
        -- Delete Joker. Copied from Ice Cream.
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

      mult_text = card.ability.extra.mult

      if mult_text >= 0 then
        mult_text = '+' .. mult_text
      end

      return { message = mult_text }
    end
  end
}

SMODS.Joker {
  key = 'house_party',
  loc_txt = {
    name = 'House Party',
    text = {
      'This Joker gains {X:mult,C:white}X#2#{} Mult',
      'per {C:attention}consecutive{} hand played',
      'containing a {C:attention}Full House{}',
      '{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive})',
    }
  },

  config = { extra = { x_mult = 1, x_mult_gain = 0.25 } },
  unlocked = true,
  discovered = true,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 2, y = 0 },
  cost = 6,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
  end,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      if (next(context.poker_hands['Full House']) or next(context.poker_hands['Flush House'])) then
        card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
      elseif card.ability.extra.x_mult > 1 then
        card.ability.extra.x_mult = 1
        return { message = localize('k_reset') }
      end
    end

    if context.joker_main and card.ability.extra.x_mult > 1 then
      return {
        Xmult_mod = card.ability.extra.x_mult,
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
      }
    end
  end
}

SMODS.Joker {
  key = 'stonks',
  loc_txt = {
    name = 'Wall Street Joker',
    text = {
      'The {C:mult}+Mult{} for this Joker',
      '{C:attention}doubles{} after every boss blind',
      '{C:inactive}(Currently {C:mult}+#1#{}{C:inactive})'
    }
  },

  config = { extra = { mult = 1 } },
  unlocked = true,
  discovered = true,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 4, y = 0 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end

    if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint and G.GAME.blind.boss then
      card.ability.extra.mult = card.ability.extra.mult * 2
      return { message = localize('k_upgrade_ex') }
    end
  end
}
