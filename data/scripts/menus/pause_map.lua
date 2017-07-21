local submenu = require("scripts/menus/pause_submenu")
local map_submenu = submenu:new()


function map_submenu:on_started()

  submenu.on_started(self)
  self.cursor_sprite = sol.sprite.create("menus/pause_cursor")
  self.map_zone_sprite = sol.sprite.create("menus/map_zone")
  self.map_zone_position_sprite = sol.sprite.create("menus/map_zone_position")
  self.sprites_assignables = {}
  self.sprites_static = {}
  -- Draw the items on a surface.
  self.quest_map_surface = sol.surface.create(320, 256)
  self.quest_map_surface:clear()
 


end

function map_submenu:on_finished()

end

function map_submenu:on_draw(dst_surface)

  self:draw_background(dst_surface)
  self:draw_caption(dst_surface)
  -- World map
  local map_img = sol.surface.create("menus/outside_map.png")
  map_img:draw_region(0, 0, 128, 128, self.quest_map_surface, 96, 68) 
  local y = 75
  for i = 0, 15 do
    local x = 104
    for j = 0, 15 do
      local save_map_discovering = self.game:get_value('map_discovering_'..(j)..'_'..(i))
      if save_map_discovering == nil then
        self.map_zone_sprite:draw(self.quest_map_surface, x, y)
      end
      x = x + 8
    end
    y = y + 8
  end
  local map_grid_img = sol.surface.create("menus/outside_map_grid.png")
  map_grid_img:draw_region(0, 0, 128, 128, self.quest_map_surface, 96, 68) 
  local map_hero_position_x = self.game:get_value("map_hero_position_x")
  local map_hero_position_y = self.game:get_value("map_hero_position_y")
  if (map_hero_position_x ~= nil and map_hero_position_y ~= nil) then
    local x = 104 + map_hero_position_x * 8
    local y = 75 + map_hero_position_y * 8
    self.map_zone_position_sprite:draw(self.quest_map_surface, x, y)
  end
  self.quest_map_surface:draw(dst_surface, 0, 0)

  self:draw_save_dialog_if_any(dst_surface)


end



function map_submenu:on_command_pressed(command)
  
  local handled = submenu.on_command_pressed(self, command)

  if not handled then
    if command == "action" then
      if self.game:get_command_effect("action") == nil and self.game:get_custom_command_effect("action") == "info" then
        self:show_info_message()
        handled = true
      end
    elseif command == "left" then
        self:previous_submenu()
        handled = true
    elseif command == "right" then
        self:next_submenu()
        handled = true
  end
end

  return handled

end

return map_submenu