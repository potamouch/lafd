local item = ...

function item:on_created()

  self:set_savegame_variable("possession_golden_leafs_counter")
  self:set_amount_savegame_variable("amount_golden_leafs_counter")
  self:set_assignable(false)
  self:set_sound_when_brandished("treasure_2")

end