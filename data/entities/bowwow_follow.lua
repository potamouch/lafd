local bowwow = ...

local game = bowwow:get_game()
local map = bowwow:get_map()
local sprite = bowwow:get_sprite()
local hero = game:get_hero()
local movement

bowwow:set_optimization_distance(0)
bowwow:set_drawn_in_y_order(true)
bowwow:set_traversable_by(true)
bowwow:set_traversable_by("hero", false)
bowwow:set_can_traverse("enemy", true)
bowwow:set_can_traverse("npc", true)
bowwow:set_can_traverse("sensor", true)
bowwow:set_can_traverse("separator", true)
bowwow:set_can_traverse("stairs", true)
bowwow:set_can_traverse("teletransporter", true)

-- TODO make this available to other scripts.
local function follow_hero()

  movement = sol.movement.create("target")
  movement:set_speed(100)
  movement:set_ignore_obstacles(true)
  movement:start(bowwow)
  game.bowwow_following = true
  sprite:set_animation("walking")

  bowwow:set_can_traverse("hero", true)
  bowwow:set_traversable_by("hero", true)
end

-- Stops for now because too close or too far.
local function stop_walking()

  bowwow:stop_movement()
  movement = nil
  sprite:set_animation("stopped")
end

function bowwow:on_created()
game.bowwow_following = true
  if bowwow:is_following_hero() then
    bowwow:set_position(hero:get_position())
    bowwow:get_sprite():set_direction(hero:get_direction())
    follow_hero()
    return
  end

  bowwow:set_enabled(true)
end

function bowwow:on_interaction()

  
end

function bowwow:on_movement_changed()

  local movement = bowwow:get_movement()
  if movement:get_speed() > 0 then
    if hero:get_state() ~= "stairs" or map:get_id() == "outside/a2" then
      sprite:set_direction(movement:get_direction4())
    end
    if sprite:get_animation() ~= "walking" then
      sprite:set_animation("walking")
    end
  end
end

function bowwow:on_position_changed()


  local distance = bowwow:get_distance(hero)
  if bowwow:is_following_hero() and bowwow:is_very_close_to_hero() then
    -- Close enough to the hero: stop.
    stop_walking()
  end

end

function bowwow:on_obstacle_reached()

  sprite:set_animation("stopped")
end

function bowwow:on_movement_finished()

  sprite:set_animation("stopped")
end

-- Returns whether Zelda is currently following the hero.
-- This is true even if she is temporarily stopped because too far
-- or to close.
function bowwow:is_following_hero()
  -- This is stored on the game because it persists accross maps,
  -- but this is not saved.
  return game.bowwow_following
end

function bowwow:is_very_close_to_hero()

  local distance = bowwow:get_distance(hero)
  return distance < 32
end

function bowwow:is_far_from_hero()

  local distance = bowwow:get_distance(hero)
  return distance >= 100
end

-- Called when the hero leaves a map without Zelda when he was supposed to wait for her.
function bowwow:hero_gone()

  -- Zelda will be back to the prison cell.
  game.bowwow_following = false
end

sol.timer.start(bowwow, 50, function()

  if bowwow:is_following_hero() then
    if movement == nil and not bowwow:is_very_close_to_hero() and not bowwow:is_far_from_hero() then
      -- Restart.
      follow_hero()
    elseif movement ~= nil and bowwow:is_far_from_hero() then
      -- Too far: stop.
      stop_walking()
    end
  end

  if hero:get_state() == "stairs" and bowwow:is_following_hero() and not bowwow:is_far_from_hero() then
    bowwow:set_position(hero:get_position())
    if hero:get_movement() ~= nil then
      sprite:set_direction(hero:get_movement():get_direction4())
    end
  end

  return true
end)
