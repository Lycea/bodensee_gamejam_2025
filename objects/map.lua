
--- @class map
local map = class_base:extend()

local rect = class_base:extend()

function rect:new(x, y, w, h)
    self.x = x
    self.y = y
    self.width = w
    self.height = h
end

function rect:draw()
  gr.rectangle("line",self.x,self.y,self.width,self.height)
end


local function cell(num)
    return g.var.cell_width * num
end

local function row(num)
  return g.var.cell_height * num
end



function map:new()
    self.width = scr_w
    self.height = scr_h

    self._objects = {}
    self._grid = {}

    self._collision_rects ={
      rect(cell(1), row(1), cell(1) * 23, row(1)),
      rect(cell(1), row(1), cell(1), row(1) * 11),
      rect(cell(23), row(1), cell(1), row(1) * 11),

      rect(cell(1), row(1) * 12, cell(1) * 12, row(1)),
      rect(cell(1) * 14, row(1) * 12, cell(1) * 10, row(1)),
    }
end

function map:draw_fence()


end

function map:draw_house()
end

function map:draw_debug()
    --grid

    g.var.colors.fg_set("white")
    gr.rectangle("line",0,0,scr_w,scr_h)
    for y = 0, scr_h / 32 do
        for x = 0, scr_w / 32 do
            gr.rectangle("line", x * g.var.cell_width, y * g.var.cell_height,
                g.var.cell_width, g.var.cell_height)
        end
    end
    -- collisions
    g.var.colors.fg_set("wall")
    for _, col in pairs(self._collision_rects) do
        col:draw()
    end
    g.var.colors.reset()

end

--- checks if objects collides on the map , use global coords
function map:check_collision(obj)
    local collides = false
    for _, collision in pairs(self._collision_rects) do
        r1 = g.helper.rect_to_2p(collision)
        r2 = g.helper.rect_to_2p(obj)
        if g.helper.rect_collision_tables(r1.p1,r1.p2,r2.p1,r2.p2) == true then
          print("collides")
            return true
        end
    end

    return false
end 

function map:draw()
  self:draw_debug()
    self:draw_fence()
    self:draw_house()

    for _, obj in pairs(self._objects) do
      obj:draw()
    end
end

function map:update()
  -- check fence bounds
  for _, obj in pairs(self._objects) do
    obj:draw()
  end
end


return map
