-- Script that creates a game ready to be played.

-- Usage:
-- local game_manager = require("scripts/game_manager")
-- local game = game_manager:create("savegame_file_name")
-- game:start()

require("scripts/multi_events")
local initial_game = require("scripts/initial_game")

local game_manager = {}
local destructible_meta = sol.main.get_metatable("destructible")

-- Creates a game ready to be played.
function game_manager:create(file)

  -- Create the game (but do not start it).
  local exists = sol.game.exists(file)
  local game = sol.game.load(file)
  if not exists then
    -- This is a new savegame file.
    initial_game:initialize_new_savegame(game)
  end

  function game:get_player_name()
    return self:get_value("player_name")
  end

  function game:set_player_name(player_name)
    self:set_value("player_name", player_name)
  end

  -- Returns whether the current map is in the inside world.
  function game:is_in_inside_world()
    return game:get_map():get_world() == "inside_world"
  end

  -- Returns whether the current map is in the outside world.
  function game:is_in_outside_world()
    return game:get_map():get_world() == "outside_world"
  end

  -- Returns whether the current map is in a dungeon.
  function game:is_in_dungeon()
    return game:get_dungeon() ~= nil
  end

  -- Returns whether something is consuming magic continuously.
  function game:is_magic_decreasing()
    return game.magic_decreasing or false
  end

  -- Sets whether something is consuming magic continuously.
  function game:set_magic_decreasing(magic_decreasing)
    game.magic_decreasing = magic_decreasing
  end

  return game
end


  -- Show a dialog when the player cannot lift them.
  local destructible_meta = sol.main.get_metatable("destructible")
  -- destructible_meta represents the shared behavior of all destructible objects.

  function destructible_meta:on_looked()

    -- Here, self is the destructible object.
    local game = self:get_game()
    local sprite = self:get_sprite() 
    if sprite:get_name() ~= "bush" then
      if not game:has_ability("lift") then
        game:start_dialog("_cannot_lift_too_heavy");
      else
        game:start_dialog("_cannot_lift_still_too_heavy");
      end
    end
  end

return game_manager
