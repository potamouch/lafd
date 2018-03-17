-- Outside - Mabe village

-- Variables
local map = ...
local game = map:get_game()
local marine_song = false
local ball
local ball_shadow
local ball_is_launch = false
local companion_manager = require("scripts/maps/companion_manager")
local hero_is_alerted = false
local notes = nil
local notes2 = nil

-- Methods - Functions

function map:set_music()
  
  if game:get_value("main_quest_step") == 3  then
    sol.audio.play_music("maps/out/sword_search")
  elseif  hero:get_distance(kids_alert_position_center) < 160 then
    sol.audio.play_music("maps/out/moblins_and_bow_wow")
  else
    if marine_song then
      sol.audio.play_music("maps/out/song_of_marine")
    else
      sol.audio.play_music("maps/out/mabe_village")
    end
  end

end

function map:marine_sing()

  local x,y,layer = marine:get_position()
  notes = map:create_custom_entity{
    x = x,
    y = y - 16,
    layer = layer + 1,
    width = 24,
    height = 32,
    direction = 0,
    sprite = "entities/notes"
  }
  notes2 = map:create_custom_entity{
    x = x,
    y = y - 16,
    layer = layer + 1,
    width = 24,
    height = 32,
    direction = 2,
    sprite = "entities/notes"
  }
  marine:get_sprite():set_animation("singing")
  marine_song = true
  map:set_music()

end

function map:init_marine()
 
  if game:get_value("main_quest_step") < 4  then
    marine:set_enabled(false)
  else
    marine:get_sprite():set_animation("waiting")
  end

end

function map:init_bowwow()
 
  if game:get_value("main_quest_step") > 7 and game:get_value("main_quest_step") < 12  then
    bowwow:set_enabled(false)
  end

end


function map:create_ball(player_1, player_2)

  local x_1,y_1, layer_1 = player_1:get_position()
  local x_2,y_2, layer_2 = player_2:get_position()
  x_1 = x_1 + 8
  x_2 = x_2 - 8
  local x_ball_shadow = x_1 
  local y_ball_shadow = y_1 + 8
  local radius =  (x_2 - x_1) / 2
  local center_y = y_1
  local center_x = x_1 + radius
  ball = map:create_custom_entity{
    x = x_1,
    y = y_1,
    width = 16,
    height = 24,
    direction = 0,
    layer = 1 ,
    sprite= "entities/ball"
  }
  ball_shadow = map:create_custom_entity{
    x = x_ball_shadow,
    y = y_ball_shadow,
    width = 16,
    height = 24,
    direction = 0,
    layer = 0,
    sprite= "entities/ball_shadow"
  }
  movement = sol.movement.create("circle")
  movement:set_radius(radius)
  movement:set_angle_speed(180)
  movement:set_initial_angle(0)
  movement:set_ignore_obstacles(true)
  movement:set_clockwise(false)
  movement:set_center(center_x, center_y)
  function  movement:on_position_changed()
      local ball_x, ball_y, ball_layer = ball:get_position()
      ball_shadow:set_position(ball_x, y_ball_shadow)
  end
  sol.timer.start(player_1, 10, function()
      local ball_x, ball_y, ball_layer = ball:get_position()
      if ball_x > x_1 - 2 and  ball_x < x_1 + 2 then
        movement:set_clockwise(not movement:is_clockwise())
      end
      if ball_x > x_2 - 2 and  ball_x < x_2 + 2 then
        movement:set_clockwise(not movement:is_clockwise())
      end
    return true
  end)
  movement:start(ball)

end


function map:talk_to_fishman() 

  game:start_dialog("maps.out.mabe_village.fishman_1", function(answer)
    if answer == 1 then
      game:start_dialog("maps.out.mabe_village.fishman_2")
      --TODO - CODING FISHING GAME
    else
      game:start_dialog("maps.out.mabe_village.fishman_3")
    end
  end)

end


function map:talk_to_marine() 

  if game:get_value("main_quest_step") <= 4 then
    game:start_dialog("maps.out.mabe_village.marine_1", game:get_player_name(), function()
      map:marine_sing()
    end)
  elseif game:get_value("main_quest_step") < 11 then
    game:start_dialog("maps.out.mabe_village.marine_2", game:get_player_name(), function()
      map:marine_sing()
    end)
  else
    game:start_dialog("maps.out.mabe_village.marine_3", game:get_player_name(), function()
      map:marine_sing()
    end)
  end

end


function  map:talk_to_grand_ma()

    if map:get_game():get_value("main_quest_step") ~= 8 and map:get_game():get_value("main_quest_step") ~= 9 then
      game:start_dialog("maps.out.mabe_village.grand_ma_1", function()
        grand_ma:get_sprite():set_direction(3)
      end)
    else
      game:start_dialog("maps.out.mabe_village.grand_ma_2", function()
        grand_ma:get_sprite():set_direction(3)
      end)
    end



end

function  map:talk_to_kids() 

  local rand = math.random(4)
  game:start_dialog("maps.out.mabe_village.kids_" .. rand)

end

function map:get_alert_moblins()

  local hero = map:get_hero()
  hero:freeze()
  game:start_dialog("maps.out.mabe_village.kids_alert_moblins", function()
      self:get_game():set_value("main_quest_step", 9)
      hero:unfreeze()
  end)

end

-- Events

function map:repeat_kids_scared_direction_check()

  local directionkid1 = kid_1:get_direction4_to(hero)
  local directionkid2 = kid_2:get_direction4_to(hero)
  kid_1:get_sprite():set_direction(directionkid1)
  kid_2:get_sprite():set_direction(directionkid2)

  -- Rappeler cette fonction dans 0.1 seconde.
  sol.timer.start(map, 100, function() 
    map:repeat_kids_scared_direction_check()
  end)
end

function map:on_started(destination)

  -- Digging
  map:set_digging_allowed(true)
   -- Sword quest
  if game:get_value("main_quest_step") == 2 then
    game:set_value("main_quest_step", 3)
  end
  map:set_music()
  companion_manager:init_map(map)
  map:init_marine()
  map:init_bowwow()
  
 -- Grand ma
  grand_ma:get_sprite():set_animation("walking")

   -- Kids
  if map:get_game():get_value("main_quest_step") ~= 8 and map:get_game():get_value("main_quest_step") ~= 9 then
    kid_1:get_sprite():set_animation("playing")
    kid_2:get_sprite():set_animation("playing")
    map:create_ball(kid_1, kid_2)
  else
    kid_1:get_sprite():set_animation("scared")
    kid_2:get_sprite():set_animation("scared")
    kid_1:get_sprite():set_ignore_suspend(true)
    kid_2:get_sprite():set_ignore_suspend(true)
    map:repeat_kids_scared_direction_check()
  end

  -- Thief detect
  local hero_is_thief_message = game:get_value("hero_is_thief_message")
  if hero_is_thief_message then
    game:start_dialog("maps.out.mabe_village.thief_message", function()
      game:set_value("hero_is_thief_message", false)
    end)
  end

  --Weathercock statue pushed
  if game:get_value("mabe_village_weathercook_statue_pushed") then
      push_weathercook_sensor:set_enabled(false)
      weathercock:set_enabled(false)
      weathercook_statue_1:set_position(616,232)
      weathercook_statue_2:set_position(616,248)
  end

if map:get_game():get_value("main_quest_step") == 8 or map:get_game():get_value("main_quest_step") == 9 then
    sol.timer.start(map, 500, function()
        map:set_music()
        if  hero:get_distance(kids_alert_position_center) < 60 then
          if not hero_is_alerted then
            hero:get_sprite():set_direction(3)
            hero_is_alerted = true
            map:get_alert_moblins()
          end
        else
          if hero_is_alerted then
            hero_is_alerted = false
          end
        end
        return true
     end)
  end
  

end

function map:on_opening_transition_finished(destination)

 

end

function grand_ma:on_interaction()

  map:talk_to_grand_ma()

end

function kid_1:on_interaction()

  map:talk_to_kids()

end

function kid_2:on_interaction()

  map:talk_to_kids()

end

function kid_3:on_interaction()

    if map:get_game():get_value("main_quest_step") == 9 then
      game:start_dialog("maps.out.mabe_village.kids_alert_moblins")
    else
      map:talk_to_kids()
    end

end

function kid_4:on_interaction()

    if map:get_game():get_value("main_quest_step") == 9 then
      game:start_dialog("maps.out.mabe_village.kids_alert_moblins")
    else
      map:talk_to_kids()
    end

end

function marine:on_interaction()

    if marine_song == false then
      map:talk_to_marine()
    end

end

function fishman:on_interaction()

      map:talk_to_fishman()

end

function marine_sensor_1:on_activated()

    marine_song = false
    marine:get_sprite():set_animation("waiting")
    map:set_music()
    if notes ~= nil then
      notes:remove()
    end
    if notes2 ~= nil then
      notes2:remove()
    end

end

function marine_sensor_2:on_activated()

    marine_song = false
    marine:get_sprite():set_animation("waiting")
    map:set_music()
    if notes ~= nil then
      notes:remove()
    end
    if notes2 ~= nil then
      notes2:remove()
    end

end

--Push the weathercook statue
function push_weathercook_sensor:on_activated_repeat()
    if hero:get_animation() == "pushing" and hero:get_direction() == 1 and game:get_ability("lift") == 2 then
      hero:freeze()
      hero:get_sprite():set_animation("pushing")
      push_weathercook_sensor:set_enabled(false)
      weathercock:set_enabled(false)
      sol.audio.play_sound("hero_pushes")
        local weathercook_x,weathercook_y = map:get_entity("weathercook_statue_1"):get_position()
        local weathercook_x_2,weathercook_y_2 = map:get_entity("weathercook_statue_2"):get_position()
        local i = 0
        sol.timer.start(map,50,function()
          i = i + 1
          weathercook_y = weathercook_y - 1
          weathercook_statue_1:set_position(weathercook_x, weathercook_y)
          weathercook_y_2 = weathercook_y_2 - 1
          weathercook_statue_2:set_position(weathercook_x_2, weathercook_y_2)
          if i < 32 then return true end
          sol.audio.play_sound("secret_2")
          hero:unfreeze()
          game:set_value("mabe_village_weathercook_statue_pushed",true)
        end)
    end
end