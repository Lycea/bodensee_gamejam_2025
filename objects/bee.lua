local bee = class_base:extend()


function bee:new(x, y,home_pos)
    self.pos = { x = x, y = y }
    self.width = 8
    self.height = 8
    self.hive_pos = home_pos or {x=0,y=0}

    self._state = "random"

end

function bee:draw()
  gr.draw(g.var.bee.image,self.pos.x,self.pos.y)
end

function bee:update()

    if self._state == "get home" then
    local cur_dist = g.helper.distance(self.pos, self.hive_pos) 
    if cur_dist < 5 then
      self._state = "random"
    end
    local x, y = g.helper.lerp_point(self.pos.x, self.pos.y, self.hive_pos.x, self.hive_pos.y, cur_dist/ 100  )
    self.pos.x = x
    self.pos.y = y

  elseif self._state == "random" then

    self.pos.x = self.pos.x + love.math.random(-1, 1)
    self.pos.y = self.pos.y + love.math.random(-1,1)
    if g.helper.distance(self.pos,self.hive_pos) > 30 then
      self._state = "get home"
    end
  end
end


return bee
