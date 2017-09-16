-- Mushroom
local item = ...

function item:on_created()

  self:set_savegame_variable("possession_mushroom")
  self:set_sound_when_brandished("treasure_2")
  self:set_assignable(true)

end

function item:on_using()

  local map = self:get_map()
  local hero = map:get_entity("hero")
  local x_hero,y_hero, layer_hero = hero:get_position()
  hero:set_animation("brandish")
  local mushroom_entity = map:create_custom_entity({
    name = "brandish_sword",
    sprite = "entities/items",
    x = x_hero,
    y = y_hero - 24,
    width = 16,
    height = 16,
    layer = layer_hero,
    direction = 0
  })
  mushroom_entity:get_sprite():set_animation("mushroom")
  mushroom_entity:get_sprite():set_direction(0)
    self:get_game():start_dialog("items.mushroom.1", function()
          hero:set_animation("stopped")
          map:remove_entities("brandish")
          hero:unfreeze()
    end)

end

function item:on_obtaining(variant, savegame_variable)

  --local item = self:get_game():get_item("magic_powders_counter")
  --item:set_savegame_variable(nil)

end


