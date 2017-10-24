local item = ...

function item:on_created()

  self:set_savegame_variable("possession_tail_key")
  self:set_sound_when_brandished("treasure_2")

end

function item:on_obtaining(variant, savegame_variable)

    self:get_game():set_value("main_quest_step", 6)

end