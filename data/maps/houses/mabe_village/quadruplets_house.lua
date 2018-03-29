-- Inside - Quadruplet's house

-- Variables

local map = ...
local game = map:get_game()
local companion_manager = require("scripts/maps/companion_manager")

-- Functions

function map:set_music()

  if game:get_value("main_quest_step") == 3  then
    sol.audio.play_music("maps/out/sword_search")
  else
    sol.audio.play_music("maps/houses/inside")
  end

end

function map:talk_to_father() 

  local item = game:get_item("magnifying_lens")
  local variant = item:get_variant()
  local father_sprite = father:get_sprite()
  if variant >= 8 then
    game:start_dialog("maps.houses.mabe_village.quadruplets_house.father_2", function()
      father_sprite:set_direction(3)
    end)
  else
    game:start_dialog("maps.houses.mabe_village.quadruplets_house.father_1", function()
      father_sprite:set_direction(3)
    end)
  end

end

function map:talk_to_mother() 

    local item = game:get_item("magnifying_lens")
    local variant = item:get_variant()
    if game:get_value("main_quest_step") < 18 then
      if variant == 1 then
        game:start_dialog("maps.houses.mabe_village.quadruplets_house.mother_2", function(answer)
          if answer == 1 then
              game:start_dialog("maps.houses.mabe_village.quadruplets_house.mother_4", function()
                hero:start_treasure("magnifying_lens", 2, "magnifying_lens_2")
                mother:get_sprite():set_direction(3)
                end)
          else
            game:start_dialog("maps.houses.mabe_village.quadruplets_house.mother_3", function()
              mother:get_sprite():set_direction(3)
            end)
          end
        end)
      elseif variant > 1 then
            game:start_dialog("maps.houses.mabe_village.quadruplets_house.mother_5", function()
              mother:get_sprite():set_direction(3)
            end)
      else
            game:start_dialog("maps.houses.mabe_village.quadruplets_house.mother_1", function()
              mother:get_sprite():set_direction(3)
            end)
      end
    else
      if variant >= 8 then
        game:start_dialog("maps.houses.mabe_village.quadruplets_house.mother_5", function()
          mother:get_sprite():set_direction(3)
        end)
      else
        game:start_dialog("maps.houses.mabe_village.quadruplets_house.mother_6", function()
          mother:get_sprite():set_direction(3)
        end)
      end
    end

end


-- Events

function map:on_started(destination)

 local item = game:get_item("magnifying_lens")
 local variant = item:get_variant()
  local father_sprite = father:get_sprite()
  map:set_music()
  companion_manager:init_map(map)
  if game:get_value("main_quest_step") >= 18 and variant < 8  then
    father:set_enabled(false)
  end
  if variant >= 8 then
    father_sprite:set_animation("calling")
  end

end

function father:on_interaction()

      map:talk_to_father()

end

function mother:on_interaction()

      map:talk_to_mother()

end

for wardrobe in map:get_entities("wardrobe") do
  function wardrobe:on_interaction()
    game:start_dialog("maps.houses.wardrobe_1", game:get_player_name())
  end
end



