local interactable = require("objects.base_obj.interactable")
local shop = interactable:extend()

function shop:new(x, y, tile, txt)
  self.pos = { x = x, y = y }
  self.rad = 16
  self._tile = tile

  self._txt = txt or " nothing"

  self._selected = false
end

function shop:update()
  -- self._selected = self:in_distance(g.mouse_coords)
  local tmp_p = g.var.player
  self._selected = self:check_circ_area(self:rect_to_circ(tmp_p))

  return self._selected
end


function shop:draw()
  -- gr.draw(g.var.tiles.image, g.var.tiles[8][self._tile], self.pos.x - self.rad, self.pos.y - self.rad)

  self:show_area()

  if self._selected == true then
    self:draw_hint("f| " .. self._txt)
  end
end

function shop:interact()
  g.var.uis.shop_ui_main_window:set_visible(true)

end

return shop
