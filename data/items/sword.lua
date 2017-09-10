-- Sword
local item = ...
local game = item:get_game()

function item:on_created()

  self:set_savegame_variable("possession_sword")
  item:set_brandish_when_picked(false)
  self:set_sound_when_brandished("treasure_sword")

end

function item:on_variant_changed(variant)

  -- The possession state of the sword determines the built-in ability "sword".
  self:get_game():set_ability("sword", variant)

end

function item:on_obtaining(variant, savegame_variable)

  local map = game:get_map()
  local hero = map:get_hero()
  hero:freeze()
  hero:set_animation("brandish")
  sol.audio.stop_music()
  sol.audio.play_sound("treasure_sword")
  local timer = sol.timer.start(3500, function()
      local map = game:get_map()
      game:start_dialog("_treasure.sword.1", function()
        sol.audio.play_music("maps/out/let_the_journey_begin")
        local timerspin = sol.timer.start(6000, function()  
          sol.audio.play_sound("sword_spin_attack_release")
          hero:set_animation("spin_attack", function() 
          hero:unfreeze()
            local timermusic= sol.timer.start(4000, function()  
                sol.audio.play_music("maps/out/overworld")
            end)
          end)
       end)
    end)
  end)

end

function item:on_obtained(variant, savegame_variable)


    game:set_value("main_quest_step", 4)
    --sol.audio.play_music("maps/out/let_the_journey_begin", function()
     --     hero:set_animation("spin_attack")
        --sol.audio.play_music("maps/out/overworld")
   -- end)

end
