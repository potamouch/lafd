-- Magical powder
local item = ...

function item:on_created()

  self:set_savegame_variable("item_magic_powder")
  self:set_assignable(true)

end

function item:on_using()

  local variant = item:get_variant()
  if variant == 1 then
    -- Magic mushroom.
    self:get_game():start_dialog("item.mushroom")
  else
    -- Magic powder.
  end
  self:set_finished()

end

