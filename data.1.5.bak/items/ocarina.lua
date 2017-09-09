local item = ...

function item:on_created()

  self:set_savegame_variable("possession_ocarina")
  self:set_assignable(true)

end


function item:on_using()

  sol.audio.play_sound("items/ocarina")
  self:set_finished()

end

