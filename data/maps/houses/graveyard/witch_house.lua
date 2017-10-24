-- Lua script of map houses/graveyard/witch_house_new.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local music_name = sol.audio.get_music()
local light_manager = require("scripts/maps/light_manager")
local companion_manager = require("scripts/maps/companion_manager")

function map:talk_to_witch() 

  local item1 = game:get_item_assigned(1)
  local item2 = game:get_item_assigned(2)
  local name1 = false
  local name2 = false
  if item1~= nil then
    name1 = item1:get_name() 
  end
  if item2~= nil then
    name2 = item2:get_name() 
  end
  if game:has_item("mushroom") and (name1 == "mushroom" or name2 == "mushroom") then
    local slot = 1
    if name2 == "mushroom" then
      slot = 2
    end
    map:making_magic_powder(slot)
  else
    game:start_dialog("maps.houses.graveyard.witch_house.witch_1")
  end

end

function map:making_magic_powder(slot)
    
  local entity = map:get_entity("witch")
  local sprite = entity:get_sprite()
  game:start_dialog("maps.houses.graveyard.witch_house.witch_2", function() 
      local mushroom = game:get_item("mushroom")
      mushroom:set_variant(0)
      hero:freeze()
      sol.audio.play_music("maps/houses/shop_high")
      sprite:set_animation("walking")
      sol.timer.start(3000, function()
        sprite:set_animation("stopped")
        sol.audio.play_music(music_name)
        game:start_dialog("maps.houses.graveyard.witch_house.witch_3", function() 
          hero:unfreeze()
          hero:start_treasure("magic_powders_counter", 1)
          local item = game:get_item("magic_powders_counter")
          game:set_item_assigned(slot, item)
        end)
      end)
   end)

end


-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()
  light_manager:init(map)
  map:set_light(0)
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end


function witch:on_interaction()

      map:talk_to_witch()

end
