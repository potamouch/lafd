-- Shovel
local item = ...

function item:on_created()

  self:set_savegame_variable("item_shovel")
  self:set_assignable(true)

end

function item:on_using()

end

