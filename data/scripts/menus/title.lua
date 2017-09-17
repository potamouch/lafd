-- Title screen with an animation before the logo appears.

local title_screen = {}

function title_screen:on_started()

  self.phase = "black"
  self.surface = sol.surface.create(320, 256)
  -- Black screen during 0.3 seconds
  self.timer = sol.timer.start(self, 300, function()
    self:phase_title()
  end)

  -- Preload sounds
  sol.audio.preload_sounds()

end

function title_screen:phase_title()

  -- actual title screen
  self.phase = "title"
  self.surface:fade_in(30)
  -- start music
  sol.audio.play_music("scripts/menus/title_screen_no_intro")
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
     self.timer:stop()
     handled = true
     sol.menu.stop(self)

--  Debug.
  elseif key == "left shift" or key == "right shift" then
    sol.menu.stop(self)

  else
    handled = false

  end

  return handled
end

function title_screen:on_joypad_button_pressed(button)

  return title_screen:on_key_pressed("space")

end

return title_screen

