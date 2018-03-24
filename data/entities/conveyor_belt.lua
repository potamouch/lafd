-- Lua script of custom entity conveyor_belt.
-- This script is executed every time a custom entity with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local entity = ...
local game = entity:get_game()
local map = entity:get_map()

-- Event called when the custom entity is initialized.
function entity:on_created()

  self:add_collision_test("containing", function(entity, other, entity_sprite, other_sprite)
    if other:get_type() == "pickable" then
      local direction = entity:get_direction()
      local movement = sol.movement.create("straight")
      local angle = direction * math.pi / 2
      movement:set_speed(20)
      movement:set_angle(angle)
      movement:set_max_distance(16)
      movement:set_ignore_obstacles(true)
      movement:start(other)
    end
  end)
end
