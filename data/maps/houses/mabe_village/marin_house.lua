-- Inside - Marine's House

-- Variables
local map = ...
local game = map:get_game()
local companion_manager = require("scripts/maps/companion_manager")

-- Methods - Functions

function map:set_music()

  if game:get_value("main_quest_step") < 3  then
    sol.audio.play_music("maps/houses/links_awake")
  elseif game:get_value("main_quest_step") == 3  then
    sol.audio.play_music("maps/out/sword_search")
  else
    sol.audio.play_music("maps/houses/inside")
  end

end

function map:repeat_marin_direction_check()

  local direction4 = marin:get_direction4_to(hero)
  marin:get_sprite():set_direction(direction4)

  -- Rappeler cette fonction dans 0.1 seconde.
  sol.timer.start(map, 100, function() 
    map:repeat_marin_direction_check()
  end)
end

function map:repeat_tarin_direction_check()

  local direction4 = tarin:get_direction4_to(hero)
  tarin:get_sprite():set_direction(direction4)

  -- Rappeler cette fonction dans 0.1 seconde.
  sol.timer.start(map, 100, function() 
    map:repeat_tarin_direction_check()
  end)
end

function map:jump_from_bed()

  hero:set_enabled(true)
  hero:start_jumping(7, 24, true)
  game:set_pause_allowed(true)
  bed:get_sprite():set_animation("empty_open")
  game:set_starting_location("houses/mabe_village/marin_house", "marin_house_1_B")
  sol.audio.play_sound("hero_lands")
  game:set_value("main_quest_step", 1)

end

function map:wake_up()

  snores:remove()
  bed:get_sprite():set_animation("hero_waking")
  sol.timer.start(1000, function() 
    game:start_dialog("maps.houses.mabe_village.marin_house.marin_2", function()
      sol.timer.start(500, function()
        map:jump_from_bed()
      end)
    end)
  end)

end

function map:init_tarin()
 
    local item = game:get_item("magnifying_lens")
    local variant = item:get_variant()
   if game:get_value("main_quest_step") > 10 and variant < 4 then
    snores_tarin:remove()
    bed_tarin:remove()
    tarin:get_sprite():set_animation("waiting")
    tarin:get_sprite():set_direction(3)
   elseif game:get_value("main_quest_step") > 10  then
    snores_tarin:remove()
    bed_tarin:remove()
    bed:remove()
    tarin:remove()
    bananas:remove()
   elseif game:get_value("main_quest_step") > 4 then
    local x,y,layer = placeholder_tarin_sleep:get_position()
    tarin:set_position(x,y,layer)
    tarin:get_sprite():set_animation("sleeping")
    bed:remove()
    bananas:remove()
  elseif game:get_value("main_quest_step") > 3  then
    snores_tarin:remove()
    bed_tarin:remove()
    bed:remove()
    tarin:remove()
    bananas:remove()
  else
    snores_tarin:remove()
    bed_tarin:remove()
    tarin:get_sprite():set_animation("waiting")
    map:repeat_tarin_direction_check()
    bananas:remove()
  end

end

function  map:talk_to_tarin() 

   if game:get_value("main_quest_step") > 10 then
    game:start_dialog("maps.houses.mabe_village.marin_house.tarin_5")
   elseif game:get_value("main_quest_step") > 4 then
    game:start_dialog("maps.houses.mabe_village.marin_house.tarin_4")
   else
      if game:has_item("shield") == false then
        local item = game:get_item("shield")
        game:start_dialog("maps.houses.mabe_village.marin_house.tarin_1", game:get_player_name(), function()
          hero:start_treasure("shield", 1, "schield")
          game:set_item_assigned(1, item)
          game:set_value("main_quest_step", 2)
        end)
      else
          game:start_dialog("maps.houses.mabe_village.marin_house.tarin_2", game:get_player_name())
      end
  end

end

function map:init_marin()
 
  if game:get_value("main_quest_step") > 3  then
    marin:remove()
  else
    marin:get_sprite():set_animation("waiting")
    map:repeat_marin_direction_check()
  end

end


function map:talk_to_marin() 

  game:start_dialog("maps.houses.mabe_village.marin_house.marin_1")

end

-- Events

function map:on_started(destination)

  map:set_music()
  map:init_marin()
  map:init_tarin()
  companion_manager:init_map(map)
  -- Letter
  if game:get_value("main_quest_step") ~= 21  then
    letter:set_enabled(false)
  end
  -- Start position
  if destination:get_name() == "start_position"  then
    game:set_hud_enabled(true)
    game:set_pause_allowed(false)
    snores:get_sprite():set_ignore_suspend(true)
    bed:get_sprite():set_animation("hero_sleeping")
    hero:freeze()
    hero:set_enabled(false)
    sol.timer.start(3000, function()
      map:wake_up()
    end)
  else
    snores:remove()
  end

end

function map:on_finished()

  if game:has_item("shield") == true and game:get_value("link_search_sword" ) == false then
    game:set_value("step_1_link_search_sword", true)
  end

end

function exit_sensor:on_activated()

  if game:has_item("shield") == false then
    game:start_dialog("maps.houses.mabe_village.marin_house.tarin_3", function()
     hero:set_direction(2)
     hero:walk("2222")
   end)
  end

end


function tarin:on_interaction()

      map:talk_to_tarin()

end

function tarin_npc:on_interaction()

      map:talk_to_tarin()

end

function marin:on_interaction()

      map:talk_to_marin()

end

for wardrobe in map:get_entities("wardrobe") do
  function wardrobe:on_interaction()
    game:start_dialog("maps.houses.wardrobe_1", game:get_player_name())
  end
end

