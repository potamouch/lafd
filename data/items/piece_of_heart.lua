-- Piece of heart
local item = ...

local message_id = {
  "found_piece_of_heart.first",
  "found_piece_of_heart.second",
  "found_piece_of_heart.third",
  "found_piece_of_heart.fourth"
}

function item:on_created()

  self:set_sound_when_picked(nil)
  self:set_sound_when_brandished("piece_of_heart")
end

function item:on_obtained(variant)

  local game = self:get_game()
  local nb_pieces_of_heart = game:get_value("i1030") or 0
  game:start_dialog(message_id[nb_pieces_of_heart + 1], function()
    game:set_value("i1030", (nb_pieces_of_heart + 1) % 4)
    if nb_pieces_of_heart == 3 then
      game:add_max_life(4)
    end
    game:add_life(game:get_max_life())
  end)

end

-- This function is not used in releases :)
function item:print_pieces_of_heart()

  local pieces = {
    -- TODO
  }

  local nb_found = 0
  for i, v in ipairs(pieces) do
    if self:get_game():get_value(v.savegame_variable) then
      nb_found = nb_found + 1
    else
      print("You don't have piece of heart #" .. i .. ": " .. v.description)
    end
  end
  print("Total pieces of heart found: " .. nb_found .. "/" .. #pieces)

end

-- If you want to know your missing pieces of heart, uncomment the line below
-- item:print_pieces_of_heart()

