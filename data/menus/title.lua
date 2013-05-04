-- This screen is displayed when the program starts, after the language
-- selection screen (if any).

-- This menu is scripted in an object-oriented style:
-- we create a class title_screen and return it.
-- All data are stored in the self instance.

local title_screen = {}

function title_screen:new()
  local object = {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function title_screen:on_started()

  self.phase = "black"
  self.surface = sol.surface.create(320, 240)
  -- Black screen during 0.3 seconds
  self.timer = sol.timer.start(self, 300, function()
    self:phase_logo_presents()
  end)

 -- Preload sounds
  sol.audio.preload_sounds()

end

function title_screen:phase_logo_presents()

  -- Actual presentation screen
  self.phase = "zs_presents"
  local logo_presents_img = sol.surface.create("title_presentation.png", true)
  local width, height = logo_presents_img:get_size()
  local x, y = 160 - width / 2, 120 - height / 2
  logo_presents_img:draw(self.surface, x, y)
  sol.audio.play_sound("intro")
  -- "Zelda Solarus presents" displayed for two seconds
  self.timer = sol.timer.start(self, 2000, function()
    self:phase_logo_solarus()
  end)

end

function title_screen:phase_logo_solarus()

  self.phase = "solarus_logo"
  local background_color = sol.surface.create(320, 240)  
  background_color:fill_color({255, 255, 255})
  local background_img = sol.surface.create("menus/solarus_logo.png")
  local width, height = background_img:get_size()
  local x, y = 160 - width / 2, 120 - height / 2
  background_color:draw(self.surface, 0, 0)
  background_img:draw(self.surface, x, y)
  -- "Solarus presents" displayed for two seconds
  self.timer = sol.timer.start(self, 2000, function()
    self:phase_intro()
  end)

end

function title_screen:phase_intro()

  -- actual intro screen
  self.phase = "intro"
  self.surface:fade_in(30)
  self.surface:fill_color({0,0,0})
  -- start music
  sol.audio.play_music("the_storm")

end

function title_screen:phase_title()

  -- actual title screen
  self.phase = "title"
  self.surface:fade_in(30)
  -- start music
  sol.audio.play_music("title_screen")
  local background_img = sol.surface.create("menus/title.png")
  local width, height = background_img:get_size()
  local x, y = 160 - width / 2, 120 - height / 2
  background_img:draw(self.surface, x, y)

end

function title_screen:on_draw(dst_surface)

  local width, height = dst_surface:get_size()
  self.surface:draw(dst_surface, width / 2 - 160, height / 2 - 120)

end

function title_screen:on_key_pressed(key)

  local handled = true

  if key == "escape" then
    -- stop the program
    sol.main.exit()

  elseif key == "space" or key == "return" then
    if self.phase == "intro" then
	self.timer:stop()
    	self:phase_title()
    elseif self.phase == "title" then
     self.timer:stop()
     handled = self:try_finish_title()
    end

--  Debug.
  elseif key == "left shift" or key == "right shift" then
    self:finish_title()

  else
    handled = false

  end
end

function title_screen:on_joypad_button_pressed(button)

  return self:try_finish_title()

end

function title_screen:try_finish_title()

  local savegame_menu = require("menus/savegames")
  sol.audio.stop_music()
  sol.main:start_menu(savegame_menu:new())

end

return title_screen

