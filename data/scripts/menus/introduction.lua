-- Title screen with an animation before the logo appears.

local introduction_screen = {}

function introduction_screen:on_started()

  self.phase = "black"
  self.surface = sol.surface.create(320, 256)
  -- Black screen during 0.3 seconds
  self.timer = sol.timer.start(self, 300, function()
    self:phase_intro()
  end)

  -- Preload sounds
  sol.audio.preload_sounds()

end

function introduction_screen:phase_intro()

  -- actual intro screen
  self.phase = "intro"
  self.surface:fade_in(30)
  self.surface:clear()
  -- start music
  sol.audio.play_music("scripts/menus/introduction")

end

function introduction_screen:on_draw(dst_surface)

  local width, height = dst_surface:get_size()
  self.surface:draw(dst_surface, width / 2 - 160, height / 2 - 120)

end

function introduction_screen:on_key_pressed(key)

  local handled = true

  if key == "escape" then
    -- stop the program
    sol.main.exit()

  elseif key == "space" or key == "return" then
     self.timer:stop()
     handled = true
     sol.menu.stop(self)

  else
    handled = false

  end

  return handled
end

function introduction_screen:on_joypad_button_pressed(button)

  return introduction_screen:on_key_pressed("space")

end

return introduction_screen

