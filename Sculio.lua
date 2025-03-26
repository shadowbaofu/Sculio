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

SMODS.Joker {
  key = 'gold_ore',
  loc_txt = {
    name = 'Gold Ore',
    text = {
      'Scored {C:attention}Stone Cards{}',
      'gain a {C:attention}Gold Seal{}'
    }
  },

  unlocked = true,
  discovered = true,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 5, y = 0 },
  cost = 7,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      -- Based off of Vampire.
      for k, v in ipairs(context.scoring_hand) do
        if v.config.center == G.P_CENTERS.m_stone and not v.debuff and not v.vampired then 
          v:set_seal('Gold', nil, true)

          G.E_MANAGER:add_event(Event({
            func = function()
              v:juice_up()
              return true
            end
          }))
        end
      end
    end
  end
}

SMODS.Joker {
  key = 'pop_star',
  loc_txt = {
    name = 'Pop Star',
    text = {
      '{C:green}#1# in #2#{} chance',
      'for {C:attention}each scored card{}',
      'to become {C:attention}enhanced{}'
    }
  },

  config = { extra = { odds = 8 } },
  unlocked = true,
  discovered = true,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 6, y = 0 },
  cost = 8,
  loc_vars = function(self, info_queue, card)
    return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.x_mult } }
  end,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      for k, v in ipairs(context.scoring_hand) do
        if v.config.center == G.P_CENTERS.c_base and pseudorandom('pop_star') < G.GAME.probabilities.normal / card.ability.extra.odds then
          math.randomseed(pseudorandom('pop_star'))
          enhancement_index = math.random(1, #G.P_CENTER_POOLS['Enhanced'])
          enhancement = G.P_CENTER_POOLS['Enhanced'][enhancement_index]
          v:set_ability(enhancement, nil, true)

          G.E_MANAGER:add_event(Event({
            func = function()
              v:juice_up()
              return true
            end
          }))
        end
      end
    end
  end
}

SMODS.Joker {
  key = 'addiction',
  loc_txt = {
    name = 'Addiction',
    text = {
      'If you play your most played hand,',
      'each scored {C:attention}card{} permanently gains {C:chips}chips{} equal to',
      '{C:attention}#1#X the number of times it has been played{}'
    }
  },

  config = { extra = { hand_count_mult = 3 } },
  unlocked = true,
  discovered = true,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 7, y = 0 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.hand_count_mult } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      -- Based off of Obelisk.
      most_played = true
      most_played_count = (G.GAME.hands[context.scoring_name].played or 0)

      for k, v in pairs(G.GAME.hands) do
        if k ~= context.scoring_name and v.played >= most_played_count and v.visible then
          most_played = false
        end
      end

      if most_played then
        perma_bonus_gain = most_played_count * card.ability.extra.hand_count_mult

        -- Based off of Hiker.
        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + perma_bonus_gain
  
        return {
          extra = {message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
          colour = G.C.CHIPS,
          card = card
        }
      end
    end
  end
}

SMODS.Joker {
  key = 'handheld',
  loc_txt = {
    name = 'Handheld',
    text = {
      'Scored {C:clubs}Clubs{} and {C:spades}Spades{} become {C:attention}Wild Cards{}',
      'if they are not already enhanced'
    }
  },

  unlocked = true,
  discovered = true,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 0, y = 1 },
  cost = 9,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      -- Based off of Vampire.
      for k, v in ipairs(context.scoring_hand) do
        if (v:is_suit('Clubs') or v:is_suit('Spades')) and v.config.center == G.P_CENTERS.c_base and not v.debuff and not v.vampired then 
          v:set_ability(G.P_CENTERS.m_wild, nil, true)

          G.E_MANAGER:add_event(Event({
            func = function()
              v:juice_up()
              return true
            end
          }))
        end
      end
    end
  end
}

SMODS.Joker {
  key = 'kfc',
  loc_txt = {
    name = 'Chicken Coupon',
    text = {
      'Steals {C:money}$#2#{} of {C:attention}sell{} value',
      'from every other {C:attention}Joker{} if available.',
      'Gains {X:mult,C:white}X#3#{} Mult for each {C:money}$#4#{} stolen this way',
      '{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive})',
    }
  },

  config = { extra = { x_mult = 1, dollar_steal = 1, x_mult_scale = 0.1, dollar_scale = 1 } },
  unlocked = true,
  discovered = true,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 7, y = 1 },
  cost = 10,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult, card.ability.extra.dollar_steal, card.ability.extra.x_mult_scale, card.ability.extra.dollar_scale } }
  end,
  calculate = function(self, card, context)
    if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
      stolen = 0

      for k, v in ipairs(G.jokers.cards) do
        if v ~= card and v.set_cost and v.sell_cost > 0 then
          if v.sell_cost < card.ability.extra.dollar_steal then
            steal = v.sell_cost
          else
            steal = card.ability.extra.dollar_steal
          end

          v.ability.extra_value = (v.ability.extra_value or 0) - steal
          v:set_cost()

          stolen = stolen + steal
        end
      end

      if stolen > 0 then
        card.ability.extra_value = (card.ability.extra_value or 0) + stolen
        card:set_cost()

        x_mult_gain = card.ability.extra.x_mult_scale * (stolen / card.ability.extra.dollar_scale)
        card.ability.extra.x_mult = card.ability.extra.x_mult + x_mult_gain

        return {
          message = 'Stole $' .. stolen,
          colour = G.C.MONEY
        }
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
