local bee = class_base:extend()


function bee:new(x, y,home_pos)
    self.pos = { x = x, y = y }
    self.width = 8
    self.height = 8
    self.hive_pos = home_pos or {x=0,y=0}
end

function bee:draw()
  gr.draw(g.var.bee.image,self.pos.x,self.pos.y)
end

function bee:update()

    self.pos.x = self.pos.x + love.math.random(-2, 2)
    self.pos.y = self.pos.y + love.math.random(-2,2)

end


return bee
