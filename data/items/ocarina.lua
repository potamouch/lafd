local item = ...
local game = item:get_game()

function item:on_created()

  self:set_savegame_variable("possession_ocarina")
  self:set_assignable(true)

end


function item:on_using()

  item:playing_song("items/ocarina")
  self:set_finished()

end

function item:playing_song(music)

   local map = game:get_map()
   local hero = map:get_hero()
   local x,y,layer = hero:get_position()
   hero:freeze()
   hero:set_animation("playing_ocarina")
  local notes = map:create_custom_entity{
    x = x,
    y = y,
    layer = layer + 1,
    width = 24,
    height = 32,
    direction = 0,
    sprite = "entities/notes"
  }
  sol.audio.play_sound(music)
  sol.timer.start(map, 4000, function()
    hero:unfreeze()
    notes:remove()
  end)

end

