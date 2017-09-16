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
  local x_hero,y_hero, layer_hero = hero:get_position()
  game:set_pause_allowed(false)
  game:set_suspended(true)
  hero:get_sprite():set_ignore_suspend(true)
  hero:freeze()
  hero:set_animation("brandish")
  local sword_entity = map:create_custom_entity({
    name = "brandish_sword",
    sprite = "entities/items",
    x = x_hero,
    y = y_hero - 24,
    width = 16,
    height = 16,
    layer = layer_hero,
    direction = 0
  })
  sword_entity:get_sprite():set_animation("sword")
  sword_entity:get_sprite():set_direction(0)
  sol.audio.stop_music()
  sol.audio.play_sound("treasure_sword")
  local timer = sol.timer.start(3000, function()
      local map = game:get_map()
      game:start_dialog("_treasure.sword.1", function()
        sol.audio.play_music("maps/out/let_the_journey_begin")
        local timerspin = sol.timer.start(5400, function() 
          map:remove_entities("brandish")
          hero:set_animation("spin_attack", function() 
            hero:unfreeze()
              game:set_pause_allowed(true)
              game:set_suspended(false)
            local timermusic= sol.timer.start(300, function()  
              sol.audio.play_music("maps/out/overworld")
            end)
            timermusic:set_suspended_with_map(false)
          end)
       end)
       timerspin:set_suspended_with_map(false)
    end)
  end)
  timer:set_suspended_with_map(false)

end

function item:on_obtained(variant, savegame_variable)

    game:set_value("main_quest_step", 4)

end
