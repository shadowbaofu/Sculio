SMODS.Joker {
  key = 'beyond_reach',
  loc_txt = {
    name = 'Beyond Reach',
    text = {
      'Permanently gain {C:blue}+#1#{} hand if',
      'chips scored in the {C:attention}last hand{} of a Blind',
      'is at least {C:attention}#2#%{} of required chips.'
    }
  },

  config = { extra = { hands_gain = 1, required_score_percentage = 95 } },
  unlocked = true,
  discovered = true,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 5, y = 1 },
  cost = 9,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.hands_gain, card.ability.extra.required_score_percentage } }
  end,
  calculate = function(self, card, context)
    if context.final_scoring_step then
      G.E_MANAGER:add_event(Event({
        func = function()
          card.ability.current_hand_chips = G.GAME.current_round.current_hand.chips
          card.ability.current_hand_mult = G.GAME.current_round.current_hand.mult

          return true
        end
      }))
    end

    if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint and card.ability.current_hand_chips and card.ability.current_hand_mult then
      local chips = card.ability.current_hand_chips
      local mult = card.ability.current_hand_mult
      local required_score = G.ARGS.score_intensity.required_score

      if G.GAME.selected_back:get_name() == "Plasma Deck" then
        local total = chips + mult
        chips = math.floor(total / 2)
        mult = math.floor(total / 2)
      end

      local score = chips * mult

      if required_score > 0 and score >= (required_score * (card.ability.extra.required_score_percentage / 100)) then
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1

        return { message = '+1 Hand' }
      end
    end
  end
}
