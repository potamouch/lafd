-- Inside - Cave of mabe village
local map = ...

function map:set_music()

  sol.audio.play_music("cave")

end

function map:on_started(destination)

  map:set_music()

end
