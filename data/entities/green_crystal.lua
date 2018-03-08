-- Lua script of custom entity green_crystal.
-- This script is executed every time a custom entity with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local entity = ...
local game = entity:get_game()
local hero = game:get_hero()
local map = entity:get_map()
local sprite = entity:get_sprite()
local is_destroy = false

-- Event called when the custom entity is initialized.
function entity:on_created()

  entity:set_traversable_by("hero", false)
  entity:set_traversable_by("enemy", false)

end

-- Event called when the custom entity is initialized.
function entity:on_interaction()

      game:start_dialog("_cannot_break_without_boots");

end

local function on_collision(crystal, other, crystal_sprite, other_sprite)

  if is_destroy == false and other:get_type() =="hero" and hero:get_state() == "running" then
    sol.audio.play_sound("stone")
    sprite:set_animation('destroy')
    is_destroy = true
    entity:set_traversable_by("hero", true)
    sol.timer.start(entity, 1000, function()
      entity:remove()
    end)
  end

end

entity:add_collision_test("facing", on_collision)
