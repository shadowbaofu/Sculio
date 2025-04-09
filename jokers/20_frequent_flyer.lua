SMODS.Joker {
  key = 'frequent_flyer',
  loc_txt = {
    name = 'Frequent Flyer',
    text = {
      'For every {C:money}$#4#{} {C:inactive}[$#5#]{} spent',
      'in shop, earn {C:money}$#1#{}',
      'and {C:mult}+#3# Mult{}',
      '{C:inactive}(Currently {C:mult}+#2# Mult{}{C:inactive})'
    }
  },

  config = { extra = { money_gain = 3, mult = 0, mult_gain = 4, spend_per_gain = 15, spent_since_gain = 0 } },
  unlocked = true,
  discovered = true,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 1, y = 2 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money_gain, card.ability.extra.mult, card.ability.extra.mult_gain, card.ability.extra.spend_per_gain, card.ability.extra.spent_since_gain } }
  end,
  calculate = function(self, card, context)
    if (context.buying_card or context.open_booster) and not context.blueprint then
      card.ability.extra.spent_since_gain = card.ability.extra.spent_since_gain + context.card.cost

      if card.ability.extra.spent_since_gain >= card.ability.extra.spend_per_gain then
        ease_dollars(card.ability.extra.money_gain)
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
        card.ability.extra.spent_since_gain = card.ability.extra.spent_since_gain - card.ability.extra.spend_per_gain

        return { message = '$' .. card.ability.extra.money_gain .. ' & ' .. localize('k_upgrade_ex') }
      end
    end

    if context.joker_main and card.ability.extra.mult > 0 then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end
  end
}
