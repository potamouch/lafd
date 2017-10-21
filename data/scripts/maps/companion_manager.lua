local companion_manager = {}

function companion_manager:init_map(map)

  local game = map:get_game()
  local hero = map:get_hero()
  local step = game:get_value("main_quest_step")
  local companion = false
  local sprite = nil
  local model = nil
  local x,y, layer = hero:get_position()
  if step >= 10 then
    companion = true
    sprite = "npc/bowwow"
    model = "bowwow_follow"
  end
  if companion then
    map:create_custom_entity({
        name = "companion",
        sprite = sprite,
        x = x,
        y = y,
        width = 16,
        height = 16,
        layer = layer,
        direction = 0,
        model =  model
      })
  end
end


return companion_manager