-- Outside - Mabe village

-- Variables
local map = ...
local game = map:get_game()

-- Methods - Functions

function map:set_music()
  
  if game:get_value("main_quest_step") == 3  then
    sol.audio.play_music("maps/out/sword_search")
  else
    sol.audio.play_music("maps/out/mabe_village")
  end

end

function map:init_marine()
 
  if game:get_value("main_quest_step") < 4  then
    marine:set_visible(false)
  else
    marine:get_sprite():set_animation("waiting")
  end

end


function map:talk_to_marine() 

  game:start_dialog("maps.out.mabe_village.marine_1")

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

function map:get_alert_molblins()

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

      map:talk_to_marine()

end

function moblins_start_1_sensor:on_activated()

  if map:get_game():get_value("main_quest_step") == 8 then
    map:get_alert_molblins()
  end

end

function moblins_start_2_sensor:on_activated()

  if map:get_game():get_value("main_quest_step") == 8 then
    map:get_alert_molblins()
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
