local item = ...

function item:on_created()

  self:set_savegame_variable("item_tail_key")

end
