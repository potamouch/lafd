-- Boomerang
local item = ...

function item:on_created()

  self:set_savegame_variable("item_ocarina")
  self:set_assignable(true)

end


function item:on_using()

  self:set_finished()

end

