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
local timer = nil
local hero_is_on_soil = false

-- Event called when the custom entity is initialized.
function entity:on_created()
  
  self:set_modified_ground("traversable")
  sol.timer.start(self, 50, function()
    local distance = self:get_distance(hero)
    if distance <=8 then
        if hero_is_on_soil == false then
          hero_is_on_soil = true
          sol.timer.start(self, 3000, function()
            if hero_is_on_soil then
              sol.audio.play_sound("ground_grumble")
              self:remove()
            end
        end)
      end
    else
      hero_is_on_soil = false
    end
    return true
  end)
end
