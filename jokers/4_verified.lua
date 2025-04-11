local old_shuffle = CardArea.shuffle

-- Credit: Somethingcom515 {SealsOnAll}
function CardArea:shuffle(_seed)
  local g = old_shuffle(self, _seed)

  is_verified = false

  for i = 1, #G.jokers.cards do
    if G.jokers.cards[i] and G.jokers.cards[i].ability.name == 'j_Sculio_verified' then is_verified = true; break end
  end

  if self == G.deck and is_verified then
    local priorities = {}
    local others = {}

    for k, v in pairs(self.cards) do
      if v.seal == 'Blue' then
        table.insert(priorities, v)
      else
        table.insert(others, v)
      end
    end

    for _, card in ipairs(priorities) do
      table.insert(others, card)
    end

    self.cards = others
    self:set_ranks()
  end

  return g
end

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
}
