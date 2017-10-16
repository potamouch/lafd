local item = ...

function item:on_created()

  self:set_savegame_variable("possession_full_moon_cello")
  self:set_brandish_when_picked(false)

end

function item:on_obtaining(variant, savegame_variable)

    self:get_game():set_value("main_quest_step", 8)

end