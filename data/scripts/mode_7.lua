-- Experimental mode 7 testing code.

local mode_7_manager = {}

function mode_7_manager:teleport(game, destination_map_id, destination_name)

  local mode_7 = {}

  assert(game ~= nil)
  assert(sol.main.get_type(game) == "game")
  assert(destination_map_id ~= nil)

  local map_texture = sol.surface.create("work/world_map_scale_1.png")
  assert(map_texture ~= nil)
  local overlay_texture = sol.surface.create(320, 240)
  -- local character_texture = -- TODO
  -- character_texture:draw(overlay_texture, 112, 120)
  local shader = sol.shader.create("mode_7")
  shader:set_uniform("mode_7_texture", map_texture)
  shader:set_uniform("overlay_texture", overlay_texture)
  shader:set_uniform("repeat_texture", false)
  shader:set_uniform("horizon", 1.25)
  local position = { 0.5, 1.0, 0.08 }
  local z_timer
  local angle = 0.0
  local angle_timer

  local function update_position()
    shader:set_uniform("character_position", position)
    shader:set_uniform("angle", angle)
  end

  function mode_7:on_started()

    local xy_timer = sol.timer.start(mode_7, 30, function()
      local increment = 0.001
      position[1] = position[1] + increment * math.sin(angle)
      position[2] = position[2] - increment * math.cos(angle)
      update_position()
      return true
    end)
    update_position()
    sol.audio.play_music("scripts/menus/title_screen_no_intro")
    sol.video.set_shader(shader)
    print("started")
  end

  function mode_7:on_command_pressed(command)
    print(command)
    if command == "right" or command == "left" then
      mode_7:update_angle()
      return true
    elseif command == "up" or command == "down" then
      mode_7:update_z()
      return true
    end
  end

  function mode_7:on_command_released(command)
    if command == "right" or command == "left" then
      mode_7:update_angle()
      return true
    elseif command == "up" or command == "down" then
      mode_7:update_z()
      return true
    end
  end

  function mode_7:update_angle()

    local increment = math.pi / 120.0
    local delay = 30
    
    if game:is_command_pressed("right") and not game:is_command_pressed("left") then
      if angle_timer ~= nil then
        angle_timer:stop()
      end
      angle_timer = sol.timer.start(mode_7, delay, function()
        angle = angle + increment
        update_position()
        return true
      end)
      update_position()
    elseif game:is_command_pressed("left") and not game:is_command_pressed("right") then
      if angle_timer ~= nil then
        angle_timer:stop()
      end
      angle_timer = sol.timer.start(mode_7, delay, function()
        angle = angle - increment
        update_position()
        return true
      end)
    else
      if angle_timer ~= nil then
        angle_timer:stop()
      end
    end
  end

  function mode_7:update_z()
  
    if game:is_command_pressed("up") and not game:is_command_pressed("down") then
      -- TODO
      update_position()
    elseif game:is_command_pressed("down") and not game:is_command_pressed("up") then
      update_position()
    end
  end

  sol.menu.start(game, mode_7)
end

return mode_7_manager
