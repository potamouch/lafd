-- Outside - Prairie

-- Variables
local map = ...
local game = map:get_game()
local companion_manager = require("scripts/maps/companion_manager")
local owl_manager = require("scripts/maps/owl_manager")
local travel_manager = require("scripts/maps/travel_manager")
local tarin_chased_by_bees = false
-- Methods - Functions

function map:set_music()
  
  if game:get_value("main_quest_step") == 3  then
    sol.audio.play_music("maps/out/sword_search")
  elseif tarin_chased_by_bees then
      sol.audio.play_music("maps/out/tarin_chased_by_bees")
  else
    sol.audio.play_music("maps/out/overworld")
  end

end

function map:open_dungeon_3()

  dungeon_3_entrance:get_sprite():set_animation("opened")
  dungeon_3_entrance:set_traversable_by(true)

end

-- Events

function  map:talk_to_tarin() 

  game:start_dialog("maps.out.prairie.tarin_1", game:get_player_name(), function(answer)
    if answer == 1 then
      map:tarin_search_honey()
    else
      game:start_dialog("maps.out.prairie.tarin_2", game:get_player_name())
    end
  end)

end


function map:tarin_search_honey()
  local camera = map:get_camera()
  camera:start_manual()
  local x_tarin, y_tarin, layer_tarin = tarin:get_position()
  local x_honey, y_honey, layer_honey = honey:get_position()
  hero:freeze()
  game:set_hud_enabled(false)
  game:set_pause_allowed(false)
  local tarin_sprite = tarin:get_sprite()
  tarin_sprite:set_ignore_suspend(true)
  tarin_sprite:set_animation("brandish")
  sol.audio.play_sound("treasure")
  local baton_entity = map:create_custom_entity({
    name = "brandish_baton",
    sprite = "entities/items",
    x = x_tarin,
    y = y_tarin- 32,
    width = 16,
    height = 16,
    layer = layer_tarin + 1,
    direction = 0
  })
  sol.timer.start(map, 1000, function()
    hero:set_animation("walking")
    hero:set_direction(3)
    local movement = sol.movement.create("target")
    movement:set_speed(30)
    movement:set_target(link_wait_tarin_place)
    movement:start(hero)
    function movement:on_finished()
      hero:set_animation("stopped")
      hero:set_direction(1)
    end
  end)
  sol.timer.start(map, 2000, function()
    sol.audio.stop_music()
    tarin_sprite:set_animation("searching_honey")
    baton_entity:remove()
    sol.audio.play_sound("beehive_poke")
    for i=1,4 do
      sol.timer.start(map, 500 * i, function()
          if i == 2 then
              sol.audio.play_sound("beehive_poke")
          end
          sol.audio.play_sound("beehive_bees")
          local bee = map:create_custom_entity({
            name = "bee_chase_" .. i,
            sprite = "npc/bee",
            x = x_honey,
            y = y_honey,
            width = 16,
            height = 16,
            layer = layer_honey + 1,
            direction = 0
          })
      end)
    end
    sol.timer.start(map, 2500, function()
        tarin_chased_by_bees = true
        map:set_music()
        tarin_sprite:set_animation("run_bee")
        map:tarin_run()
    end)
    sol.timer.start(map, 7000, function()
        tarin_chased_by_bees = true
        map:set_music()
        tarin_sprite:set_animation("run_bee")
        map:tarin_leave_map()
    end)
  end)
end

function map:tarin_run()

  local tarin_sprite = tarin:get_sprite()
  local movement = sol.movement.create("circle")
  movement:set_angle_speed(200)
  movement:set_center(circle_center)
  movement:set_radius(48)
  movement:set_initial_angle(315)
  movement:set_ignore_obstacles(true)
  movement:start(tarin_invisible)
  function movement:on_finished()
    --map:tarin_go_next_place(index)
  end
  function movement:on_position_changed()
      local x_tarin,y_tarin= tarin_invisible:get_position()
      local circle_angle = circle_center:get_angle(tarin_invisible)
      local movement_angle = circle_angle + math.pi/2
      movement_angle = math.deg(movement_angle)
      local direction = math.floor((movement_angle + 45) / 90)
      direction = direction % 4
      tarin:set_position(x_tarin, y_tarin)
      tarin_sprite:set_direction(direction)
  end

  for bee in map:get_entities("bee_chase") do
    local movement_bee = sol.movement.create("target")
    local bee_sprite = bee:get_sprite()
    movement_bee:set_target(tarin, math.random(-16, 16), math.random(-16, 16))
    movement_bee:set_speed(150)
    movement_bee:set_ignore_obstacles(true)
    movement_bee:start(bee)
    function movement_bee:on_position_changed()
        local circle_angle = circle_center:get_angle(tarin_invisible)
        local movement_angle = circle_angle + math.pi/2
        movement_angle = math.deg(movement_angle)
        local direction = math.floor((movement_angle + 45) / 90)
        direction = direction % 4
        bee_sprite:set_direction(direction)
    end
  end

end

function map:tarin_leave_map()
  
    tarin_invisible:get_movement():stop()
    local camera = map:get_camera()
    local tarin_sprite = tarin:get_sprite()
    local movement_target = sol.movement.create("target")
    movement_target:set_speed(120)
    movement_target:set_target(tarin_leave_map)
    movement_target:start(tarin_invisible)
    function movement_target:on_position_changed()
        local x_tarin,y_tarin= tarin_invisible:get_position()
        local direction = movement_target:get_direction4()
        tarin:set_position(x_tarin, y_tarin)
        tarin_sprite:set_direction(direction)
    end
    function movement_target:on_finished()
      tarin_invisible:set_enabled(false)
      tarin:set_enabled(false)
      for bee in map:get_entities("bee_chase") do
        bee:set_enabled(false)
      end
      sol.timer.start(map, 2500, function()
        sol.audio.stop_music()
        local movement = sol.movement.create("jump")
        movement:set_speed(100)
        movement:set_distance(32)
        movement:set_direction8(6)
        movement:set_ignore_obstacles(true)
        movement:start(honey)
        game:set_value("main_quest_step", 19)
        sol.audio.play_sound("beehive_fall")
        hero:unfreeze()
        game:set_hud_enabled(true)
        game:set_pause_allowed(false)
        tarin_chased_by_bees = false
        map:set_music()
        hero:unfreeze()
        game:set_hud_enabled(true)
        game:set_pause_allowed(true)
        tarin_chased_by_bees = false
        map:set_music()
        local movement_camera = sol.movement.create("target")
        local x,y = camera:get_position_to_track(hero)
        movement_camera:set_speed(120)
        movement_camera:set_target(x,y)
        movement_camera:start(camera)
        function movement_camera:on_finished()
          camera:start_tracking(hero)
        end
      end)
    end

end

function map:on_started(destination)

  map:set_music()
  map:set_digging_allowed(true)
  owl_7:set_enabled(false)
  companion_manager:init_map(map)
  -- Travel
  travel_transporter:set_enabled(false)
  -- Statue pig
  if game:get_value("statue_pig_exploded") then
    statue_pig:remove()
  end
  dungeon_3_entrance:set_traversable_by(false)
  if game:get_value("main_quest_step") > 16 then
    map:open_dungeon_3()
  end
  -- Tarin
  if game:get_value("main_quest_step") ~= 18 then
    tarin:set_enabled(false)
  end
  -- Honey and bees
  if game:get_value("main_quest_step") > 19 then
    honey:set_enabled(false)
    for bee in map:get_entities("bee") do
        bee:set_enabled(false)
    end

  end
  -- Seashell's tree
  local seashell_tree_found = false
  collision_seashell:add_collision_test("facing", function(entity, other, entity_sprite, other_sprite)
    if other:get_type() == 'hero' and hero:get_state() == "running" and seashell_tree_found == false and game:get_value("seashell_13") == nil then
      sol.timer.start(map, 250, function()
        movement = sol.movement.create("jump")
        movement:set_speed(100)
        movement:set_distance(64)
        movement:set_direction8(0)
        movement:set_ignore_obstacles(true)
        movement:start(seashell_13, function()
          seashell_tree_found = true 
        end)
      end)
    end
  end)

end

function travel_sensor:on_activated()

    travel_manager:init(map, 1)

end

function dungeon_3_lock:on_interaction()

      if game:get_value("main_quest_step") < 16 then
          game:start_dialog("maps.out.prairie.dungeon_3_lock")
      elseif game:get_value("main_quest_step") == 16 then
        sol.audio.stop_music()
        hero:freeze()
        sol.timer.start(map, 1000, function() 
          sol.audio.play_sound("shake")
          local camera = map:get_camera()
          local shake_config = {
              count = 32,
              amplitude = 4,
              speed = 90,
          }
          camera:shake(shake_config, function()
            sol.audio.play_sound("secret_2")
            local sprite = dungeon_3_entrance:get_sprite()
            sprite:set_animation("opening")
            sol.timer.start(map, 800, function() 
              map:open_dungeon_3()
              hero:unfreeze()
              map:set_music()
            end)
          end)
          game:set_value("main_quest_step", 17)
        end)
      end

end

function sign_start:on_interaction()

  game:start_dialog("maps.out.south_prairie.surprise_3")
  game:set_value("wart_cave_start", true)

end

function tarin:on_interaction()

      map:talk_to_tarin()

end

function owl_7_sensor:on_activated()

  if game:get_value("main_quest_step") == 18  and game:get_value("owl_7") ~= true then
    owl_manager:appear(map, 7, function()
    map:set_music()
    end)
  end

end

--Weak doors play secret sound on opened
function weak_door_1:on_opened() sol.audio.play_sound("secret_1") end
function weak_door_2:on_opened() sol.audio.play_sound("secret_1") end

