-- Outside - Kanalet castle

-- Variables
local map = ...
local game = map:get_game()
local hero = map:get_hero()
local companion_manager = require("scripts/maps/companion_manager")

-- Methods - Functions

function map:set_music()
  
   sol.audio.play_music("maps/out/overworld")

end


function map:talk_to_monkey() 

    local item = game:get_item("magnifying_lens")
    local variant = item:get_variant()
    if game:get_value("main_quest_step") < 12 then
      game:start_dialog("maps.out.kanalet_castle.monkey_1")
    elseif game:get_value("main_quest_step") < 14 then
        if variant == 4 then
          game:start_dialog("maps.out.kanalet_castle.monkey_3", function(answer) 
            if answer == 1 then
              game:start_dialog("maps.out.kanalet_castle.monkey_4", function()
                map:monkey_build_bridge()
              end)
            else
              game:start_dialog("maps.out.kanalet_castle.monkey_2")
            end
          end)
        else
          game:start_dialog("maps.out.kanalet_castle.monkey_2")
        end
    end

end

function map:monkey_build_bridge()

  hero:freeze()
  local x, y, layer = monkey:get_position()
  sol.audio.stop_music()
  sol.audio.play_sound("monkeys_build_a_bridge")
  local movement_monkey = sol.movement.create("target")
  movement_monkey:set_target(monkey_0)
  movement_monkey:set_speed(60)
  movement_monkey:set_ignore_obstacles(true)
  movement_monkey:start(monkey)
  function movement_monkey:on_finished()
    monkey:get_sprite():set_animation("stopped")
    movement_monkey:stop()
  end
  local num_monkeys_arrived = 0
  for i = 1, 10 do
    local x_random = math.random(-128, 128)
    local timer = math.random(1000)
    if i == 10 then
      timer = 14000
    end
    local x_monkey = x + x_random
    local y_monkey = y + 150
    local direction = 0
    if x_monkey < x then
      direction = 0
    else
      direction = 2
    end
    sol.timer.start(map, timer, function()
      local target_entity = map:get_entity("monkey_" .. i)
      local monkey_entity = map:create_custom_entity({
          name = "monk_"..i,
          sprite = "npc/monkey_brown",
          x = x_monkey,
          y = y_monkey,
          width = 24,
          height = 32,
          layer = layer,
          direction = direction
        })
        local monkey_sprite = monkey_entity:get_sprite()
        monkey_sprite:set_animation("jumping")       
        local movement = sol.movement.create("target")
        movement:set_target(target_entity)
        movement:set_speed(100)
        movement:set_ignore_obstacles(true)
        movement:start(monkey_entity)
        function movement:on_finished()
          num_monkeys_arrived = num_monkeys_arrived + 1
          if i == 10 then
            monkey_entity:remove()
          end
          if num_monkeys_arrived == 9 then
                sol.timer.start(monkey, 9000, function()
                  bridge:set_enabled(true)
                  baton:set_enabled(true)
                  sol.audio.play_sound("secret_1")
                  monkey:get_sprite():set_animation("stopped")
                  monkey:get_sprite():set_direction(3)
                  game:start_dialog("maps.out.kanalet_castle.monkey_5", function()
                    map:set_music()
                    map:monkey_leave_bridge()
                    map:get_entity("monkey"):get_sprite():set_animation("jumping")
                    map:get_entity("monkey"):get_sprite():set_direction(1)
                  end)
                end)
          end
        end
    end)
  end

end

function map:monkey_leave_bridge()

    local x, y, layer = monkey:get_position()
    for i = 1, 9 do
      local monkey_entity = map:get_entity("monk_" .. i)
      local monkey_sprite = monkey_entity:get_sprite()
      monkey_sprite:set_animation("walking")    
      monkey_sprite:set_direction(1)    
      local sprite = monkey_entity:get_sprite()
      local movement = sol.movement.create("target")
      movement:set_target(x, y - 300)
      movement:set_speed(120)
      movement:set_ignore_obstacles(true)
      movement:start(monkey_entity)
      function movement:on_finished()
        monkey_entity:remove()
      end
    end
    local movement = sol.movement.create("target")
    movement:set_target(x, y - 300)
    movement:set_speed(80)
    movement:set_ignore_obstacles(true)
    movement:start(monkey)
    function movement:on_finished()
      monkey:remove()
      hero:unfreeze()
      game:set_value("main_quest_step", 14) 
    end
end

-- Events

function map:on_started()

  map:set_digging_allowed(true)
  local item = game:get_item("magnifying_lens")
  local variant = item:get_variant()
  companion_manager:init_map(map)
  if game:get_value("castle_door_is_open") then
    castle_door:set_enabled(false)
  end
  if game:get_value("main_quest_step") < 14 then
    baton:set_enabled(false)
    bridge:set_enabled(false)
  else
    monkey:set_enabled(false)
  end
  if variant > 4 then
    baton:set_enabled(false)
  end

end



function monkey:on_interaction()

  map:talk_to_monkey()

end
