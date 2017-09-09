-- This module gives access to equipment related info.

-- Usage:
-- require("scripts/equipment")

require("scripts/multi_events")

local function initialize_equipment_features(game)

  if game.are_small_keys_enabled ~= nil then
    -- Already done.
    return
  end

  -- Returns whether a small key counter exists on the current map.
  function game:are_small_keys_enabled()
    return game:get_small_keys_savegame_variable() ~= nil
  end

  -- Returns the name of the savegame variable that stores the number
  -- of small keys for the current map, or nil.
  function game:get_small_keys_savegame_variable()

    local map = game:get_map()

    if map ~= nil then
      -- Does the map explicitly define a small key counter?
      if map.small_keys_savegame_variable ~= nil then
        return map.small_keys_savegame_variable
      end

      -- Are we in a dungeon?
      local dungeon_index = game:get_dungeon_index()
      if dungeon_index ~= nil then
        return "dungeon_" .. dungeon_index .. "_small_keys"
      end
    end

    -- No small keys on this map.
    return nil
  end

  -- Returns whether the player has at least one small key.
  -- Raises an error is small keys are not enabled in the current map.
  function game:has_small_key()

    return game:get_num_small_keys() > 0
  end

  -- Returns the number of small keys of the player.
  -- Raises an error is small keys are not enabled in the current map.
  function game:get_num_small_keys()

    if not game:are_small_keys_enabled() then
      error("Small keys are not enabled in the current map", 2)
    end

    local savegame_variable = game:get_small_keys_savegame_variable()
    return game:get_value(savegame_variable) or 0
  end

  -- Adds a small key to the player.
  -- Raises an error is small keys are not enabled in the current map.
  function game:add_small_key()

    if not game:are_small_keys_enabled() then
      error("Small keys are not enabled in the current map")
    end

    local savegame_variable = game:get_small_keys_savegame_variable()
    game:set_value(savegame_variable, game:get_num_small_keys() + 1)
  end

  -- Removes a small key to the player.
  -- Raises an error is small keys are not enabled in the current map
  -- or if the player has no small keys.
  function game:remove_small_key()

    if not game:has_small_key() then
      error("The player has no small key")
    end

    local savegame_variable = game:get_small_keys_savegame_variable()
    game:set_value(savegame_variable, game:get_num_small_keys() - 1)
  end

end

-- Set up equipment features on any game that starts.
local game_meta = sol.main.get_metatable("game")
game_meta:register_event("on_started", initialize_equipment_features)

return true
