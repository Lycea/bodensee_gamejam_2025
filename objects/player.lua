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
    self.height = row(1) / 2

    self.inventory = {}
    self.inventory_size_full = 10
    self.inventory_cnt = 0
end

function player:update()
    local new_x = self.pos.x + movement.x
    local new_y = self.pos.y + movement.y

    if movement.x ~=0 or movement.y ~=0 then
      
    end
    if g.var.map:check_collision({x=new_x,y=new_y,width=self.width,height =self.height }) == false then
      self.pos.x = new_x
      self.pos.y = new_y 
    end

    movement.x = 0
    movement.y = 0
    -- self.pos.x = new_x
    -- self.pos.y = new_y
end

function player:add(what, amount)
  amount = amount or 1
  print("adding " .. (amount or 1) .. " of " .. what)
      
  self.inventory[what]= (self.inventory[what] or 0)+ amount
  self.inventory_cnt = self.inventory_cnt + amount
end

function player:remove(what, amount)
  amount = amount or 1
  self.inventory[what] = self.inventory[what] - amount
  self.inventory_cnt = self.inventory_cnt + amount
end

function player:full()
  return  self.inventory_cnt >= self.inventory_size_full
end


function player:draw_inv()
    inv_txt = ""
    for item, num in pairs(self.inventory) do
        if num ~= 0 then
            inv_txt = inv_txt .. num .. " x " .. item .."\n"
        end
    end
    gr.print(inv_txt,cell(20),row(1))

end

function player:draw()
  gr.rectangle("fill",self.pos.x,self.pos.y,self.width,self.height)
  self:draw_inv()

end

return player
