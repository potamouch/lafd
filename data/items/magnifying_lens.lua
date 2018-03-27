-- Magnifying lens
local item = ...
local game = item:get_game()

function item:on_created()

  self:set_savegame_variable("possession_magnifiyng_lens")
  self:set_sound_when_brandished("treasure_2")

end


function item:on_obtaining(variant, savegame_variable)

  local variant = self:get_variant()
  if variant == 6 then
    game:set_value("main_quest_step", 20)
  elseif variant == 7 then
    game:set_value("main_quest_step", 21)
  end

end