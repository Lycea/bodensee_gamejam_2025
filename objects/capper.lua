local interactable = require("objects.base_obj.interactable")



--- @class capper : interactable
local capper = interactable:extend()

local state_ids = {
    empty = 1,
    filled = 2,
    done = 3
}
function capper:new(x, y)
    self.pos = { x = x, y = y }
    self.rad = 16

    self.done_amt = 0
    self.queued = 0

    self.max_queue = 1
    self.max_done = 1

    self._done_p = 0
    self._done = false

    self._state = "empty"

    self._selected = false
end



function capper:upg_queued()
  if self._state == "done" then
    

  elseif self._done_p >= 100  then
    self.done_amt = self.done_amt + 1
    self.queued = self.queued - 1

    print("queue amt", self.queued)
    if self.queued == 0 then
      self._done = true
      self._state = "done"
    else
      self._done_p = 0
    end
  end
  
  if not self._done and self._state == "filled" then
    self._done_p = self._done_p + 0.1
  end

end

function capper:upg_single()
  if self._done_p >= 100 then
    self._done = true
    self._state = "done"
  end

  if not self._done and self._state == "filled" then
    self._done_p = self._done_p + 0.1
  end
end

function capper:update()
    -- self._selected = self:in_distance(g.mouse_coords) 
    local tmp_p = g.var.player

  --self:upg_single()
  self:upg_queued()

    self._selected = self:check_circ_area( self:rect_to_circ(tmp_p))

    return self._selected
end


function capper:upgrade()
    self.max_queue = self.max_queue + 1
    self.max_done  = self.max_done +1
end

function capper:draw()
  gr.draw(g.var.tiles.image,g.var.tiles[3][ state_ids[self._state]],self.pos.x -self.rad,self.pos.y-self.rad)
  self:show_area()

    if self._selected == true then
        if self._state == "empty" then
            self:draw_hint("f| add raw comb")
        elseif self._state == "filled" then
          self:draw_hint("f| interact")
        elseif self._state == "done" then
            self:draw_hint("f| collect")
        end
    end
  
  if self._done == true then
        gr.print("!!!", self.pos.x, self.pos.y - self.rad - 5)
        g.var.anims.done:draw("var1",
                              {
                                x = self.pos.x - 16,
                                y = self.pos.y - self.rad - 5 - 16
        })


  elseif self._state == "filled" then
    g.helper.progressbar({ x = self.pos.x - self.rad, y = self.pos.y - self.rad - 5 },
                         self.rad*2,5,self._done_p)
  end
end



function capper:int_sing()
  if self._state == "done" and not g.var.player:full() then
    print("resetting capper ...")
    self._done = false
    self._done_p = 0
    self._state = "empty"
    g.var.player:add("comb")
  end

  if self._state == "empty" then
    if g.var.player:remove("raw comb") == true then
      self._state = "filled"
    end
  end

end

function capper:int_mult()
  local pl = g.var.player
  local full = pl:full()

  
  if self._state == "done" and not full then
    print("resetting capper ...")
    self._done = false
    self._done_p = 0
    
    self._state = "empty"
    g.var.player:add("comb", self.done_amt)
    self.done_amt = 0
  end

  if self._state == "filled" then
    if self.done_amt > 0 and not full then
      pl:add("comb", self.done_amt)
      self.done_amt = 0
    end
    if self.queued ~= self.max_queue then
      local inv_num = pl:check_amount("raw comb")
      local num_to_add = math.min(self.max_queue - self.queued, inv_num)
      
      pl:remove("raw comb",num_to_add)
      self.queued = self.queued + num_to_add
    end
  end

  if self._state == "empty" then
    if g.var.player:remove("raw comb") == true then
            self._state = "filled"
      self.queued = self.queued +1
    end
  end
end


function capper:interact()
  print("interacted with capper")
  --self:int_sing()
  self:int_mult()
end


return capper
