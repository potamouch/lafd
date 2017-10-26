-- Shovel
local item = ...

function item:on_created()

  self:set_savegame_variable("possession_shovel")
  self:set_assignable(true)

end


function item:on_using()

  local game = item:get_game()
  local map = game:get_map()
  local hero = map:get_hero()
  local x,y,layer = hero:get_position()
  local ground = map:get_ground(x, y, layer)
  x = math.floor(x / 16) * 16
  y = math.floor(y / 16) * 16
  if ground == "traversable" then
    sol.audio.play_sound("dig")
    map:create_dynamic_tile{
      x = x,
      y = y,
      layer = layer,
      width = 16,
      height = 16,
      pattern = "1680",
      enabled_at_start = true
    }
  end
  self:set_finished()

end


