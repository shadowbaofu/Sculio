Sculio = SMODS.current_mod

SMODS.Atlas {
  -- Key for code to find it with
  key = 'Sculio',
  -- The name of the file, for the code to pull the atlas from
  path = 'Sculio.png', -- Original file sourced from https://github.com/Steamodded/examples/tree/master/Mods/ExampleJokersMod/assets
  -- Width of each sprite in 1x size
  px = 71,
  -- Height of each sprite in 1x size
  py = 95
}

-- Load Jokers: https://github.com/neatoqueen/NeatoJokers/blob/main/NeatoJokers.lua#L32
local subdir = 'jokers'
local cards = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)
for _, filename in pairs(cards) do
    assert(SMODS.load_file(subdir .. '/' .. filename))()
end
