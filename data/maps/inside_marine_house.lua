-- Inside - Marine's House

-- Variables
local map = ...

-- Methods - Functions

function map:set_music()

  if map:get_game():get_value("step_1_link_search_sword") == nil  then
    sol.audio.play_music("links_awake")
  elseif map:get_game():get_value("step_1_link_search_sword") == true and map:get_game():get_value("step_2_link_found_sword") == nil then
    sol.audio.play_music("sword_search")
  else
    sol.audio.play_music("inside_the_houses")
  end

end

function map:repeat_marine_direction_check()
  local angle_to_hero = marine:get_angle(hero) 
  local direction4 = map:angle_to_direction4(angle_to_hero)
  if( direction4 < 0 ) then
    direction4 = 0
  end
  marine:get_sprite():set_direction(direction4)

  -- Rappeler cette fonction dans 0.1 seconde.
  sol.timer.start(map, 100, function() 
    map:repeat_marine_direction_check()
  end)
end

function map:jump_from_bed()

  hero:set_visible(true)
  hero:start_jumping(7, 24, true)
  map:set_pause_enabled(true)
  bed:get_sprite():set_animation("empty_open")
  map:get_game():set_starting_location("inside_marine_house", "marine_house_1_B")
  sol.audio.play_sound("hero_lands")

end

function map:wake_up()
  snores:remove()
  bed:get_sprite():set_animation("hero_waking")
  sol.timer.start(1000, function() 
    map:start_dialog("marine_house.awake", function()
      sol.timer.start(500, function()
        map:jump_from_bed()
      end)
    end)
  end)
end

function  map:talk_to_tarkin() 

  if map:get_game():has_item("shield") == false then
    map:set_dialog_variable("marine_house.tarkin_1", map:get_game():get_player_name())
    map:start_dialog("marine_house.tarkin_1", function()
      hero:start_treasure("shield", 1, "b32")
    end)
  else
      map:set_dialog_variable("marine_house.tarkin_2", map:get_game():get_player_name())
      map:start_dialog("marine_house.tarkin_2")
  end

end

function map:talk_to_marine() 

      map:start_dialog("marine_house.marine_1")

end

function map:angle_to_direction4(angle)

  return math.floor((angle + math.pi / 4) / (math.pi / 2))

end

-- Events

function map:on_started(destination)

  map:set_music()
  marine:get_sprite():set_animation("walking")
  map:repeat_marine_direction_check()
  if destination:get_name() == "start_position"  then
    -- the intro scene is playing
    map:get_game():set_value("link_search_sword", false)
    map:get_game():set_hud_enabled(true)
    map:set_pause_enabled(false)
    map:set_dialog_style(0)
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

  if map:get_game():has_item("shield") == true and map:get_game():get_value("link_search_sword" ) == false then
    map:get_game():set_value("step_1_link_search_sword", true)
  end

end

function maison_link_exit_sensor:on_activated()

  if map:get_game():has_item("shield") == false then
    map:start_dialog("marine_house.tarkin_3", function()
     hero:set_direction(2)
     hero:walk("2222")
   end)
  end

end


function tarkin:on_interaction()

      map:talk_to_tarkin()

end

function marine:on_interaction()

      map:talk_to_marine()

end