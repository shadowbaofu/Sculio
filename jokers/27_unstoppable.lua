SMODS.Joker {
  key = 'unstoppable',
  loc_txt = {
    name = 'Unstoppable Force',
    text = {
      'When this Joker is {C:attention}sold{}, it',
      'gains {X:mult,C:white} X#2# {} Mult and',
      '{C:attention}returns to the next shop{}',
      '{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)',
    }
  },

  config = { initialized = false, extra = { x_mult = 1, x_mult_gain = 0.25 } },
  unlocked = true,
  discovered = true,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 8, y = 2 },
  cost = 7,
  eternal_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
  end,
  calculate = function(self, card, context)
    if not card.initialized then
      -- Set sell cost to $0.
      card.ability.extra_value = (card.ability.extra_value or 0) - card.sell_cost
      card:set_cost()

      initialized = true
    end

    if context.joker_main and card.ability.extra.x_mult > 1 then
      return {
        Xmult_mod = card.ability.extra.x_mult,
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
      }
    end

    if context.selling_self then
      tag = Tag('tag_Sculio_unstoppable')
      tag.ability.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain

      G.E_MANAGER:add_event(Event({
        func = (function()
          add_tag(tag)
          play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
          play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
          return true
        end)
      }))
    end
  end
}

SMODS.Tag {
  key = 'unstoppable',
  loc_txt = {
    name = 'Unstoppable Force Tag',
    text = {
      'Shop has the Joker',
      '{C:attention}Unstoppable Force{}',
      'with {X:mult,C:white} X#1# {} Mult'
    }
  },
  in_pool = function(self, args)
    return false
  end,
  loc_vars = function(self, info_queue, tag)
    return { vars = { (tag.ability and tag.ability.x_mult) or 1 } }
  end,
  apply = function(self, tag, context)
    if context.type == 'store_joker_create' then
      card = create_card('Joker', context.area, nil, 0, nil, nil, 'j_Sculio_unstoppable', 'uta')
      card.ability.extra.x_mult = tag.ability.x_mult
      create_shop_card_ui(card, 'Joker', context.area)
      card.states.visible = false
      tag:yep('+', G.C.RED,function() 
        card:start_materialize()
        return true
      end)

      tag.triggered = true
      return card
    end
  end
}