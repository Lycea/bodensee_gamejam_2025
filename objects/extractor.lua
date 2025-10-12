local interactable = require("objects.base_obj.interactable")



--- @class extractor : interactable
local extractor = interactable:extend()

local state_ids = {
    empty = 1,
    filled = 2,
    done = 3
}
function extractor:new(x, y)
    self.pos = { x = x, y = y }
    self.rad = 16

    self._done_p = 0
    self._done = false

    self._state = "empty"

    self._selected = false
end

function extractor:update()
    -- self._selected = self:in_distance(g.mouse_coords) 
    local tmp_p = g.var.player

    

    -- self._selected = g.helper.circ_collision(self.pos.x, self.pos.y, self.rad,
    --     g.var.player.pos.x + g.var.player.width / 2,
    --     g.var.player.pos.y + g.var.player.height / 2,
    --     g.var.player.width / 1.5)
    self._selected = self:check_circ_area( self:rect_to_circ(tmp_p))

    if self._done_p >= 100 then
        self._done = true
      self._state = "done"
    end

    if not self._done and self._state == "filled" then
        self._done_p = self._done_p + 0.1
    end

    return self._selected
end

function extractor:draw()
  gr.draw(g.var.tiles.image,g.var.tiles[4][ state_ids[self._state]],self.pos.x -self.rad,self.pos.y-self.rad)
  self:show_area()

    if self._selected == true then
        if self._state == "empty" then
            self:draw_hint("f| add comb")
        elseif self._state == "done" then
            self:draw_hint("f| collect")
        end
    end
  
  if self._done == true then
    gr.print("!!!",self.pos.x,self.pos.y -self.rad - 5)
  elseif self._state == "filled" then
    g.helper.progressbar({ x = self.pos.x - self.rad, y = self.pos.y - self.rad - 5 },
                         self.rad*2,5,self._done_p)
  end
end

function extractor:interact()
  print("interacted with extractor")
    if self._state == "done" and not g.var.player:full() then
        print("resetting extractor ...")
        self._done = false
        self._done_p = 0
        self._state = "empty"
        g.var.player:add("honey")
    end

    if self._state == "empty" then
        if g.var.player:remove("comb") == true then

          self._state = "filled"
        end
    end
end


return extractor
