-- Lua script of item melody_1.
-- This script is executed only once for the whole game.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local item = ...
local game = item:get_game()

-- Event called when the game is initialized.
function item:on_started()

  self:set_savegame_variable("possession_melody_1")
  self:set_assignable(true)

end

-- Event called when the hero is using this item.
function item:on_using()

    local map = game:get_map()
    local hero = map:get_hero()
    local ocarina = game:get_item("ocarina")
    ocarina:playing_song("items/ocarina_1")

    item:set_finished()
end

-- Event called when a pickable treasure representing this item
-- is created on the map.
function item:on_pickable_created(pickable)

  -- You can set a particular movement here if you don't like the default one.
end
