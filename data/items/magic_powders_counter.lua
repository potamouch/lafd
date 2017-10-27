local item = ...
local game = item:get_game()


function item:on_created()

  self:set_savegame_variable("possession_magic_powders_counter")
  self:set_amount_savegame_variable("amount_magic_powders_counter")
  self:set_assignable(true)
end

function item:on_obtaining(variant, savegame_variable)

  self:set_amount(20)
  --local item = game:get_item("mushroom")
  --item:set_savegame_variable(nil)

end

function item:on_using()

   local amount =   self:get_amount()
   amount = amount - 1
  if amount < 0 then
    self:set_variant(0)
    sol.audio.play_sound("wrong")
  else
    sol.audio.play_sound("magic_powder")
   local map = game:get_map()
   local hero = map:get_hero()
   local x,y,layer = hero:get_position()
   hero:freeze()
   hero:set_animation("magic_powder")
   self:set_amount(amount)
    item:create_fire()
    sol.timer.start(item, 400, function()
      hero:unfreeze()
    end)
  end
  self:set_finished()

end

-- Creates some fire on the map.
function item:create_fire()

  local map = item:get_map()
  local hero = map:get_hero()
  local direction = hero:get_direction()
  local dx, dy
  if direction == 0 then
    dx, dy = 18, -4
  elseif direction == 1 then
    dx, dy = 0, -24
  elseif direction == 2 then
    dx, dy = -20, -4
  else
    dx, dy = 0, 16
  end

  local x, y, layer = hero:get_position()
  map:create_custom_entity{
    model = "fire",
    x = x + dx,
    y = y + dy,
    layer = layer,
    width = 16,
    height = 16,
    direction = 0,
  }
end