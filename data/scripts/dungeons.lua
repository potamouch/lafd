-- Defines the dungeon information of a game.

-- Usage:
-- require("scripts/dungeons")

require("scripts/multi_events")

local function initialize_dungeon_features(game)

  if game.get_dungeon ~= nil then
    -- Already done.
    return
  end

  -- Define the existing dungeons and their floors for the minimap menu.
  local dungeons_info = {
    [1] = {
      lowest_floor = 0,
      highest_floor = 0,
      rows = 6,
      cols= 7,
      teletransporter_end_dungeon = {
        map_id = "out/a4_south_mabe_village",
        destination_name = "dungeon_1_2_A"
      },
      secrets = {
        [0] = {        
          [25] = {
            savegame = "dungeon_1_feather",
            signal = false
          },
          [28] = {
            savegame = "dungeon_1_boss_key",
            signal = true
          },
          [30] = {
            savegame = "dungeon_1_beak_of_stone",
            signal = false
          },
          [35] = {
            savegame = "dungeon_1_rupee_1",
            signal = false
          },
          [36] = {
            savegame = "dungeon_1_small_key_3",
            signal = true
          },
          [44] = {
            savegame = "dungeon_1_small_key_2",
            signal = true
          },
          [45] = {
            savegame = "dungeon_1_map",
            signal = false
          },
          [51] = {
            savegame = "dungeon_1_small_key_1",
            signal = true
          }
        }
      },
      small_boss = {
        floor = 0,
        breed = "boss/rolling_bones",
        x = 640 + 1440,
        y = 720 + 365
      },
      boss = {
        floor = 0,
        breed = "boss/moldorm",
        x = 640 + 1440,
        y = 720 + 365
      }
    },
   [2] = {
      lowest_floor = 0,
      highest_floor = 0,
      rows = 7,
      cols= 6,
      teletransporter_end_dungeon = {
        map_id = "out/b1_egg_of_the_dream_fish",
        destination_name = "dungeon_2_2_A"
      },
      maps = { "dungeons/2/1f"},
      secrets = {
        [0] = {        
          [2] = {
            savegame = "dungeon_2_power_bracelet",
            signal = false
          },
          [4] = {
            savegame = "dungeon_2_small_key_5",
            signal = true
          },
          [11] = {
            savegame = "dungeon_2_map",
            signal = false
          },
          [14] = {
            savegame = "dungeon_2_boss_key",
            signal = true
          },
          [34] = {
            savegame = "dungeon_2_beak_of_stone",
            signal = false
          },
          [44] = {
            savegame = "dungeon_2_small_key_1",
            signal = true
          },
          [46] = {
            savegame = "dungeon_2_small_key_2",
            signal = true
          },
          [51] = {
            savegame = "dungeon_2_rupee_1",
            signal = false
          },
          [52] = {
            savegame = "dungeon_2_compass",
            signal = false
          },
          [53] = {
            savegame = "dungeon_2_small_key_3",
            signal = true
          },
          [54] = {
            savegame = "dungeon_2_small_key_4",
            signal = true
          },
        }
      },
      small_boss = {
        breed = "boss/hinox_master",
      },
      boss = {
        floor = 0,
        breed = "boss/genie",
        x = 640 + 1440,
        y = 720 + 365
      }
   },
   [3] = {
        lowest_floor = -1,
        highest_floor = 0,
        rows = 8,
        cols= 4,
        secrets = {
        },
        boss = {
          floor = 0,
          x = 640 + 1440,
          y = 720 + 365,
          savegame_variable = "dungeon_3_boss",
        }
      }
    }

  -- Returns the index of the current dungeon if any, or nil.
  function game:get_dungeon_index()

    local world = game:get_map():get_world()
    if world == nil then
      return nil
    end
    local index = tonumber(world:match("^dungeon_([0-9]+)$"))
    return index
  end

  -- Returns the current dungeon if any, or nil.
  function game:get_dungeon()

    local index = game:get_dungeon_index()
    return dungeons_info[index]
  end

  function game:is_dungeon_finished(dungeon_index)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    return game:get_value("dungeon_" .. dungeon_index .. "_finished")
  end

  function game:set_dungeon_finished(dungeon_index, finished)
    if finished == nil then
      finished = true
    end
    dungeon_index = dungeon_index or game:get_dungeon_index()
    game:set_value("dungeon_" .. dungeon_index .. "_finished", finished)
  end

  function game:is_secret_room(dungeon_index, floor, room)

      dungeon_index = dungeon_index or game:get_dungeon_index()
      if floor == nil then
        if game:get_map() ~= nil then
          floor = game:get_map():get_floor()
        else
          floor = 0
        end
      end
      if dungeons_info[dungeon_index] == nil then
        return false
      end
      if dungeons_info[dungeon_index]["secrets"][floor] == nil then
        return false
      end
      if dungeons_info[dungeon_index]["secrets"][floor][room] == nil then
        return false
      end
      if game:get_value(dungeons_info[dungeon_index]["secrets"][floor][room]["savegame"]) then
        return false
      else
        return true
      end

  end

  function game:is_secret_signal_room(dungeon_index, floor, room)

      dungeon_index = dungeon_index or game:get_dungeon_index()
      if floor == nil then
        if game:get_map() ~= nil then
          floor = game:get_map():get_floor()
        else
          floor = 0
        end
      end
      if dungeons_info[dungeon_index] == nil then
        return false
      end
      if dungeons_info[dungeon_index]["secrets"][floor] == nil then
        return false
      end
      if dungeons_info[dungeon_index]["secrets"][floor][room] == nil then
        return false
      end
      if dungeons_info[dungeon_index]["secrets"][floor][room]["signal"] then
        return true
      else
        return false
      end

  end


  function game:has_dungeon_map(dungeon_index)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    return game:get_value("dungeon_" .. dungeon_index .. "_map")
  end


  function game:has_dungeon_compass(dungeon_index)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    return game:get_value("dungeon_" .. dungeon_index .. "_compass")
  end

  function game:has_dungeon_boss_key(dungeon_index)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    return game:get_value("dungeon_" .. dungeon_index .. "_boss_key")
  end

  function game:has_dungeon_beak_of_stone(dungeon_index)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    return game:get_value("dungeon_" .. dungeon_index .. "_beak_of_stone")

  end

  function game:get_dungeon_name(dungeon_index)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    return sol.language.get_string("dungeon_" .. dungeon_index .. ".name")
  end

  function game:play_dungeon_music(dungeon_index)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    local music = "maps/dungeons/" .. dungeon_index .. "/dungeon"
    local savegame_boss = "dungeon_" .. dungeon_index .. "_boss"
    local savegame_treasure = "dungeon_" .. dungeon_index .. "_big_treasure"
    if  game:get_value(savegame_boss) and not game:get_value(savegame_treasure) then
      music = "maps/dungeons/instruments"
    end
    sol.audio.play_music(music)
  end

  local function compute_merged_rooms(game, dungeon_index, floor)

    assert(game ~= nil)
    assert(dungeon_index ~= nil)
    assert(floor ~= nil)

    local map = game:get_map()
    local map_width, map_height = map:get_size()
    local room_width, room_height = 320, 240  -- TODO don't hardcode these numbers
    local num_columns = math.floor(map_width / room_width)
    -- TODO limitation: assumes that all maps of the dungeon have the same size

    -- Use the minimap sprite to deduce merged rooms.
    local sprite = sol.sprite.create("menus/dungeon_maps/map_" .. dungeon_index)
    assert(sprite ~= nil)
    local animation = tostring(floor)
    local merged_rooms = {}

    for room = 1, sprite:get_num_directions(animation) - 1 do
      local width, height = sprite:get_size(floor, room)
      local room_rows, room_columns = height / 16, width / 16  -- TODO don't hardcode these numbers
      local current_room = room

      if room_rows ~= 1 or room_columns ~= 1 then

        for i = 1, room_rows do
          for j = 1, room_columns do
            if current_room ~= room then
              merged_rooms[current_room] = room
            end
            current_room = current_room + 1
          end
          current_room = current_room + num_columns - room_columns
        end
      end
    end
    return merged_rooms
  end

  -- Returns the name of the boolean variable that stores the exploration
  -- of a dungeon room, or nil.
  -- If dungeon_index and floor are nil, the current dungeon and current floor are used.
  function game:get_explored_dungeon_room_variable(dungeon_index, floor, room)

    dungeon_index = dungeon_index or game:get_dungeon_index()
    room = room or 1
    if floor == nil then
      if game:get_map() ~= nil then
        floor = game:get_map():get_floor()
      else
        floor = 0
      end
    end

    local dungeon = game:get_dungeon(dungeon_index)

    -- If it is a merged room, get the upper-left part.
    -- Lazily compute merged rooms for this floor.
    dungeon.merged_rooms = dungeon.merged_rooms or {}
    dungeon.merged_rooms[floor] = dungeon.merged_rooms[floor] or compute_merged_rooms(game, dungeon_index, floor)
    room = dungeon.merged_rooms[floor][room] or room

    local room_name
    if floor >= 0 then
      room_name = tostring(floor + 1) .. "f_" .. room
    else
      room_name = math.abs(floor) .. "b_" .. room
    end

    return "dungeon_" .. dungeon_index .. "_explored_" .. room_name
  end

  -- Returns whether a dungeon room has been explored.
  -- If dungeon_index and floor are nil, the current dungeon and current floor are used.
  function game:has_explored_dungeon_room(dungeon_index, floor, room)
    return self:get_value(
      self:get_explored_dungeon_room_variable(dungeon_index, floor, room)
    )
  end

  -- Changes the exploration state of a dungeon room.
  -- If dungeon_index and floor are nil, the current dungeon and current floor are used.
  -- explored is true by default.
  function game:set_explored_dungeon_room(dungeon_index, floor, room, explored)

    if explored == nil then
      explored = true
    end
    self:set_value(
      self:get_explored_dungeon_room_variable(dungeon_index, floor, room),
      explored
    )
  end

  -- Show the dungeon name when entering a dungeon.
  game:register_event("notify_world_changed", function()
    local dungeon_index = game:get_dungeon_index()
    if dungeon_index ~= nil then
      local map = game:get_map()
      local timer = sol.timer.start(map, 10, function()
        game:start_dialog("dungeons." .. dungeon_index .. ".welcome")
      end)
      timer:set_suspended_with_map(true)
    end
  end)

end

-- Set up dungeon features on any game that starts.
local game_meta = sol.main.get_metatable("game")
game_meta:register_event("on_started", initialize_dungeon_features)

return true
