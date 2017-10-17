local weather_manager = {}

  weather_manager.ambientlight = {0,0,0,0}

  weather_manager.get_light = function(map)
    return weather_manager.light
  end

  weather_manager.set_light = function(light)
    if light < 0 then light = 0 elseif light > 16 then light = 16 end
    weather_manager.light = light
  end

  weather_manager.add_light = function( amount)
    local light = weather_manager.light - amount
    if light < 0 then light = 0 elseif light > 16 then light = 16 end
    weather_manager.light = light
  end
  
  weather_manager.set_ambient_light = function(ambientlight)
    if ambientlight == nil or ambientlight == "" then
      weather_manager.ambientlight = {0,0,255,48}
    elseif ambientlight == "day" then
      weather_manager.ambientlight = {0,0,0,0}
    elseif ambientlight == "night" then
      weather_manager.ambientlight = {0,0,255,48}
    end
  end

function weather_manager:launch_rain(map)

    local ambientlight = {0,0,0,0}
    for ent in map:get_entities("settings") do
      local lightlevel = split(split(ent:get_name(), "settings:")[1],"-")[1]
      local ambientlevel = split(split(ent:get_name(), "settings:")[1],"-")[2]
      weather_manager:set_light(tonumber(lightlevel))
      weather_manager:set_ambient_light(ambientlevel)
    end


    local rainsprite1 = sol.sprite.create("entities/rain")
    local rainsprite2 = sol.sprite.create("entities/rain")
    rainsprite2:set_direction(1)

    rainsprite1:set_blend_mode("add")
    rainsprite2:set_blend_mode("add")

    local rainposx = {}
    local rainposy = {}
    math.randomseed(397)
    for i = 1, 4096 do
      rainposx[i] = math.random(2048)
      rainposy[i] = math.random(2048)
    end

    weather_manager.raintimer = 0
    map.on_draw = function(map, dst_surface)

      local camera_x, camera_y = map:get_camera():get_bounding_box()
      dst_surface:fill_color(ambientlight, 0, 0, 1024, 1024)
      dst_surface:fill_color({0, 0, 0, 150}, 0, 0, 1024, 1024)
      if (math.random(100) == 1) then
        dst_surface:fill_color({255, 255, 255, 128}, 0, 0, 1024, 1024)
       if (math.random(5) == 1) then
          sol.audio.play_sound("thunder")
        end
      end
      if weather_manager.raintimer <= 0 then
        weather_manager.raintimer = 150
        sol.audio.play_sound("water_fill")
      end
      weather_manager.raintimer = weather_manager.raintimer - 1
    
      for i = 1, 1024 do
        map:draw_visual(rainsprite1, rainposx[i] + camera_x / 1.5, rainposy[i] + camera_y / 1.5)
      end

      for i = 1024, 4096 do
        map:draw_visual(rainsprite2, rainposx[i] + camera_x / 1.5, rainposy[i] + camera_y / 1.5)
      end
    end

end

return weather_manager