-- Mushroom
local item = ...

function item:on_created()

  self:set_savegame_variable("possession_mushroom")
  self:set_sound_when_brandished("treasure_2")
  self:set_assignable(true)

end

function item:on_using()

   local hero = self:get_map():get_entity("hero")
   hero:set_animation("brandish")
    self:get_game():start_dialog("items.mushroom.1", function()
          hero:set_animation("stopped")
          hero:unfreeze()
    end)

end

function item:on_obtaining(variant, savegame_variable)

  --local item = self:get_game():get_item("magic_powders_counter")
  --item:set_savegame_variable(nil)

end


