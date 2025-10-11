local interactable = require("objects.base_obj.interactable")



--- @class capper : interactable
local capper = interactable:extend()


function capper:new(x, y)
    self.pos = { x = x, y = y }
    self.rad = 16
    self._full = false
    self._fill_p = 0

    self._selected = false
end

function capper:update()
    -- self._selected = self:in_distance(g.mouse_coords) 
    local tmp_p = g.var.player

    

    -- self._selected = g.helper.circ_collision(self.pos.x, self.pos.y, self.rad,
    --     g.var.player.pos.x + g.var.player.width / 2,
    --     g.var.player.pos.y + g.var.player.height / 2,
    --     g.var.player.width / 1.5)
    self._selected = self:check_circ_area( self:rect_to_circ(tmp_p))

    if self._fill_p >= 100 then
      self._full = true
    end

    if not self._full then
        self._fill_p = self._fill_p + 10
    end

    return self._selected
end

function capper:draw()
  gr.draw(g.var.tiles.image,g.var.tiles[3][1],self.pos.x -self.rad,self.pos.y-self.rad)
  self:show_area()
  if self._selected == true then
    self:draw_hint("f| collect")
  end

  if self._full == true then
    gr.print("!!!",self.pos.x,self.pos.y -self.rad - 5)
  end
  
end

function capper:interact()
  print("interacted with capper")
  if self._full and not g.var.player:full() then
    self._full = false
    self._full_p = 0
    
    g.var.player:add("open comb")
  end
end


return capper
