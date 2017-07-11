local submenu = require("scripts/menus/pause_submenu")
local inventory_submenu = submenu:new()

local item_names_assignable = {
  "shield",
  "magic_powder",
  "feather",
  "bombs_counter",
  "pegasus_shoes",
  "bow",
  "hookshot",
  "shovel",
  "magic_rod",
  "ocarina",
  "boomerang",
  "boomerang"
}
local item_names_static = {
  "tunic",
  "sword",
  "flippers",
  "magnifying_lens"
}

local item_names_key = {
  "tail_key",
  "slim_key",
  "angler_key",
  "face_key",
  "bird_key",
  "slim_key"
}

function inventory_submenu:on_started()

  submenu.on_started(self)
  self.cursor_sprite = sol.sprite.create("menus/pause_cursor")
  self.hearts_surface = sol.surface.create(320, 240)
  self.sprites_assignables = {}
  self.sprites_static = {}
  self.sprites_key = {}
  self.counters = {}
  self.captions = {}
  self.hearts_surface:clear()

  -- Load Items
  for i,item_name in ipairs(item_names_assignable) do
    local item = self.game:get_item(item_name)
    local variant = item:get_variant()
    self.sprites_assignables[i] = sol.sprite.create("entities/items")
    self.sprites_assignables[i]:set_animation(item_name)
  end
  for i,item_name in ipairs(item_names_static) do
    local item = self.game:get_item(item_name)
    local variant = item:get_variant()
    self.sprites_static[i] = sol.sprite.create("entities/items")
    self.sprites_static[i]:set_animation(item_name)
  end
  for i,item_name in ipairs(item_names_key) do
    local item = self.game:get_item(item_name)
    local variant = item:get_variant()
    self.sprites_key[i] = sol.sprite.create("entities/items")
    self.sprites_key[i]:set_animation(item_name)
  end

  -- Pieces of heart.
  local pieces_of_heart_img = sol.surface.create("menus/quest_status_pieces_of_heart.png")
  local x = 51 * (self.game:get_value("i1030") or 0)
  pieces_of_heart_img:draw_region(x, 0, 51, 50, self.hearts_surface, 150, 100)

  -- Initialize the cursor
  local index = self.game:get_value("pause_inventory_last_item_index") or 0
  local row = math.floor(index / 7)
  local column = index % 7
  self:set_cursor_position(row, column)

end

function inventory_submenu:on_finished()

  if submenu.on_finished then
    submenu.on_finished(self)
  end

  if self:is_assigning_item() then
    self:finish_assigning_item()
  end

end

-- Returns whether an item is currently being thrown to an icon.
function inventory_submenu:is_assigning_item()

  return self.item_assigned_sprite ~= nil

end

function inventory_submenu:set_cursor_position(row, column)

  self.cursor_row = row
  self.cursor_column = column
  local index
  local item_name
  self.game:set_value("pause_inventory_last_item_index", index)

  -- Update the caption text and the action icon.
  local item_name = self:get_item_name(row, column)
  local item = item_name and self.game:get_item(item_name) or nil
  local variant = item and item:get_variant()
  local item_icon_opacity = 128
  if variant > 0 then
    self:set_caption("inventory.caption.item." .. item_name .. "." .. variant)
    self.game:set_custom_command_effect("action", "info")
    if item:is_assignable() then
      item_icon_opacity = 255
    end
  else
    self:set_caption(nil)
    self.game:set_custom_command_effect("action", nil)
  end
  self.game:get_hud():set_item_icon_opacity(1, item_icon_opacity)
  self.game:get_hud():set_item_icon_opacity(2, item_icon_opacity)

end

function inventory_submenu:is_item_selected()

  local item_name = self:get_item_name(self.cursor_row, self.cursor_column)

  return self.game:get_item(item_name):get_variant() > 0

end

function inventory_submenu:get_selected_index()

  return self.cursor_row * 3 + self.cursor_column

end

function inventory_submenu:get_item_name(row, column)

    if column < 3 then
     index = row * 3 + column
     item_name = item_names_assignable[index + 1]
    elseif row == 0 then
      index = column - 3
      item_name = item_names_static[index + 1]
    elseif column < 5 and row < 3 then
      item_name = 'sword'
    elseif column < 5 and row == 3 then
	item_name = 'flippers'
    else
      index = row * 2 + column - 6
      item_name = item_names_key[index]
    end

    return item_name

end

-- Assigns the selected item to a slot (1 or 2).
-- The operation does not take effect immediately: the item picture is thrown to
-- its destination icon, then the assignment is done.
-- Nothing is done if the item is not assignable.
function inventory_submenu:assign_item(slot)

  local item_name = self:get_item_name(self.cursor_row, self.cursor_column)
  local item = self.game:get_item(item_name)

  -- If this item is not assignable, do nothing.
  if not item:is_assignable() then
    return
  end
  -- If another item is being assigned, finish it immediately.
  if self:is_assigning_item() then
    self:finish_assigning_item()
  end

  -- Memorize this item.
  self.item_assigned = item
  self.item_assigned_sprite = sol.sprite.create("entities/items")
  self.item_assigned_sprite:set_animation(item_name)
  self.item_assigned_sprite:set_direction(item:get_variant() - 1)
  self.item_assigned_destination = slot

  -- Play the sound.
  sol.audio.play_sound("throw")

  -- Compute the movement.
  local x1 = 60 + 32 * self.cursor_column
  local y1 = 75 + 32 * self.cursor_row
  local x2 = (slot == 1) and 20 or 72
  local y2 = 46

  self.item_assigned_sprite:set_xy(x1, y1)
  local movement = sol.movement.create("target")
  movement:set_target(x2, y2)
  movement:set_speed(500)
  movement:start(self.item_assigned_sprite, function()
    self:finish_assigning_item()
  end)

end

-- Stops assigning the item right now.
-- This function is called when we want to assign the item without
-- waiting for its throwing movement to end, for example when the inventory submenu
-- is being closed.
function inventory_submenu:finish_assigning_item()

  -- If the item to assign is already assigned to the other icon, switch both items.
  local slot = self.item_assigned_destination
  local current_item = self.game:get_item_assigned(slot)
  local other_item = self.game:get_item_assigned(3 - slot)

  if other_item == self.item_assigned then
    self.game:set_item_assigned(3 - slot, current_item)
  end
  self.game:set_item_assigned(slot, self.item_assigned)

  self.item_assigned_sprite:stop_movement()
  self.item_assigned_sprite = nil
  self.item_assigned = nil

end

-- Shows a message describing the item currently selected.
-- The player is supposed to have this item.
function inventory_submenu:show_info_message()

  local item_name = self:get_item_name(self.cursor_row, self.cursor_column)
  local variant = self.game:get_item(item_name):get_variant()
  local game = self.game
  local map = game:get_map()

  -- Position of the dialog (top or bottom).
  if self.cursor_row >= 2 then
    game:set_dialog_position("top")  -- Top of the screen.
  else
    game:set_dialog_position("bottom")  -- Bottom of the screen.
  end

  self.game:set_custom_command_effect("action", nil)
  self.game:set_custom_command_effect("attack", nil)
  game:start_dialog("_item_description." .. item_name .. "." .. variant, function()
    self.game:set_custom_command_effect("action", "info")
    self.game:set_custom_command_effect("attack", "save")
    game:set_dialog_position("auto")  -- Back to automatic position.
  end)

end

function inventory_submenu:on_command_pressed(command)
  
  local handled = submenu.on_command_pressed(self, command)

  if not handled then

    if command == "action" then
      if self.game:get_command_effect("action") == nil and self.game:get_custom_command_effect("action") == "info" then
        self:show_info_message()
        handled = true
      end

    elseif command == "item_1" then
      if self:is_item_selected() then
        self:assign_item(1)
        handled = true
      end

    elseif command == "item_2" then
      if self:is_item_selected() then
        self:assign_item(2)
        handled = true
      end

    elseif command == "left" then
      if self.cursor_column == 0 then
        self:previous_submenu()
      else
        sol.audio.play_sound("cursor")
        self:set_cursor_position(self.cursor_row, self.cursor_column - 1)
      end
      handled = true

    elseif command == "right" then
      if self.cursor_column == 6 then
        self:next_submenu()
      else
        sol.audio.play_sound("cursor")
        self:set_cursor_position(self.cursor_row, self.cursor_column + 1)
      end
      handled = true

    elseif command == "up" then
      sol.audio.play_sound("cursor")
      self:set_cursor_position((self.cursor_row + 3) % 4, self.cursor_column)
      handled = true

    elseif command == "down" then
      sol.audio.play_sound("cursor")
      self:set_cursor_position((self.cursor_row + 1) % 4, self.cursor_column)
      handled = true

    end
  end

  return handled

end

function inventory_submenu:on_draw(dst_surface)

  self:draw_background(dst_surface)
  self:draw_caption(dst_surface)
  self.hearts_surface:draw(dst_surface, x, y)
  -- Draw each inventory assignable item.
  local y = 82
  local k = 0

  for i = 0, 3 do
    local x = 64
    for j = 0, 2 do
      k = k + 1
      if item_names_assignable[k] ~= nil then
        local item = self.game:get_item(item_names_assignable[k])
        if item:get_variant() > 0 then
          -- The player has this item: draw it.
          self.sprites_assignables[k]:set_direction(item:get_variant() - 1)
          self.sprites_assignables[k]:draw(dst_surface, x, y)
          if self.counters[k] ~= nil then
            self.counters[k]:draw(dst_surface, x + 8, y)
          end
        end
      end
      x = x + 32
    end
    y = y + 32
  end

  -- Draw each inventory static item.
  local y = 82
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

  -- Draw each inventory key item.
  local y = 114
  local k = 0
  for i = 0, 2 do
    local x = 224
    for j = 0, 1 do
      k = k + 1
      local item = self.game:get_item(item_names_key[k])
      if item:get_variant() > 0 then
        -- The player has this item: draw it.
        self.sprites_key[k]:draw(dst_surface, x, y)
      end
      x = x + 32
    end
    y = y + 32
  end

  -- Draw the cursor.
  self.cursor_sprite:draw(dst_surface, 64 + 32 * self.cursor_column, 77 + 32 * self.cursor_row)

  -- Draw the item being assigned if any.
  if self:is_assigning_item() then
    self.item_assigned_sprite:draw(dst_surface)
  end

  self:draw_save_dialog_if_any(dst_surface)
end


return inventory_submenu

