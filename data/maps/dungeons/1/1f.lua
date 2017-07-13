-- Lua script of map dungeons/1/1f.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished(destination)
    if destination == dungeon_1_1_B then
      map:set_doors_open("dungeon_1_door_group_1", true)
      map:set_doors_open("dungeon_1_door_group_2", false)
      game:start_dialog("dungeon_1")
    end
    if destination == dungeon_1_stairs_1_B then
      map:set_doors_open("dungeon_1_door_group_1", true)
      map:set_doors_open("dungeon_1_door_group_2", true)
    end
end


-- Deaths

-- Group 1
local function dungeon_1_enemy_group_1_dead(enemy)
      if not map:has_entities("dungeon_1_enemy_group_1") and not map:get_game():get_value("dungeon_1_small_key_1") then
           sol.audio.play_sound("secret_1")
           map:create_pickable{
                treasure_name = "small_key",
                treasure_variant = 1,
                treasure_savegame_variable = "dungeon_1_small_key_1",
                x = 744,
                y = 1384,
                layer = 0
              }
      end
end
for enemy in map:get_entities("dungeon_1_enemy_group_1") do
  enemy.on_dead = dungeon_1_enemy_group_1_dead
end

-- Group 6
local function dungeon_1_enemy_group_6_dead(enemy)
      if not map:has_entities("dungeon_1_enemy_group_6") then
          map:set_doors_open("dungeon_1_door_group_1", true)
          sol.audio.play_sound("door_open")
      end
end
for enemy in map:get_entities("dungeon_1_enemy_group_6") do
  enemy.on_dead = dungeon_1_enemy_group_6_dead
end

-- Group 12
local function dungeon_1_enemy_group_12_dead(enemy)
      if not map:has_entities("dungeon_1_enemy_group_12") and not map:get_game():get_value("dungeon_1_small_key_1") then
          sol.audio.play_sound("secret_1")
          map:create_chest{
                sprite = "entities/chest",
                treasure_name = "rupee",
                treasure_variant = 3,
                treasure_savegame_variable = "dungeon_1_chest_rupee_1",
                x = 904,
                y = 856,
                layer = 0
              }
      end
end
for enemy in map:get_entities("dungeon_1_enemy_group_12") do
  enemy.on_dead = dungeon_1_enemy_group_12_dead
end

-- Group 13
local function dungeon_1_enemy_group_13_dead(enemy)
      if not map:has_entities("dungeon_1_enemy_group_13") and not map:get_game():get_value("dungeon_1_chest_beak_of_stone") then
          sol.audio.play_sound("secret_1")
          map:create_chest{
                sprite = "entities/chest",
                treasure_name = "beak_of_stone",
                treasure_variant = 1,
                treasure_savegame_variable = "dungeon_1_chest_beak_of_stone",
                x = 1864,
                y = 608,
                layer = 0
              }
      end
end
for enemy in map:get_entities("dungeon_1_enemy_group_13") do
  enemy.on_dead = dungeon_1_enemy_group_13_dead
end


-- Switchs

function dungeon_1_switch_1:on_activated()

    sol.audio.play_sound("secret_1")
    map:create_chest{
      sprite = "entities/chest",
      treasure_name = "small_key",
      treasure_variant = 1,
      treasure_savegame_variable = "dungeon_1_small_key_2",
      x = 1224,
      y = 1112,
      layer = 0
    }
end

-- Blocks

function dungeon_1_block_1:on_moved()

          map:set_doors_open("dungeon_1_door_group_2", true)
          sol.audio.play_sound("door_open")

end

-- Sensors

function dungeon_1_sensor_1:on_activated()

  if map:has_entities("dungeon_1_enemy_group_6") then
    map:set_doors_open("dungeon_1_door_group_1", false)
    sol.audio.play_sound("door_closed")
  end

end

function dungeon_1_sensor_2:on_activated()

  if map:has_entities("dungeon_1_enemy_group_6") then
    map:set_doors_open("dungeon_1_door_group_1", false)
    sol.audio.play_sound("door_closed")
  end

end
