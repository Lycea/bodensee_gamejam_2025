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

    self.money = 0
--    self.money = 2000
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

function player:add_money(amount)
  self.money = self.money + amount
end

function player:check_money()
  return self.money
end

function player:remove_money(amount)
  self.money = self.money - amount
end

function player:remove(what, amount)
  if self.inventory[what] == nil or (self.inventory[what] or 0)< (amount or 1)  then
    print("not able to use this item!")
    return false
  end

  amount = amount or 1
  self.inventory[what] = self.inventory[what] - amount
  self.inventory_cnt = self.inventory_cnt - amount
  return true
end

function player:full()
  return  self.inventory_cnt >= self.inventory_size_full
end

function player:check_space()
  return self.inventory_size_full - self.inventory_cnt
end

function player:check_amount(what)
  return self.inventory[what] or 0
end

function player:draw_inv()
    inv_txt = ""
    for item, num in pairs(self.inventory) do
        if num ~= 0 then
            inv_txt = inv_txt .. num .. " x " .. item .."\n"
        end
    end


    gr.print("money: " .. math.floor(self.money), cell(18), row(2.3))

  gr.print("INVENTORY   ("..self.inventory_cnt.."/"..self.inventory_size_full..")", cell(18), row(3.3))
  gr.print(inv_txt, cell(18), row(4.5))
end

function player:draw()
  gr.rectangle("fill",self.pos.x,self.pos.y,self.width,self.height)
  gr.rectangle("fill", self.pos.x+self.width/4  , self.pos.y-self.height/2, self.width/2, self.height/2)
  self:draw_inv()

end

return player
