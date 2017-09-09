local item = ...

function item:on_created()

  self:set_savegame_variable("possession_pegasus_shoes")
  self:set_assignable(true)
end

function item:on_variant_changed(variant)

  self:get_game():set_ability("run", variant)
end

function item:on_using()

  self:get_map():get_entity("hero"):start_running()
  self:set_finished()
end
