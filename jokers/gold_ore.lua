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
        if v.debuff == false and v.config.center == G.P_CENTERS.m_stone and not v.debuff and not v.vampired then 
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
