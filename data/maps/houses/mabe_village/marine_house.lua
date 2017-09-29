-- Inside - Marine's House

-- Variables
local map = ...
local game = map:get_game()

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

function map:repeat_marine_direction_check()

  local direction4 = marine:get_direction4_to(hero)
  marine:get_sprite():set_direction(direction4)

  -- Rappeler cette fonction dans 0.1 seconde.
  sol.timer.start(map, 100, function() 
    map:repeat_marine_direction_check()
  end)
end

function map:jump_from_bed()

  hero:set_visible(true)
  hero:start_jumping(7, 24, true)
  game:set_pause_allowed(true)
  bed:get_sprite():set_animation("empty_open")
  game:set_starting_location("houses/mabe_village/marine_house", "marine_house_1_B")
  sol.audio.play_sound("hero_lands")
  game:set_value("main_quest_step", 1)

end

function map:wake_up()

  snores:remove()
  bed:get_sprite():set_animation("hero_waking")
  sol.timer.start(1000, function() 
    game:start_dialog("maps.houses.mabe_village.marine_house.marine_2", function()
      sol.timer.start(500, function()
        map:jump_from_bed()
      end)
    end)
  end)

end

function map:init_tarin()
 
  if game:get_value("main_quest_step") > 3  then
    tarin:set_visible(false)
  else
    tarin:get_sprite():set_animation("waiting")
  end

end

function  map:talk_to_tarin() 

  if game:has_item("shield") == false then
    game:start_dialog("maps.houses.mabe_village.marine_house.tarin_1", game:get_player_name(), function()
      hero:start_treasure("shield", 1, "schield")
      game:set_value("main_quest_step", 2)
    end)
  else
      game:start_dialog("maps.houses.mabe_village.marine_house.tarin_2", game:get_player_name())
  end

end

function map:init_marine()
 
  if game:get_value("main_quest_step") > 3  then
    marine:set_visible(false)
  else
    marine:get_sprite():set_animation("waiting")
    map:repeat_marine_direction_check()
  end

end


function map:talk_to_marine() 

  game:start_dialog("maps.houses.mabe_village.marine_house.marine_1")

end

-- Events

function map:on_started(destination)

  map:set_music()
  map:init_marine()
  map:init_tarin()
  if destination:get_name() == "start_position"  then
    -- the intro scene is playing
    game:set_hud_enabled(true)
    game:set_pause_allowed(false)
    snores:get_sprite():set_ignore_suspend(true)
    bed:get_sprite():set_animation("hero_sleeping")
    hero:freeze()
    hero:set_visible(false)
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
    game:start_dialog("maps.houses.mabe_village.marine_house.tarin_3", function()
     hero:set_direction(2)
     hero:walk("2222")
   end)
  end

end


function tarin:on_interaction()

      map:talk_to_tarin()

end

function marine:on_interaction()

      map:talk_to_marine()

end
