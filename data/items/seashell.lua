local item = ...

function item:on_created()

  self:set_brandish_when_picked(true)

end

function item:on_obtaining(variant, savegame_variable)

    self:get_game():get_item("seashells_counter"):add_amount(1)
 
end