SMODS.Joker {
  key = 'prescription',
  loc_txt = {
    name = 'Prescription',
    text = {
      'After {C:attention}#1#{} rounds,',
      'sell this card to {C:attention}remove{}',
      'all {C:attention}Eternal{}, {C:attention}Perishable{}',
      'and {C:attention}Rental{} stickers',
      'from all owned {C:attention}Jokers{}.',
      'Rebuffs {C:attention}debuffed Jokers{}',
      '{C:inactive}(Currently {C:attention}#2#{C:inactive} / #1#)'
    }
  },

  config = { extra = { rounds_until_active = 2, rounds_elapsed = 0 } },
  unlocked = true,
  discovered = true,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 1, y = 3 },
  cost = 8,
  eternal_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.rounds_until_active, card.ability.extra.rounds_elapsed } }
  end,
  calculate = function(self, card, context)
    -- Based off of Invisible Joker.
    if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
      card.ability.extra.rounds_elapsed = card.ability.extra.rounds_elapsed + 1

      if card.ability.extra.rounds_elapsed >= card.ability.extra.rounds_until_active then
        local eval = function(card) return not card.REMOVED end
        juice_card_until(card, eval, true)
      end

      return {
        message = (card.ability.extra.rounds_elapsed < card.ability.extra.rounds_until_active) and (card.ability.extra.rounds_elapsed .. '/' .. card.ability.extra.rounds_until_active) or localize('k_active_ex'),
        colour = G.C.FILTER
      }
    end

    if context.selling_self and card.ability.extra.rounds_elapsed >= card.ability.extra.rounds_until_active then
      for k, v in ipairs(G.jokers.cards) do
        v:set_eternal(false)
        v.ability.perishable = false
        v:set_rental(false)
        v:set_debuff(false)
      end
    end
  end
}
