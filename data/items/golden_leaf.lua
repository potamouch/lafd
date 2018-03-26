local item = ...

function item:on_created()

  self:set_sound_when_brandished("treasure_2")
  self:set_brandish_when_picked(false)

end

function item:on_started()

end

function item:on_obtaining(variant, savegame_variable)

  self:get_game():get_item("golden_leaves_counter"):add_amount(1)

end

function item:on_obtained(variant, savegame_variable)

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
    layer = layer_hero,
    direction = 0
  })
  entity:get_sprite():set_animation("golden_leaf")
  entity:get_sprite():set_direction(0)
  self:get_game():start_dialog("_treasure.golden_leaf." .. nb, function()
        hero:set_animation("stopped")
        map:remove_entities("brandish")
        hero:unfreeze()
  end)


end

