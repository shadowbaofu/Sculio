SMODS.Joker {
  key = 'mahjong',
  loc_txt = {
    name = 'Mahjong',
    text = {
      '{C:mult}+#1#{} Mult if even number of cards',
      'played and half are less than #2#'
    }
  },

  config = { extra = { mult = 5, less_than = 7 } },
  unlocked = true,
  discovered = true,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 3, y = 4 },
  cost = 4,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult, card.ability.extra.less_than } }
  end,
  calculate = function(self, card, context)
    if context.joker_main and (#context.full_hand == 2 or #context.full_hand == 4) then
      less_than_count = 0

      for i = 1, #context.full_hand do
        if context.full_hand[i]:get_id() < card.ability.extra.less_than then
          less_than_count = less_than_count + 1
        end
      end

      if less_than_count == #context.full_hand / 2 then
        return {
          mult_mod = card.ability.extra.mult,
          message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
        }
      end
    end
  end
}
