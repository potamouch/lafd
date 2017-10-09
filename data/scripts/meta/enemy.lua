-- Initialize enemy behavior specific to this quest.

local enemy_meta = sol.main.get_metatable("enemy")

-- Helper function to inflict an explicit reaction from a scripted weapon.
-- TODO this should be in the Solarus API one day
function enemy_meta:receive_attack_consequence(attack, reaction)

  if type(reaction) == "number" then
    self:hurt(reaction)
  elseif reaction == "immobilized" then
    self:immobilize()
  elseif reaction == "scared" then
    sol.timer.stop_all(self)  -- Stop the towards_hero behavior.
      local hero = self:get_map():get_hero()
      local angle = hero:get_angle(self)
      local movement = sol.movement.create("straight")
      movement:set_speed(128)
      movement:set_angle(angle)
      movement:start(self)
      sol.timer.start(self, 400, function()
        self:restart()
      end)
  elseif reaction == "protected" then
    sol.audio.play_sound("sword_tapping")
  elseif reaction == "custom" then
    if self.on_custom_attack_received ~= nil then
      self:on_custom_attack_received(attack)
    end
  end

end

return true
