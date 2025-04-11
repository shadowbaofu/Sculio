SMODS.Joker {
  key = 'rorshach',
  loc_txt = {
    name = 'Rorshach',
    text = {
      'Cards in the {C:attention}first{}',
      '{C:attention}discard{} will be {C:attention}drawn{}',
      '{C:attention}first{} in the {C:attention}next blind{}'
    }
  },

  config = { extra = { card_ids_to_draw_next = {} } },
  unlocked = true,
  discovered = true,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 5, y = 3 },
  cost = 6,
  -- See shuffle.lua for additional implementation code.
  calculate = function(self, card, context)
    if context.first_hand_drawn and not context.blueprint then
      local eval = function() return G.GAME.current_round.discards_used == 0 end
      juice_card_until(card, eval, true)
    end

    if context.discard and G.GAME.current_round.discards_used <= 0 and context.other_card.ID == context.full_hand[1].ID and not context.blueprint then
      card.ability.extra.card_ids_to_draw_next = {}

      for _, v in ipairs(context.full_hand) do
        table.insert(card.ability.extra.card_ids_to_draw_next, v.ID)
      end

      return {
        message = 'See you soon!'
      }
    end
  end
}
