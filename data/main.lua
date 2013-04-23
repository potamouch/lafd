-- Main script of the quest.

-- Event called when the program starts.
function sol.main:on_started()

  -- Load built-in settings (audio volume, video mode, etc.).
  sol.main.load_settings()
  -- Just need this here, no need to require globally.
  local title_screen = require("menus/title")
  -- Show the title menu initially.
  sol.main:start_menu(title_screen:new())

end

-- Event called when the program stops.
function sol.main:on_finished()

  sol.main.save_settings()

end

-- Stops the current menu and start another one.
function sol.main:start_menu(menu)

  if sol.main.menu ~= nil then
    sol.menu.stop(sol.main.menu)
  end
  sol.main.menu = menu
  if menu ~= nil then
    sol.menu.start(sol.main, menu)
  end

end
