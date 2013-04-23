local map = ...
-- Village des mouettes

function map:on_started(destination)

  night_overlay = sol.surface.create(320, 240)  -- Créer une surface vide de 320x240 pixels appelée night_overlay.
  night_overlay:set_opacity(192)  -- La rendre partiellement transparente.
  night_overlay:fill_color({0, 0, 64})  -- La remplir en bleu foncé pour un effet de nuit.

end


  function map:on_draw(destination_surface)
    night_overlay:draw(destination_surface)
  end
