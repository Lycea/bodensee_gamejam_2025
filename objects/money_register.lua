local interactable = require("objects.base_obj.interactable")



--- @class money_register : interactable
local money_register = interactable:extend()


function money_register:new(x, y)
    self.pos = { x = x, y = y }
    self.rad = 16

    self._money = 0

    self._selected = false
end

function money_register:update()
    -- self._selected = self:in_distance(g.mouse_coords) 
    local tmp_p = g.var.player

    self._selected = self:check_circ_area( self:rect_to_circ(tmp_p))

    return self._selected
end

function money_register:draw()
  if self._money == 0 then
    gr.draw(g.var.tiles.image,g.var.tiles[7][1],self.pos.x -self.rad,self.pos.y-self.rad)
  else
    gr.draw(g.var.tiles.image,g.var.tiles[7][2],self.pos.x -self.rad,self.pos.y-self.rad)
  end

  self:show_area()
  if self._selected == true and self._money > 0 then
    self:draw_hint("f| collect")
  end

end

function money_register:interact()
  if self._money >0 then
    print("interacted with money_register")
    g.var.player:add_money(self._money)
    self._money = 0
  end
end


return money_register
