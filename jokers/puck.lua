SMODS.Joker {
  key = 'puck',
  loc_txt = {
    name = 'Puck',
    text = {
      'When a card with an {C:attention}edition{} is scored,',
      'this Joker gains {C:attention}half{} the {C:attention}edition\'s effect{}.',
      '{C:inactive}(Currently {C:chips}+#1#{}{C:inactive}, {C:mult}+#2#{}{C:inactive}, and {X:mult,C:white}X#3#{}{C:inactive})'
    }
  },

  config = { extra = { chips = 0, mult = 0, x_mult = 1 } },
  unlocked = true,
  discovered = true,
  rarity = 4, -- Legendary
  atlas = 'Sculio',
  pos = { x = 8, y = 1 },
  soul_pos = { x = 9, y = 1 },
  cost = 20,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.x_mult } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      message = nil

      if not context.other_card.debuff and context.other_card.edition then
        if context.other_card.edition.type == 'foil' then
          gain = 25
          message = localize { type = 'variable', key = 'a_chips', vars = { gain } }
          card.ability.extra.chips = card.ability.extra.chips + gain
        end

        if context.other_card.edition.type == 'holo' then
          gain = 5
          message = localize { type = 'variable', key = 'a_mult', vars = { gain } }
          card.ability.extra.mult = card.ability.extra.mult + gain
        end

        if context.other_card.edition.type == 'polychrome' then
          gain = 0.75
          message = '+ ' .. localize { type = 'variable', key = 'a_xmult', vars = { gain } }
          card.ability.extra.x_mult = card.ability.extra.x_mult + gain
        end
      end

      if message then
        return {
          extra = {
            message = message
          }
        }
      end
    end

    if context.joker_main then
      message = ''
      chip_mod = card.ability.extra.chips
      mult_mod = card.ability.extra.mult
      x_mult_mod = card.ability.extra.x_mult

      if chip_mod > 0 or mult_mod > 0 or x_mult_mod > 1 then
        if chip_mod > 1 then
          message = localize { type = 'variable', key = 'a_chips', vars = { chip_mod } }
        end

        if mult_mod > 0 then
          if chip_mod > 0 then
            message = message .. ', '
          end

          message = message .. localize { type = 'variable', key = 'a_mult', vars = { mult_mod } }
        end

        if x_mult_mod > 1 then
          if chip_mod > 0 or mult_mod > 0 then
            message = message .. ', '
          end

          message = message .. localize { type = 'variable', key = 'a_xmult', vars = { x_mult_mod } }
        end

        if chip_mod == 0 then
          chip_mod = nil
        end

        if mult_mod == 0 then
          mult_mod = nil
        end

        if x_mult_mod == 1 then
          x_mult_mod = nil
        end

        if message == '' then
          message = nil
        end

        return {
          chip_mod = chip_mod,
          mult_mod = mult_mod,
          Xmult_mod = x_mult_mod,
          message = message
        }
      end
    end
  end
}
