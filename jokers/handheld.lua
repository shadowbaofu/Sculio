SMODS.Joker {
  key = 'handheld',
  loc_txt = {
    name = 'Handheld',
    text = {
      'Scored {C:clubs}Clubs{} and {C:spades}Spades{} become',
      '{C:attention}Wild Cards{} if they are not',
      'already enhanced'
      
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
