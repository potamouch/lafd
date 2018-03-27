local marin = ...

local game = marin:get_game()
local map = game:get_map()
local sprite = marin:get_sprite()
local hero = game:get_hero()
local movement

marin:set_optimization_distance(0)
marin:set_drawn_in_y_order(true)

marin:set_traversable_by(true)
marin:set_traversable_by("hero", false)

marin:set_can_traverse("enemy", true)
marin:set_can_traverse("npc", true)
marin:set_can_traverse("sensor", true)
marin:set_can_traverse("separator", true)
marin:set_can_traverse("stairs", true)
marin:set_can_traverse("teletransporter", true)

-- TODO make this available to other scripts.
local function follow_hero()

  movement = sol.movement.create("target")
  movement:set_speed(100)
  movement:start(marin)
  game.marin_following = true
  sprite:set_animation("walking")

  marin:set_can_traverse("hero", true)
  marin:set_traversable_by("hero", true)
end

-- Stops for now because too close or too far.
local function stop_walking()

  marin:stop_movement()
  movement = nil
  sprite:set_animation("stopped")
end

function marin:on_created()
game.marin_following = true
  if marin:is_following_hero() then
    marin:set_position(hero:get_position())
    marin:get_sprite():set_direction(hero:get_direction())
    follow_hero()
    return
  end

  marin:set_enabled(true)
end

function marin:on_interaction()

  
end

function marin:on_movement_changed()

  local movement = marin:get_movement()
  if movement:get_speed() > 0 then
    if hero:get_state() ~= "stairs" or map:get_id() == "outside/a2" then
      sprite:set_direction(movement:get_direction4())
    end
    if sprite:get_animation() ~= "walking" then
      sprite:set_animation("walking")
    end
  end
end

function marin:on_position_changed()


  local distance = marin:get_distance(hero)
  if marin:is_following_hero() and marin:is_very_close_to_hero() then
    -- Close enough to the hero: stop.
    stop_walking()
  end

end

function marin:on_obstacle_reached()

  sprite:set_animation("stopped")
end

function marin:on_movement_finished()

  sprite:set_animation("stopped")
end

-- Returns whether Zelda is currently following the hero.
-- This is true even if she is temporarily stopped because too far
-- or to close.
function marin:is_following_hero()
  -- This is stored on the game because it persists accross maps,
  -- but this is not saved.
  return game.marin_following
end

function marin:is_very_close_to_hero()

  local distance = marin:get_distance(hero)
  return distance < 32
end

function marin:is_far_from_hero()

  local distance = marin:get_distance(hero)
  return distance >= 100
end

-- Called when the hero leaves a map without Zelda when he was supposed to wait for her.
function marin:hero_gone()

  -- Zelda will be back to the prison cell.
  game.marin_following = false
end

sol.timer.start(marin, 50, function()

  if marin:is_following_hero() then
    if movement == nil and not marin:is_very_close_to_hero() and not marin:is_far_from_hero() then
      -- Restart.
      follow_hero()
    elseif movement ~= nil and marin:is_far_from_hero() then
      -- Too far: stop.
      stop_walking()
    end
  end

  if hero:get_state() == "stairs" and marin:is_following_hero() and not marin:is_far_from_hero() then
    marin:set_position(hero:get_position())
    if hero:get_movement() ~= nil then
      sprite:set_direction(hero:get_movement():get_direction4())
    end
  end

  return true
end)
