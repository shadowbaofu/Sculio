SMODS.Joker {
  key = 'verified',
  loc_txt = {
    name = 'Verified User',
    text = {
      'Cards with a {C:blue}Blue Seal{}',
      'get drawn first'
    }
  },

  config = { extra = { x_mult = 1, x_mult_gain = 0.25 } },
  unlocked = true,
  discovered = true,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 3, y = 0 },
  cost = 8
  -- See shuffle.lua for relevant implementation code.
}
