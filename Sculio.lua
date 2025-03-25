SMODS.Atlas {
  -- Key for code to find it with
  key = "Sculio",
  -- The name of the file, for the code to pull the atlas from
  path = "Sculio.png", -- Original file sourced from https://github.com/Steamodded/examples/tree/master/Mods/ExampleJokersMod/assets
  -- Width of each sprite in 1x size
  px = 71,
  -- Height of each sprite in 1x size
  py = 95
}

SMODS.Joker {
  key = 'schrodinger',
  loc_txt = {
    name = 'Schrodinger\'s Joker',
    text = {
      "{C:attention}#1# in #2#{} chance",
      "for {X:mult,C:white}X#3#{} Mult"
    }
  },

  config = { extra = { odds = 2, x_mult = 2 } },
  unlocked = true,
  discovered = true,
  rarity = 1, -- Common
  atlas = 'Sculio',
  pos = { x = 0, y = 0 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = { (G.GAME.probabilities.normal or 1), self.config.extra.odds, self.config.extra.x_mult } }
  end,
  calculate = function(self, card, context)
    if context.joker_main and pseudorandom('schrodinger') < G.GAME.probabilities.normal / self.config.extra.odds then
      return {
        Xmult_mod = card.ability.extra.x_mult,
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
      }
    end
  end
}

SMODS.Joker {
  key = 'stonks',
  loc_txt = {
    name = 'Wall Street Joker',
    text = {
      "The {C:mult}+Mult{} for this Joker",
      "{C:attention}doubles{} after every boss blind",
      "{C:inactive}(Currently {C:mult}+#1#{}{C:inactive})"
    }
  },

  config = { extra = { mult = 2 } },
  unlocked = true,
  discovered = true,
  rarity = 2, -- Uncommon
  atlas = 'Sculio',
  pos = { x = 4, y = 0 },
  cost = 7,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult_mod = card.ability.extra.mult,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
      }
    end

    if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint and G.GAME.blind.boss then
      card.ability.extra.mult = card.ability.extra.mult * 2
      return { message = localize('k_upgrade_ex') }
    end
  end
}
