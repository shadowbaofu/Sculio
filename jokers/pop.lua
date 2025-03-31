SMODS.Joker {
  key = 'pop',
  loc_txt = {
    name = 'Figurine',
    text = {
      'When a Joker with an {C:attention}edition{} is sold,',
      'this Joker gains the {C:attention}edition\'s bonus{}.',
      '{C:inactive}(Currently {C:chips}+#1#{}{C:inactive}, {C:mult}+#2#{}{C:inactive}, and {X:mult,C:white}X#3#{}{C:inactive})'
    }
  },

  config = { extra = { chips = 0, mult = 0, x_mult = 1 } },
  unlocked = true,
  discovered = true,
  rarity = 3, -- Rare
  atlas = 'Sculio',
  pos = { x = 3, y = 1 },
  cost = 10,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.x_mult } }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.selling_card and not context.blueprint then
      sold_joker = context.card

      if not sold_joker.debuff and sold_joker.edition then
        if sold_joker.edition.type == 'foil' then
          gain = 50
          message = localize { type = 'variable', key = 'a_chips', vars = { gain } }
          card.ability.extra.chips = card.ability.extra.chips + gain
        end

        if sold_joker.edition.type == 'holo' then
          gain = 10
          message = localize { type = 'variable', key = 'a_mult', vars = { gain } }
          card.ability.extra.mult = card.ability.extra.mult + gain
        end

        if sold_joker.edition.type == 'polychrome' then
          gain = 1.5
          message = '+ ' .. localize { type = 'variable', key = 'a_xmult', vars = { gain } }
          card.ability.extra.x_mult = card.ability.extra.x_mult + gain
        end
      end

      if message then
        G.E_MANAGER:add_event(Event({
          func = function()
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = message })
            return true
          end
        }))
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
