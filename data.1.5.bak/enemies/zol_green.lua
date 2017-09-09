local enemy = ...

local behavior = require("enemies/lib/towards_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 1,
  damage = 1,
  normal_speed = 16,
  faster_speed = 16,
}

behavior:create(enemy, properties)

--enemy:set_random_treasures(
--  { "rupee", 1 },
--  { "rupee", 1 }
--)
