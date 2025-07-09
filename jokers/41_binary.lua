SMODS.Joker {
  key = 'binary',
  loc_txt = {
    name = 'Binary Joker',
    text = {
      '{C:green}#1# in #2#{} chance for',
      '{C:chips}+#3#{} chips and {C:mult}+#4#{} Mult'
    }
  },

  config = { extra = { odds = 2, chips = 10, mult = 1 } },
  unlocked = true,
  discovered = true,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 2, y = 4 },
  cost = 4,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.chips, card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.joker_main and pseudorandom('binary') < G.GAME.probabilities.normal / card.ability.extra.odds then
      return {
        chips = card.ability.extra.chips,
        mult = card.ability.extra.mult,
        Xmult = card.ability.extra.x_mult,
      }
    end
  end
}
