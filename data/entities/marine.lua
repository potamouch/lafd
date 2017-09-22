local marine = ...

local game = marine:get_game()
local map = game:get_map()
local sprite = marine:get_sprite()
local hero = game:get_hero()
local movement

marine:set_optimization_distance(0)
marine:set_drawn_in_y_order(true)

marine:set_traversable_by(true)
marine:set_traversable_by("hero", false)

marine:set_can_traverse("enemy", true)
marine:set_can_traverse("npc", true)
marine:set_can_traverse("sensor", true)
marine:set_can_traverse("separator", true)
marine:set_can_traverse("stairs", true)
marine:set_can_traverse("teletransporter", true)

-- TODO make this available to other scripts.
local function follow_hero()

  movement = sol.movement.create("target")
  movement:set_speed(100)
  movement:start(marine)
  game.marine_following = true
  sprite:set_animation("walking")

  marine:set_can_traverse("hero", true)
  marine:set_traversable_by("hero", true)
end

-- Stops for now because too close or too far.
local function stop_walking()

  marine:stop_movement()
  movement = nil
  sprite:set_animation("stopped")
end

function marine:on_created()
game.marine_following = true
  if marine:is_following_hero() then
    marine:set_position(hero:get_position())
    marine:get_sprite():set_direction(hero:get_direction())
    follow_hero()
    return
  end

  marine:set_enabled(true)
end

function marine:on_interaction()

  
end

function marine:on_movement_changed()

  local movement = marine:get_movement()
  if movement:get_speed() > 0 then
    if hero:get_state() ~= "stairs" or map:get_id() == "outside/a2" then
      sprite:set_direction(movement:get_direction4())
    end
    if sprite:get_animation() ~= "walking" then
      sprite:set_animation("walking")
    end
  end
end

function marine:on_position_changed()


  local distance = marine:get_distance(hero)
  if marine:is_following_hero() and marine:is_very_close_to_hero() then
    -- Close enough to the hero: stop.
    stop_walking()
  end

end

function marine:on_obstacle_reached()

  sprite:set_animation("stopped")
end

function marine:on_movement_finished()

  sprite:set_animation("stopped")
end

-- Returns whether Zelda is currently following the hero.
-- This is true even if she is temporarily stopped because too far
-- or to close.
function marine:is_following_hero()
  -- This is stored on the game because it persists accross maps,
  -- but this is not saved.
  return game.marine_following
end

function marine:is_very_close_to_hero()

  local distance = marine:get_distance(hero)
  return distance < 32
end

function marine:is_far_from_hero()

  local distance = marine:get_distance(hero)
  return distance >= 100
end

-- Called when the hero leaves a map without Zelda when he was supposed to wait for her.
function marine:hero_gone()

  -- Zelda will be back to the prison cell.
  game.marine_following = false
end

sol.timer.start(marine, 50, function()

  if marine:is_following_hero() then
    if movement == nil and not marine:is_very_close_to_hero() and not marine:is_far_from_hero() then
      -- Restart.
      follow_hero()
    elseif movement ~= nil and marine:is_far_from_hero() then
      -- Too far: stop.
      stop_walking()
    end
  end

  if hero:get_state() == "stairs" and marine:is_following_hero() and not marine:is_far_from_hero() then
    marine:set_position(hero:get_position())
    if hero:get_movement() ~= nil then
      sprite:set_direction(hero:get_movement():get_direction4())
    end
  end

  return true
end)
