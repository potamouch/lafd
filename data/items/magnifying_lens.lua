-- Magnifying lens
local item = ...

function item:on_created()

  self:set_savegame_variable("possession_magnifiyng_lens")
  self:set_sound_when_brandished("treasure_2")

end
