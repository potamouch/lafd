local submenu = require("scripts/menus/pause_submenu")
local quest_status_submenu = submenu:new()

--local item_names_static = {
--  "full_moon_cello",
--  "conch_horn",
--  "sea_lilys_bell",
--  "surf_harp",
--  "wind_marimba",
--  "coral_triangle",
--  "organ_of_evening_calm",
--  "thunder_drum"
--}

local item_names_static = {
  "tunic",
  "sword",
  "flippers",
  "magnifying_lens"
}

function quest_status_submenu:on_started()

  submenu.on_started(self)
  self.quest_items_surface = sol.surface.create(320, 256)
  self.quest_map_surface = sol.surface.create(320, 256)
  self.cursor_sprite = sol.sprite.create("menus/pause_cursor")
  self.cursor_sprite_x = 0
  self.cursor_sprite_y = 0
  self.cursor_position = nil
  self.cursor_map_position = nil
  self.caption_text_keys = {}
  self.map_open = false

  local item_sprite = sol.sprite.create("entities/items")

  -- Load Items
  for i,item_name in ipairs(item_names_static) do
    local item = self.game:get_item(item_name)
    local variant = item:get_variant()
    self.sprites_static[i] = sol.sprite.create("entities/items")
    self.sprites_static[i]:set_animation(item_name)
  end

  -- Draw the items on a surface.
  self.quest_items_surface:clear()
  self.quest_map_surface:clear()

  -- World map
  local map_img = sol.surface.create("menus/outside_world_map.png")
  map_img:draw_region(0, 0, 116, 116, self.quest_items_surface, 56, 65)
  -- Big world map
  local map_img_background = sol.surface.create("menus/outside_world_map_background.png")
  map_img_background:draw_region(0, 0, 225, 133, self.quest_map_surface, 48, 59)
  local map_img_big = sol.surface.create("menus/outside_world_map_big.png")
  map_img_big:draw_region(0, 0, 163, 131, self.quest_map_surface, 79, 60)
  local map_img_big_square = sol.surface.create("menus/outside_world_map_big_square.png")
  local pos_x = 0
  local pos_y = 0
  local border_x = 0
  local border_y = 0
  for i = 1, 16 do
    border_y = 0
    if i == 5 or i == 9 or i == 13 then
     border_x = border_x+1
    end
    pos_x = 69+i*10+border_x;
    for j = 1, 16 do
      if j == 5 or j == 9 or j == 13 then
       border_y = border_y+1
      end
      pos_y = 52+j*8+border_y;
      local save_map_discovering = self.game:get_value('map_discovering_'..(i-1)..'_'..(j-1))
      if save_map_discovering == nil then
        map_img_big_square:draw_region(0, 0, 10, 8, self.quest_map_surface, pos_x, pos_y)
      end
    end
  end
  
  -- Dungeons finished
  local dungeons_img = sol.surface.create("menus/quest_status_dungeons.png")
  local dst_positions = {
    { 209,  69 },
    { 232,  74 },
    { 243,  97 },
    { 232, 120 },
    { 209, 127 },
    { 186, 120 },
    { 175,  97 },
    { 186,  74 },
  }
  for i, dst_position in ipairs(dst_positions) do
    if self.game:is_dungeon_finished(i) then
      dungeons_img:draw_region(20 * (i - 1), 0, 20, 20,
          self.quest_items_surface, dst_position[1], dst_position[2])
    end
  end

  -- Cursor.
  self:set_cursor_position(0)
end

function quest_status_submenu:set_cursor_position(position)

  if position ~= self.cursor_position then
    self.cursor_position = position
    self.cursor_map_position = position
    if position == 0 then
      self.cursor_sprite_x = 65
      self.cursor_sprite_y = 72
      self.cursor_map_position = 0
    elseif position == 1 then
      self.cursor_sprite_x = 86
      self.cursor_sprite_y = 72
    elseif position == 2 then
      self.cursor_sprite_x = 107
      self.cursor_sprite_y = 72
    elseif position == 3 then
      self.cursor_sprite_x = 128
      self.cursor_sprite_y = 72
    elseif position == 4 then
      self.cursor_sprite_x = 173
      self.cursor_sprite_y = 76
      self.cursor_map_position = nil
    elseif position == 5 then
      self.cursor_sprite_x = 213
      self.cursor_sprite_y = 76
      self.cursor_map_position = nil
    elseif position == 6 then
      self.cursor_sprite_x = 253
      self.cursor_sprite_y = 76
      self.cursor_map_position = nil
    elseif position == 7 then
      self.cursor_sprite_x = 65
      self.cursor_sprite_y = 89
    elseif position == 8 then
      self.cursor_sprite_x = 86
      self.cursor_sprite_y = 89
    elseif position == 9 then
      self.cursor_sprite_x = 107
      self.cursor_sprite_y = 89
    elseif position == 10 then
      self.cursor_sprite_x = 128
      self.cursor_sprite_y = 89
    elseif position == 11 then
      self.cursor_sprite_x = 173
      self.cursor_sprite_y = 116
      self.cursor_map_position = nil
    elseif position == 12 then
      self.cursor_sprite_x = 213
      self.cursor_sprite_y = 116
      self.cursor_map_position = nil
    elseif position == 13 then
      self.cursor_sprite_x = 253
      self.cursor_sprite_y = 116
      self.cursor_map_position = nil
    elseif position == 14 then
      self.cursor_sprite_x = 65
      self.cursor_sprite_y = 106
    elseif position == 15 then
      self.cursor_sprite_x = 86
      self.cursor_sprite_y = 106
    elseif position == 16 then
      self.cursor_sprite_x = 107
      self.cursor_sprite_y = 106
    elseif position == 17 then
      self.cursor_sprite_x = 128
      self.cursor_sprite_y = 106
    elseif position == 18 then
      self.cursor_sprite_x = 173
      self.cursor_sprite_y = 156
      self.cursor_map_position = nil
    elseif position == 19 then
      self.cursor_sprite_x = 213
      self.cursor_sprite_y = 156
      self.cursor_map_position = nil
    elseif position == 20 then
      self.cursor_sprite_x = 253
      self.cursor_sprite_y = 156
      self.cursor_map_position = nil
    elseif position == 21 then
      self.cursor_sprite_x = 65
      self.cursor_sprite_y = 123
    elseif position == 22 then
      self.cursor_sprite_x = 86
      self.cursor_sprite_y = 123
    elseif position == 23 then
      self.cursor_sprite_x = 107
      self.cursor_sprite_y = 123
    elseif position == 24 then
      self.cursor_sprite_x = 128
      self.cursor_sprite_y = 123
    end
    if self.cursor_map_position ~= nil then
      self.game:set_custom_command_effect("action", "look")
      self:set_caption("inventory.caption.carte")
    else 
      self:set_caption(nil)
      self.game:set_custom_command_effect("action", nil)
    end
  end
end

function quest_status_submenu:set_map_open(status)

    self.map_open = status
    if status == true then
      self.game:set_custom_command_effect("action", "return")
    else
      self.game:set_custom_command_effect("action", "look")
    end

end

function quest_status_submenu:on_command_pressed(command)

  local handled = submenu.on_command_pressed(self, command)

  if not handled then

    if self.map_open == true then
      if command == 'action' then
        self:set_map_open(false)
      end
    else
     if command == "left" then
       if self.cursor_position == 0 or self.cursor_position == 7 or self.cursor_position == 14 or self.cursor_position == 21 then
          self:previous_submenu()
        elseif self.cursor_position == 18 then
           self:set_cursor_position(24)
        elseif self.cursor_position == 13 then
           self:set_cursor_position(11)
        elseif self.cursor_position == 11 then
           self:set_cursor_position(17)
        else
          sol.audio.play_sound("cursor")
          self:set_cursor_position(self.cursor_position - 1)
        end
        handled = true
      elseif command == "right" then
        if self.cursor_position == 6 or self.cursor_position == 13 or self.cursor_position == 20  then
          self:next_submenu()
        elseif self.cursor_position == 10 then
          self:set_cursor_position(4)
        elseif self.cursor_position == 17 then
          self:set_cursor_position(11)
        elseif self.cursor_position == 24 then
          self:set_cursor_position(11)
        elseif self.cursor_position == 10 then
          self:set_cursor_position(4)	
        elseif self.cursor_position == 11 then
           self:set_cursor_position(13)
        else
          sol.audio.play_sound("cursor")
          self:set_cursor_position(self.cursor_position + 1)
        end
        handled = true

      elseif command == "down" then
        sol.audio.play_sound("cursor")
        if self.cursor_position == 5 then
           self:set_cursor_position(19)
        elseif self.cursor_position + 7 < 25 then
          self:set_cursor_position(self.cursor_position + 7 )
        end
        handled = true

      elseif command == "up" then
        sol.audio.play_sound("cursor")
        if self.cursor_position == 19 then
           self:set_cursor_position(5)
        elseif self.cursor_position - 7 > -1  then
         self:set_cursor_position(self.cursor_position - 7)
        end
        handled = true

      elseif command == 'action' then
       if self.cursor_map_position ~= nil then
         self:set_map_open(true)
       end
      end
    end

  end

  return handled
end

function quest_status_submenu:on_draw(dst_surface)

  local width, height = dst_surface:get_size()
  local x = width / 2 - 160
  local y = height / 2 - 120
  self:draw_background(dst_surface)
  self:draw_caption(dst_surface)
  self.quest_items_surface:draw(dst_surface, x, y)
  self.cursor_sprite:draw(dst_surface, x + self.cursor_sprite_x, y + self.cursor_sprite_y)
  self:draw_save_dialog_if_any(dst_surface)
  if  self.map_open == true then
    self.quest_map_surface:draw(dst_surface, x, y)
  end

  -- Draw each inventory static item.
  local y = 88
  local k = 0
  local x = 160
  for j = 0, 2 do
    k = k + 1
    local item = self.game:get_item(item_names_static[k])
    if item:get_variant() > 0 then
      -- The player has this item: draw it.
      self.sprites_static[k]:draw(dst_surface, x, y)
    end
    x = x + 32
  end

end

return quest_status_submenu

