local interactable = require("objects.base_obj.interactable")



--- @class store : interactable
local store = interactable:extend()


function store:new(x, y)
    self.pos = { x = x, y = y }
    self.rad = 16

    self._honey = 0

    self._timer = g.lib.timer(1)
    self._selected = false
end

function store:update()
    -- self._selected = self:in_distance(g.mouse_coords) 
    local tmp_p = g.var.player

    self._selected = self:check_circ_area( self:rect_to_circ(tmp_p))

    if self._timer:check() then
      if love.math.random(0,100) > 90 and self._honey > 0 then
            self._honey = self._honey - 1
        g.var.map._register._money = g.var.map._register._money + 20
      end
    end
    return self._selected
end

function store:draw()
  if self._honey == 0 then
    gr.draw(g.var.tiles.image,g.var.tiles[6][1],self.pos.x -self.rad,self.pos.y-self.rad)
  else
    gr.draw(g.var.tiles.image,g.var.tiles[6][2],self.pos.x -self.rad,self.pos.y-self.rad)
  end

  self:show_area()
  if self._selected == true then
    self:draw_hint("f| add honey")
  end

end

function store:interact()
  local avail_honey = g.var.player:check_amount("honey")
  if avail_honey >0 then
    print("interacted with store")
    g.var.player:remove("honey", avail_honey)
    self._honey = self._honey + avail_honey
  end

end


return store
