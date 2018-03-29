-- Outside - West Mt Tarmaranch

-- Variables
local map = ...
local game = map:get_game()
local hero = map:get_hero()
local companion_manager = require("scripts/maps/companion_manager")

-- Methods - Functions


-- Events

function map:on_started()

 map:set_music()
 map:set_digging_allowed(true)
 companion_manager:init_map(map)
  --Hibiscus
  -- Father and hibiscus
  local item = game:get_item("magnifying_lens")
  local variant = item:get_variant()
  if game:get_value("main_quest_step") < 18 or variant >= 8  then
    father:set_enabled(false)
    hibiscus:set_enabled(false)
  end
 local father_sprite = father:get_sprite()
 father_sprite:set_animation("calling")
 local hibiscus_sprite = hibiscus:get_sprite()
 hibiscus_sprite:set_animation("magnifying_lens")
 hibiscus_sprite:set_direction(7)

end

function map:get_music_mountains()


end

function map:set_music()
  
  local x_hero, y_hero = hero:get_position()
  local x_separator, y_separator = auto_separator_1:get_position()
  if y_hero <  y_separator then
    if game:get_player_name():lower() == "marin" then
      sol.audio.play_music("maps/out/mt_tamaranch_marin")
    else
      sol.audio.play_music("maps/out/mt_tamaranch")
    end
  else
      sol.audio.play_music("maps/out/overworld")
  end

end

function map:talk_to_father() 

 local father_sprite = father:get_sprite()
 local item = game:get_item("magnifying_lens")
 local variant = item:get_variant()
 father_sprite:set_animation("sitting")
 if variant == 7 then
   game:start_dialog("maps.out.mambos_cave.father_1", function(answer)
    if answer == 1 then
      game:start_dialog("maps.out.mambos_cave.father_3", function()
        game:set_hud_enabled(false)
        game:set_pause_allowed(false)
        hero:freeze()
        father_sprite:set_animation("eating")
        sol.timer.start(father, 5000, function()
          father_sprite:set_animation("sitting")
          game:start_dialog("maps.out.mambos_cave.father_4", function()
            hibiscus:set_enabled(false)
            hero:start_treasure("magnifying_lens", 8, nil, function()
              father_sprite:set_animation("eating")
              game:set_hud_enabled(true)
              game:set_pause_allowed(true)
              hero:unfreeze()
            end)
          end)
        end)
      end)
    else
      game:start_dialog("maps.out.mambos_cave.father_2", function()
        father_sprite:set_animation("calling")
      end)
    end
   end)
 elseif variant == 8 then
      game:start_dialog("maps.out.mambos_cave.father_5", function()
        father_sprite:set_animation("eating")
      end)
 else
   game:start_dialog("maps.out.mambos_cave.father_6", function(answer)
    game:start_dialog("maps.out.mambos_cave.father_2", function()
      father:set_animation("calling")
    end)
   end)
  end

end

auto_separator_1:register_event("on_activating", function(separator, direction4)

  if direction4 == 1 then
    if game:get_player_name():lower() == "marin" then
      sol.audio.play_music("maps/out/mt_tamaranch_marin")
    else
      sol.audio.play_music("maps/out/mt_tamaranch")
    end
  elseif direction4 == 3 then
      sol.audio.play_music("maps/out/overworld")
  end

end)

function father:on_interaction()

      map:talk_to_father()

end
