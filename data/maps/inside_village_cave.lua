-- Inside - Cave of mabe village

-- Variables

local map = ...

-- Methods - Functions

function map:set_music()

  sol.audio.play_music("cave")

end

-- Events

function map:on_started(destination)

  map:set_music()

end
