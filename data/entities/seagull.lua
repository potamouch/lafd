-- Lua script of custom entity frog.
-- This script is executed every time a custom entity with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local seagull = ...
local game = seagull:get_game()
local map = game:get_map()
local sprite = seagull:get_sprite()
local hero = game:get_hero()
local movement
local x
local y
local layer
local is_escape = false
local is_move = false
-- Event called when the custom entity is initialized.
function seagull:on_created()

  x,y,layer = seagull:get_position()
  seagull:set_can_traverse(true)
  sol.timer.start(seagull, 50, function()
          if hero:get_distance(seagull) < 24 and is_escape == false and is_move == false then
            seagull:escape_hero()
          end
          if hero:get_distance(x,y) > 50 and is_escape == true and is_move == false  then
            seagull:join_origin()
          end
    return true
  end)


end

function seagull:escape_hero()

  is_move = true
  sol.audio.play_sound("seagull")
  -- Set the sprite.
  sprite:set_animation("walking")
  sprite:set_direction(1)
  -- Set the movement.
  movement = sol.movement.create("straight")
  movement:set_speed(100)
  movement:set_max_distance(320)
  movement:set_ignore_obstacles(true)
  movement:start(seagull)
  function movement:on_finished()
    is_escape = true
    is_move = false
  end
end

function seagull:join_origin()

 print("join")
  is_move = true
  -- Set the sprite.
  sprite:set_animation("walking")
  sprite:set_direction(3)
  -- Set the movement.
  movement = sol.movement.create("target")
  movement:set_target(x, y)
  movement:set_speed(100)
  movement:set_ignore_obstacles(true)
  movement:start(seagull)
  function movement:on_finished()
    sprite:set_animation("stopped")
    is_escape = false
    is_move = false
    sol.audio.play_sound("seagull")
  end
end

