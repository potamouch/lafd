local item = ...

function item:on_created()

  self:set_can_disappear(true)
  self:set_brandish_when_picked(false)

end

function item:on_started()

end

function item:on_obtaining(variant, savegame_variable)

  self:get_game():get_item("golden_leafs_counter"):add_amount(1)

end

