SMODS.Joker {
  key = 'nametag',
  loc_txt = {
    name = 'Nametag',
    text = {
      '{X:red,C:white} X#1# {} Mult for each',
      '{C:attention}base game Joker{}',
      'with {C:attention}"Joker"{} in its name',
      '{C:inactive}(Currently {X:red,C:white} X#2# {C:inactive} Mult)',
    }
  },

  config = { extra = { x_mult = 0.75 } },
  unlocked = true,
  discovered = true,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 1, y = 4 },
  cost = 6,
  blueprint_compat = true,
  get_x_mult_mod = function(self, card)
    named_jokers = 0

    -- TODO: Make work
    for k, v in ipairs(G.jokers.cards) do
      if v.ability.name:find('Joker') then
        named_jokers = named_jokers + 1
      end
    end

    return (named_jokers * card.ability.extra.x_mult) + 1
  end,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult, self:get_x_mult_mod(card) } }
  end,
  calculate = function(self, card, context)
    x_mult_mod = self:get_x_mult_mod(card)

    if context.joker_main and x_mult_mod > 1 then
      return {
        Xmult_mod = x_mult_mod,
        message = localize { type = 'variable', key = 'a_xmult', vars = { x_mult_mod } }
      }
    end
  end
}
