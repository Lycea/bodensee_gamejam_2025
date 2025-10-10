--- @class player
local player = class_base:extend()


local function cell(num)
  return g.var.cell_width * num
end

local function row(num)
  return g.var.cell_height * num
end


function player:new(x, y)
    self.pos = { x = cell(3), y = row(3) }
    self.width = cell(1)/2
    self.height = row(1)/2
end

function player:update()
    local new_x = self.pos.x + movement.x
    local new_y = self.pos.y + movement.y

    if movement.x ~=0 or movement.y ~=0 then
      print(movement.x,movement.y)
    end
    if g.var.map:check_collision({x=new_x,y=new_y,width=self.width,height =self.height }) == false then
      print("no collision")
      self.pos.x = new_x
      self.pos.y = new_y 
    end

    movement.x = 0
    movement.y = 0
    -- self.pos.x = new_x
    -- self.pos.y = new_y
end

function player:draw()
  gr.rectangle("fill",self.pos.x,self.pos.y,self.width,self.height)
end

return player
