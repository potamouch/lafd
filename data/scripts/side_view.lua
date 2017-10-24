require("scripts/multi_events")
local game_manager = {}
local game_over_menu = {}
local map_meta = sol.main.get_metatable("map")
local gravity = 5       -- How often to update gravity in milliseconds (move the hero down one pixel this often). Default is every 10 ms.
local jump_height = 40  -- How high to make the hero go when he jumps (in pixels). Default is 40.
local state             -- "stopped", "walking", "jumping", "ladder", "dying", "action", "attack"
local last_anim
map_meta.side_view = false



function map_meta:is_side_view()

  if self:get_side_view() then
    return true
  end
  
  return false

end

function map_meta:get_side_view()

  return self.side_view

end

function map_meta:set_side_view(active)

  self.side_view = active
  if active then
  end
  self:launch_side_view()
end
 
function map_meta:launch_side_view()

    local game = self:get_game()
    sol.timer.start(gravity, function()
        local hero = self:get_hero()
        local state = hero:get_state()
        local item_feather = game:get_item("feather")
        if item_feather:is_jumping() then
          state = "jumping"
        end
        if state == "jumping" then
          hero:set_walking_speed(120)
        else
          hero:set_walking_speed(88)
        end
        local x, y, l = hero:get_position()
        if state ~= "jumping" then
          if self:get_ground(x, y, l) ~= "ladder"  and self:get_ground(x, y + 8, l) == "ladder" then 
            -- Nothing
          elseif self:get_ground(hero:get_position()) ~= "ladder" then
            if not hero:test_obstacles(0, 1) then 
              hero:set_position(x, (y + 1), l) 
            end
            end
        else 
          for i = 1, jump_height do
           -- if not hero:test_obstacles(0, -1) then hero:set_position(x, (y - 1), l) end
          end
          sol.timer.start(gravity * jump_height, function()
            if game:is_command_pressed("right") or game:is_command_pressed("left") then
              state = "walking"
            else
              state = "stopped"
            end
          end)
          hero:set_animation(state)
        end
        if state ~= "jumping" then 
          for entity in self:get_entities("g_") do
            local gx, gy, gl = entity:get_position()
            if not entity:test_obstacles(0, 1) then
              entity:set_position(gx, (gy + 1), gl)
            end
          end
        end
      return true
    end)
  return true
end

  