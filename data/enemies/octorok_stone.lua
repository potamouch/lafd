-- Stone shot by Octorok.

local enemy = ...
local speed = 192

function enemy:on_created()

  enemy:set_life(1)
  enemy:set_damage(2)
  enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_size(8, 8)
  enemy:set_origin(4, 4)
  enemy:set_invincible()
  enemy:set_obstacle_behavior("flying")
  self:set_can_be_pushed_by_shield(true)
  self:set_can_push_hero_on_shield(true)
end

function enemy:on_obstacle_reached()

  enemy:remove()
end

function enemy:go(direction4)

  local angle = direction4 * math.pi / 2
  local movement = sol.movement.create("straight")
  movement:set_speed(speed)
  movement:set_angle(angle)
  movement:set_smooth(false)
  movement:start(enemy)

  enemy:get_sprite():set_direction(direction4)
end

-- Allow to hurt enemies.
function enemy:allow_hurt_enemies(allow_hurt)
  -- Define event.
  if not allow_hurt then
    enemy.on_collision_enemy = nil
    return
  end
  function enemy:on_collision_enemy(other_enemy, other_sprite, my_sprite)
    local life_points = self:get_damage()
    other_enemy:hurt(life_points)
    -- Call custom event after hurting enemy.
    self:on_hurt_enemy(other_enemy, other_sprite)
  end
end

-- Override normal push function.
function enemy:on_shield_collision(shield)
  local map = self:get_map()
  -- Disable push for a while.
  self:set_being_pushed(true)
  sol.timer.start(map, 200, function()
    self:set_being_pushed(false)
  end)
  -- Hurt enemies after bounce on shield.
  self:allow_hurt_enemies(true)
  -- Override movement.
  local m = self:get_movement()
  if not m then return end
  m = sol.movement.create("straight")
  m:set_angle(shield:get_direction4_to(self) * math.pi/2)
  m:set_smooth(false)
  m:set_speed(speed)
  m:set_max_distance(300)
  m:start(self)
end

-- CUSTOM EVENT: called after hurting an enemy.
function enemy:on_hurt_enemy(other_enemy, other_sprite)
end
