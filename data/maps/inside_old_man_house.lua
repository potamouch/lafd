-- Old man's house
local map = ...

local function set_music()

  if map:get_game():get_value("step_1_link_search_sword") == true then
    sol.audio.play_music("sword_search")
  else
    sol.audio.play_music("links_awake")
  end

end

function map:on_started(destination)

  set_music()

end
