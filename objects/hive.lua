local interactable = require("objects.base_obj.interactable")



--- @class hive : interactable
local hive = interactable:extend()


function hive:new(x, y)
    self.pos = { x = x, y = y }
    self.rad = 16
    self._full = false
    self._fill_p = 0

    self._bees = {}
    for i = 0, 20 do
      table.insert(self._bees, g.lib.objects.bee(x, y, self.pos))
    end

    self._selected = false
end

function hive:update()
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
        self._fill_p = self._fill_p + 0.1
    end

    for _,bee in pairs(self._bees) do
      bee:update()
    end

    return self._selected
end

function hive:draw()
  gr.draw(g.var.tiles.image,g.var.tiles[2][2],self.pos.x -self.rad,self.pos.y-self.rad)
  self:show_area()
  if self._selected == true then
    self:draw_hint("f| collect")
  end

  if self._full == true then
    gr.print("!!!", self.pos.x, self.pos.y - self.rad - 5)
  else
    g.helper.progressbar({ x = self.pos.x - self.rad, y = self.pos.y - self.rad - 5 },
      self.rad * 2, 5, self._fill_p)
  end

  for _, bee in pairs(self._bees) do
    bee:draw()
  end
end

function hive:interact()
  print("interacted with hive")
  if self._full and not g.var.player:full() then
    print("resetting hive ...")
    self._full = false
    self._fill_p = 0
    
    g.var.player:add("raw comb")
  end
end


return hive
