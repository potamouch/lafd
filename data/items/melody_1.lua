-- Lua script of item melody_1.
-- This script is executed only once for the whole game.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local item = ...
local game = item:get_game()

-- Event called when the game is initialized.
function item:on_started()

  self:set_brandish_when_picked(false)
  self:set_savegame_variable("possession_melody_1")
  self:set_assignable(true)

end

-- Event called when the hero is using this item.
function item:on_using()

    local map = game:get_map()
    local hero = map:get_hero()
    local ocarina = game:get_item("ocarina")
    ocarina:playing_song("items/ocarina_1")

    item:set_finished()
end

function item:on_obtained(variant, savegame_variable)

end

function item:brandish(callback)

  local map = self:get_map()
  local hero = map:get_entity("hero")
  local nb = self:get_game():get_item("golden_leaves_counter"):get_amount()
  local x_hero,y_hero, layer_hero = hero:get_position()
  hero:set_animation("brandish")
  sol.audio.play_sound("treasure_2")
  local entity = map:create_custom_entity({
    name = "brandish_sword",
    sprite = "entities/items",
    x = x_hero,
    y = y_hero - 24,
    width = 16,
    height = 16,
    layer = layer_hero + 1,
    direction = 0
  })
  entity:get_sprite():set_animation("ocarina")
  entity:get_sprite():set_direction(0)
  self:get_game():start_dialog("_treasure.melody_1.1", function()
        hero:set_animation("stopped")
        map:remove_entities("brandish")
        hero:unfreeze()
        if callback ~= nil then
          callback()
        end
  end)

end