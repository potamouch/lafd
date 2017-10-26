-- An entity the hookshot can attach to.
-- To be used with the scripted hookshot item.
local hookable = ...

-- Tell the hookshot that it can hook to us.
function hookable:is_hookable()
  return true
end

hookable:set_traversable_by(false)
hookable:set_drawn_in_y_order(true)