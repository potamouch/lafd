-- Lua script of custom entity collapsing_soil.
-- This script is executed every time a custom entity with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local entity = ...
local game = entity:get_game()
local map = entity:get_map()
local hero = map:get_hero()

-- Event called when the custom entity is initialized.
function entity:on_created()

  entity:set_modified_ground("traversable")
  entity:add_collision_test("touching", function(soil, entity_test)
      if entity_test:get_type() == "hero" then
        sol.timer.start(self, 2000, function()
          sol.audio.play_sound("ground_grumble")
          self:remove()
        end)
      end
  end)

end
