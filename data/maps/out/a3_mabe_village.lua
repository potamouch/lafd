-- Outside - Mabe village

-- Variables
local map = ...
local game = map:get_game()
local marine_song = false
local ball
local ball_shadow
local ball_is_launch = false

-- Methods - Functions

function map:set_music()
  
  if game:get_value("main_quest_step") == 3  then
    sol.audio.play_music("maps/out/sword_search")
  else
    if marine_song then
      sol.audio.play_music("maps/out/song_of_marine")
    else
      sol.audio.play_music("maps/out/mabe_village")
    end
  end

end

function map:init_marine()
 
  if game:get_value("main_quest_step") < 4  then
    marine:set_visible(false)
  else
    marine:get_sprite():set_animation("waiting")
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

  game:start_dialog("maps.out.mabe_village.marine_1", function()
    marine_song = true
    map:set_music()
  end)

end

function  map:talk_to_grand_ma()

    if map:get_game():get_value("main_quest_step") < 8 then
      game:start_dialog("maps.out.mabe_village.grand_ma_1")
    else
      game:start_dialog("maps.out.mabe_village.grand_ma_2")
    end



end

function  map:talk_to_kids() 

  local rand = math.random(4)
  game:start_dialog("maps.out.mabe_village.kids_" .. rand)

end

function map:get_alert_moblins()

  local hero = map:get_hero()
  hero:freeze()
  sol.audio.play_music("maps/out/moblins_and_bow_wow")
  game:start_dialog("maps.out.mabe_village.kids_alert_moblins", function()
      self:get_game():set_value("main_quest_step", 9)
      hero:unfreeze()
  end)

end

function map:on_started(destination)

  if   game:get_value("main_quest_step") == 2 then
    game:set_value("main_quest_step", 3)
  end
  map:set_music()
  map:init_marine()
  grand_ma:get_sprite():set_animation("walking")
  kid_1:get_sprite():set_animation("playing")
  kid_2:get_sprite():set_animation("playing")
  map:create_ball(kid_1, kid_2)

end

-- Events

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

function moblins_start_1_sensor:on_activated()

  if map:get_game():get_value("main_quest_step") == 8 then
    map:get_alert_moblins()
  end

end

function moblins_start_2_sensor:on_activated()

  if map:get_game():get_value("main_quest_step") == 8 then
    map:get_alert_moblins()
  end

end


function moblins_stop_1_sensor:on_activated()

  if map:get_game():get_value("main_quest_step") == 9 then
    self:get_game():set_value("main_quest_step", 8)
    map:set_music()
  end

end

function moblins_stop_2_sensor:on_activated()

  if map:get_game():get_value("main_quest_step") == 9 then
    self:get_game():set_value("main_quest_step", 8)
    map:set_music()
  end

end

function marine_sensor_1:on_activated()

    marine_song = false
    map:set_music()

end

function marine_sensor_2:on_activated()

    marine_song = false
    map:set_music()

end