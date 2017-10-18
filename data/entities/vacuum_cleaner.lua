-- Vacuum cleaner: makes lava and holes become traversable ground.
local entity = ...
local map = entity:get_map()
local game = map:get_game()
local hero = map:get_hero()

local speed = 30 -- Change this for a different speed.
local needs_destruction -- Destroy if "action" or "attack" commads are pressed.
local next_direction

function entity:on_created()
  self:set_traversable_by(false)
  self:set_can_traverse_ground("lava", true)
  self:set_can_traverse_ground("hole", true)
  for _, ground in pairs({"empty", "traversable", "wall",
      "low_wall", "wall_top_right", "wall_top_left", "wall_bottom_left",
      "wall_bottom_right", "wall_top_right_water", "wall_top_left_water", 
      "wall_bottom_left_water", "wall_bottom_right_water", "deep_water",
      "shallow_water", "grass", "ice", "ladder", "prickles"}) do
    self:set_can_traverse_ground(ground, false)
  end
end

-- Return the direction pressed, if any.
-- Return nil if no direction or more than one direction is pressed.
function entity:get_direction_pressed()
  local dir_names = {[0] = "right", "up", "left", "down"}
  local dir_pressed
  local num_directions = 0
  for dir = 0, 3 do
    if game:is_command_pressed(dir_names[dir]) then
      num_directions = num_directions + 1
      dir_pressed = dir
    end
  end
  if num_directions ~= 1 then return end
  return dir_pressed
end

function entity:check_commands_pressed()
  -- Check if needs destruction.
  sol.timer.start(entity, 20, function()
    if game:is_command_pressed("action")
        or game:is_command_pressed("attack") then
      --needs_destruction = true
      return true -- Stop timer.
    end
    return true -- Repeat timer.
  end)
  -- Update new direction if necessary.
  sol.timer.start(entity, 20, function()
    local dir = self:get_direction_pressed()
    if dir ~= nil then
      next_direction = dir
      return false -- Stop timer.
    end
    return true -- Repeat timer.
  end)
end

function entity:move()
  sol.timer.stop_all(self)
  self:check_commands_pressed()
  -- TODO: start the moving sound with a timer.

  -- Create movement.
  local m = sol.movement.create("path")
  m:set_path({2*next_direction, 2*next_direction}) -- Move 16 pixels.
  m:set_speed(speed)
  m:set_snap_to_grid(true)
  m:start(self)
  -- Destroy if an "obstacle ground" is reached.
  function m:on_obstacle_reached() entity:remove() end
  -- Continue movement or destroy if necessary.
  function m:on_finished()
    if needs_destruction then entity:remove() end
    entity:move()
  end
end

-- Start using the vacuum cleaner.
function entity:on_interaction()
  hero:freeze()
  hero:set_invincible()
  next_direction = hero:get_direction()
  self:move()
end

function entity:on_removed()
  -- TODO: make the disappearing effects: sound and animation.
  hero:set_invincible(false)
  hero:unfreeze()  
end