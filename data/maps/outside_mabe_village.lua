local map = ...
-- Mabe village

local function  talk_to_grand_ma()

  map:start_dialog("mabe_village.grand_ma_1")

end

local function  talk_to_kids() 

  local rand = math.random(4)
  map:start_dialog("mabe_village.kids_" .. rand)

end

function map:on_started(destination)

  if map:get_game():get_value("link_search_sword") == true then
    sol.audio.play_music("sword_search")
  else
    sol.audio.play_music("links_awake")
  end
  grand_ma:get_sprite():set_animation("walking")

end

function grand_ma:on_interaction()

  talk_to_grand_ma()

end

function kid_1:on_interaction()

  talk_to_kids()

end

function kid_2:on_interaction()

  talk_to_kids()

end

function kid_3:on_interaction()

  talk_to_kids()

end

function kid_4:on_interaction()

  talk_to_kids()

end

function link_search_sword_sensor:on_activated()

  if map:get_game():has_item("shield") == true and map:get_game():get_value("link_search_sword" ) == false then
    map:get_game():set_value("link_search_sword", true)
  end

end
