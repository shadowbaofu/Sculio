SMODS.Joker {
  key = 'scheming_idol',
  loc_txt = {
    name = 'Scheming Idol',
    text = {
      'Copies ability of all',
      '{C:attention}Common Jokers{}'
    }
  },

  unlocked = true,
  discovered = true,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 5, y = 2 },
  cost = 10,
  calculate = function(self, card, context)
    if context.post_trigger and context.other_card.config.center.rarity == 1 then
      return_val = SMODS.blueprint_effect(card, context.other_card, context.other_context)
      return_val.card = card
      return_val.focus = card

      if return_val.extra then
        return_val.extra.focus = card
      end

      return return_val
    end
  end
}
