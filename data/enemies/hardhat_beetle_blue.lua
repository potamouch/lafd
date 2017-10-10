local enemy = ...

-- Blue Hardhat Beetle.

local properties = {

}

function enemy:on_created()

  local hero = self:get_map():get_hero()
  self:create_sprite("enemies/" .. enemy:get_breed())
  self:set_life(1000000)
  self:set_damage(1)
  --self:set_push_hero_on_sword(true)
  self:receive_attack_consequence("sword", "scared")
  local movement = sol.movement.create("target")
  movement:set_speed(16)
  movement:set_target(hero)
  movement:start(enemy)

end

function enemy:on_restarted()

  local hero = self:get_map():get_hero()
  local movement = sol.movement.create("target")
  movement:set_speed(16)
  movement:set_target(hero)
  movement:start(enemy)

end


