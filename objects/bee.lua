local bee = class_base:extend()


function bee:new(x, y,home_pos)
    self.pos = { x = x, y = y }
    self.width = 8
    self.height = 8
    self.hive_pos = home_pos or {x=0,y=0}

    self._state = "idle"

end


function bee:draw()
  gr.draw(g.var.bee.image,self.pos.x,self.pos.y)
end



function bee:move_to(point , goal_dist, speed)
  local cur_dist = g.helper.distance(self.pos, point)
  if cur_dist <= goal_dist then
    return true
  end

  local dest_dist = cur_dist - speed
  local prc_ = dest_dist / (cur_dist / 100)

  local x, y = g.helper.lerp_point(self.pos.x, self.pos.y, point.x, point.y, (100 - prc_) / 100)
  self.pos.x = x
  self.pos.y = y
end



function bee:start_gathering()
  
end

function bee:update()
  local movement = 1

  if self._state == "get home" then
    
    if self:move_to(self.hive_pos, 5, movement) then
            -- self._state = "idle"
      self._state ="idle"
      return
    end
  elseif self._state == "go flower" then
    if self.goal == nil then
      self.goal = { x = love.math.random(0, 600), y = love.math.random(0,200) }
    end
    if self:move_to(self.goal,2,movement) then
            self._state = "get home"
      self.goal = nil
    end
  elseif self._state == "gather" then
  elseif self._state == "idle" then
    self.pos.x = self.pos.x + love.math.random(-1, 1)
    self.pos.y = self.pos.y + love.math.random(-1, 1)
    if g.helper.distance(self.pos, self.hive_pos) >= 30 then
      self._state = "get home"
    end
  end
end


return bee
