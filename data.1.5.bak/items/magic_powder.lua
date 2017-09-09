-- Magical powder
local item = ...

function item:on_created()

  self:set_savegame_variable("possession_magic_powder")
  self:set_brandish_when_picked(false)


end

function item:on_using()

  self:set_finished()

end
