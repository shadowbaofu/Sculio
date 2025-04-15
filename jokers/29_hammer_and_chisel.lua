SMODS.Joker {
  key = 'hammer_and_chisel',
  loc_txt = {
    name = 'Hammer and Chisel',
    text = {
      'Scored {C:attention}Stone Cards{} give',
      '{C:chips}+#3#{} chips and {C:mult}+#4#{} Mult with',
      'a {C:green}#1# in #2#{} chance of {C:attention}being{}',
      '{C:attention}destroyed{}',
    }
  },

  config = { extra = { chip_bonus = 10, mult_bonus = 2, shatter_odds = 10 } },
  unlocked = true,
  discovered = true,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 0, y = 3 },
  cost = 7,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.shatter_odds, card.ability.extra.chip_bonus, card.ability.extra.mult_bonus } }
  end,
  calculate = function(self, card, context)
    if context.before then
      card.ability.cards_to_shatter = {}
    end

    if context.individual and context.cardarea == G.play and context.other_card.debuff and context.other_card.config.center == G.P_CENTERS.m_stone then
      if pseudorandom('hammer_and_chisel') < G.GAME.probabilities.normal / card.ability.extra.shatter_odds then
        table.insert(card.ability.cards_to_shatter, context.other_card)
      end

      return {
        chips = card.ability.extra.chip_bonus,
        mult = card.ability.extra.mult_bonus,
        card = card
      }
    end

    if context.after then
      G.E_MANAGER:add_event(Event({
        func = function()
          for _, card_to_shatter in pairs(card.ability.cards_to_shatter) do
            card_to_shatter:shatter()
          end

          return true
        end
      }))
    end
  end
}
