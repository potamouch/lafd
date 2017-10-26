-- Heart
local item = ...

function item:on_created()

  self:set_shadow("small")
  self:set_brandish_when_picked(false)
end

function item:on_obtaining(variant, savegame_variable)

   if game:get_life() == game:get_max_life() then
      sol.audio.play_sound("picked_item")
    else
      game:add_life(12)
    end

end

