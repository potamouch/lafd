-- Magical powder
local item = ...

function item:on_created()

  self:set_savegame_variable("possession_magic_powder")
  self:set_assignable(true)

end

function item:on_using()

  local variant = item:get_variant()
  local hero = self:get_map():get_entity("hero")
  if variant == 1 then
    -- Magic mushroom.
    hero:set_animation("sword", function()
      self:get_game():start_dialog("items.magic_powder.1")
    end)
  else
    -- Magic powder.
  end
  self:set_finished()

end
