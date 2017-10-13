local submenu = require("scripts/menus/pause_submenu")
local map_submenu = submenu:new()

function map_submenu:on_started()

  submenu.on_started(self)
  self.map_surface = sol.surface.create(320, 256)
  self.map_surface:clear()
  self.dungeon = self.game:get_dungeon()
  self.dungeon_index = self.game:get_dungeon_index()
  if self.dungeon then
     self:build_dungeon_map()
  else
    self:build_world_map()
  end
 
end

function map_submenu:on_draw(dst_surface)

  self:draw_background(dst_surface)
  self:draw_caption(dst_surface)
  self.map_surface:draw(dst_surface, 0, 0)
  if self.dungeon then
     self:draw_dungeon_map(self.map_surface)
  else
    self:draw_world_map(self.map_surface)
  end
  self:draw_save_dialog_if_any(self.map_surface)


end

function map_submenu:on_finished()

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

function map_submenu:build_world_map()

  self.pause_menu_background_img = sol.surface.create("menus/pause_menu_world_background.png")
  self.pause_menu_world_map_img = sol.surface.create("menus/pause_menu_world_map.png")
  self.pause_menu_world_map_zone = sol.surface.create("menus/pause_menu_world_map_zone.png")
  self.pause_menu_world_map_zone_position = sol.surface.create("menus/pause_menu_world_map_zone_position.png")
  self.pause_menu_world_map_grid = sol.surface.create("menus/pause_menu_world_map_grid.png")

end

function map_submenu:build_dungeon_map()


    local width, height = sol.video.get_quest_size()
    local center_x, center_y = width / 2, height / 2
    self.pause_menu_background_img = sol.surface.create("menus/pause_menu_dungeon_background.png")
    self.sprite_map  = sol.sprite.create("entities/items")
    self.sprite_map:set_animation("map")
    self.sprite_compass  = sol.sprite.create("entities/items")
    self.sprite_compass:set_animation("compass")
    self.sprite_boss_key  = sol.sprite.create("entities/items")
    self.sprite_boss_key:set_animation("boss_key")
    self.sprite_hero_head  = sol.sprite.create("menus/hero_head")
    self.boss_icon_img = sol.surface.create("menus/boss_icon.png")
    self.chest_icon_img = sol.surface.create("menus/chest_icon.png")
    self.up_arrow_sprite = sol.sprite.create("menus/arrow")
    self.up_arrow_sprite:set_direction(1)
    self.down_arrow_sprite = sol.sprite.create("menus/arrow")
    self.down_arrow_sprite:set_direction(3)
    self.floors_img = sol.surface.create("floors.png", true)
    self.floors_img:set_xy(center_x - 160, center_y - 120)
    self.hero_floor = self.game:get_map():get_floor()
    self.nb_floors = self.dungeon.highest_floor - self.dungeon.lowest_floor + 1
    self.nb_floors_displayed = math.min(7, self.nb_floors)
    if self.hero_floor == nil then
      -- The hero is not on a known floor of the dungeon.
      self.highest_floor_displayed = self.dungeon.highest_floor
      self.selected_floor = self.dungeon.lowest_floor
    else
      -- The hero is on a known floor.
      self.selected_floor = self.hero_floor
      if self.nb_floors <= 7 then
        self.highest_floor_displayed = self.dungeon.highest_floor
      elseif self.hero_floor >= self.dungeon.highest_floor - 2 then
        self.highest_floor_displayed = self.dungeon.highest_floor
      elseif self.hero_floor <= self.dungeon.lowest_floor + 2 then
        self.highest_floor_displayed = self.dungeon.lowest_floor + 6
      else
        self.highest_floor_displayed = self.hero_floor + 3
      end
    end
    self.up_arrow_sprite:set_xy(center_x - 71, center_y - 31)
    self.down_arrow_sprite:set_xy(center_x - 71, center_y - 64)
    -- rooms
  self.rooms_surface = sol.surface.create(168, 168)
  self.rooms_sprite = sol.sprite.create("menus/dungeon_maps/map_" .. self.dungeon_index)
  self.rooms_compass_sprite = sol.sprite.create("menus/dungeon_maps/map_" .. self.dungeon_index .. "_compass")
end

function map_submenu:draw_world_map(dst_surface)

  local x = 97
  local y = 70
  self.pause_menu_world_map_img:draw(dst_surface, x, y)
  for i = 0, 15 do
    local x = 97
    for j = 0, 15 do
      local save_map_discovering = self.game:get_value('map_discovering_'..(j)..'_'..(i))
      if save_map_discovering == nil then
        self.pause_menu_world_map_zone:draw(dst_surface, x, y)
      end
      x = x + 8
    end
    y = y + 8
  end
  self.pause_menu_world_map_grid:draw_region(0, 0, 128, 128, self.map_surface, 97, 70) 
  local map_hero_position_x = self.game:get_value("map_hero_position_x")
  local map_hero_position_y = self.game:get_value("map_hero_position_y")
  if (map_hero_position_x ~= nil and map_hero_position_y ~= nil) then
    local x = 97 + map_hero_position_x * 8
    local y = 70 + map_hero_position_y * 8
    self.pause_menu_world_map_zone_position:draw(dst_surface, x, y)
  end
  self.pause_menu_background_img:draw(dst_surface)

end

function map_submenu:draw_dungeon_map(dst_surface)


  self.pause_menu_background_img:draw(dst_surface)
  self:draw_dungeon_map_items(dst_surface)
  self:draw_dungeon_map_floors(dst_surface)
  self:draw_dungeon_map_rooms(dst_surface)


end

function map_submenu:draw_dungeon_map_items(dst_surface)

  if self.game:has_dungeon_map() then
      self.sprite_map:draw(dst_surface, 64, 190)
    end
    if self.game:has_dungeon_compass() then
      self.sprite_compass:draw(dst_surface, 84, 190)
    end
    if self.game:has_dungeon_boss_key() then
      self.sprite_boss_key:draw(dst_surface, 104, 190)
    end
    if self.game:has_dungeon_boss_key() then
      self.sprite_boss_key:draw(dst_surface, 124, 190)
    end

end

function map_submenu:draw_dungeon_map_floors(dst_surface)

  local src_x = 96
  local src_y = (15 - self.highest_floor_displayed) * 12
  local src_width = 32
  local src_height = self.nb_floors_displayed * 12 + 1
  local dst_x = 77
  local dst_y = 60 + (8 - self.nb_floors_displayed) * 6
  local old_dst_y = dst_y
  self.floors_img:draw_region(src_x, src_y, src_width, src_height,
      dst_surface, dst_x, dst_y)

  -- Draw the current floor with other colors.
  src_x = 64
  src_y = (15 - self.selected_floor) * 12
  src_height = 13
  dst_y = old_dst_y + (self.highest_floor_displayed - self.selected_floor) * 12
  self.floors_img:draw_region(src_x, src_y, src_width, src_height, dst_surface, dst_x, dst_y)
  dst_x = 60
  dst_y = old_dst_y + (self.highest_floor_displayed - self.hero_floor) * 12 + 8
  self.sprite_hero_head:draw(dst_surface, dst_x, dst_y)

end

function map_submenu:draw_dungeon_map_rooms(dst_surface)

  if self.game:has_dungeon_map() then
    self.rooms_sprite:set_animation(self.selected_floor)
    self.rooms_sprite:set_direction(0)
    self.rooms_sprite:draw(self.rooms_surface)
  end
  for i = 1, self.rooms_sprite:get_num_directions() - 1 do
    if self.game:has_explored_dungeon_room(self.dungeon_index, self.selected_floor, i) then
      -- If the room is visited, show it in another color.
      self.rooms_sprite:set_direction(i)
      self.rooms_sprite:draw(self.rooms_surface)
    end
    if self.game:has_dungeon_compass() and self.game:is_secret_room(self.dungeon_index, self.selected_floor, i) then
        self.rooms_compass_sprite:set_direction(i)
        self.rooms_compass_sprite:draw(self.rooms_surface)
      end
  end
   self.rooms_surface:draw(self.map_surface, 140, 70)

end

-- Rebuilds the minimap of the current floor of the dungeon.
function map_submenu:load_dungeon_map_image()

end



return map_submenu