local item = ...

function item:on_created()

  self:set_savegame_variable("possession_power_bracelet")
  self:set_sound_when_brandished("treasure_2")

end

function item:on_variant_changed(variant)

  -- the possession state of the glove determines the built-in ability "lift"
  self:get_game():set_ability("lift", variant)

end

function item:on_using()

  self:set_finished()

end

