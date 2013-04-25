local map = ...
-- Link's house


local function jump_from_bed()
  hero:set_visible(true)
  hero:start_jumping(7, 24, true)
  map:set_pause_enabled(true)
  bed:get_sprite():set_animation("empty_open")
  sol.audio.play_sound("hero_lands")
end

local function wake_up()
  snores:remove()
  bed:get_sprite():set_animation("hero_waking")
  sol.timer.start(1000, function() 
    map:start_dialog("link_house.awake", function()
      sol.timer.start(500, function()
        jump_from_bed()
      end)
    end)
  end)
end

local function  talk_to_tarkin() 

  if map:get_game():has_item("shield") == false then
    map:set_dialog_variable("link_house.tarkin_1", map:get_game():get_player_name())
    map:start_dialog("link_house.tarkin_1", function()
      hero:start_treasure("shield", 1, "b32")
    end)
  else
      map:set_dialog_variable("link_house.tarkin_2", map:get_game():get_player_name())
      map:start_dialog("link_house.tarkin_2")
  end

end

function map:on_started(destination)

marine:get_sprite():set_animation("walking")
  if destination:get_name() == "start_position"  then
    -- the intro scene is playing
    map:get_game():set_hud_enabled(true)
    map:set_pause_enabled(false)
    map:set_dialog_style(0)
    snores:get_sprite():set_ignore_suspend(true)
    bed:get_sprite():set_animation("hero_sleeping")
    hero:freeze()
    hero:set_visible(false)
    sol.timer.start(3000, wake_up)
  else
    snores:remove()
  end

end

function maison_link_exit_sensor:on_activated()

  if map:get_game():has_item("shield") == false then
    map:start_dialog("link_house.tarkin_3")
   hero:set_trajectory(2, 24)
  end

end


function tarkin:on_interaction()

      talk_to_tarkin()

end


