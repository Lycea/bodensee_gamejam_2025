local interactable = require("objects.base_obj.interactable")



--- @class upgrader : interactable
local upgrader = interactable:extend()


function upgrader:new(x, y,price, increase, upg_function ,tile,txt,max_upg)
  self.pos = { x = x, y = y }
  self.rad = 16
  self._next_price = price
  self._price_inc = increase
  self._upg_function = upg_function
  self._tile = tile
  self._maxed = false

  self._txt = txt or " nothing"

  self.max_upg = max_upg
  self.cur_up = 0

  self._selected = false
end

function upgrader:update()
  -- self._selected = self:in_distance(g.mouse_coords)
  local tmp_p = g.var.player
  self._selected = self:check_circ_area(self:rect_to_circ(tmp_p))

  return self._selected
end

function upgrader:draw()
  print("upgrader, tile", self._tile)
  gr.draw(g.var.tiles.image, g.var.tiles[8][self._tile], self.pos.x - self.rad, self.pos.y - self.rad)

  if self._maxed == false then
    gr.print(self._next_price .. " $", self.pos.x - self.rad, self.pos.y - self.rad * 2)
  else
    gr.print("MAXED", self.pos.x - self.rad, self.pos.y - self.rad * 2)
  end
  self:show_area()

  if self._selected == true and g.var.player:check_money() > self._next_price then
    self:draw_hint("f| "..self._txt)
  end

end

function upgrader:interact()
  local avail_money = g.var.player:check_money()
  if avail_money > self._next_price and not self._maxed then
    print("interacted with upgrader")
    self.cur_up = self.cur_up + 1

    self._maxed = self.cur_up >= self.max_upg

    g.var.player:remove_money(self._next_price)
    if self._upg_function() then
      self._next_price = self._next_price* self._price_inc
    else
      self._nex_price = "maxed"
    end
  end
end


return upgrader
