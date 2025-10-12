
local function cell(num)
  return g.var.cell_width * num
end

local function row(num)
  return g.var.cell_height * num
end

--- @class map
local map = class_base:extend()

--- @class rectangle
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



function map:current_cellpos()
  local cell_x = math.floor(g.mouse_coords.x / g.var.cell_width)
  local cell_y = math.floor(g.mouse_coords.y / g.var.cell_height)
  return {x=cell_x,y=cell_y}

end

function map:_add_object(obj)
  table.insert(self._objects, obj)
end

function map:new()
    self.width = scr_w
    self.height = scr_h

    self._objects = {}
    self._grid = {}

    self:_add_object(g.lib.objects.hive(cell(2.5), row(2.5)))
    self:_add_object(g.lib.objects.capper(cell(5.5), row(8.5)))
    self:_add_object(g.lib.objects.extractor(cell(7.5), row(8.5)))

    self._register = g.lib.objects.money_register(cell(12.5),row(17.5))
    self:_add_object(self._register)
    self:_add_object(g.lib.objects.store(cell(10.5), row(17.5) ))


    self._collision_rects ={
      rect(cell(1), row(1), cell(1) * 23, row(1)), --fence top
      rect(cell(1), row(1), cell(1), row(1) * 15), --fence left
      rect(cell(23), row(1), cell(1), row(1) * 15),--fence right

      rect(cell(1), row(9), cell(10), row(1)),        --house,tl
      rect(cell(12), row(9), cell(11), row(1)),       --house,trpl

      rect(cell(1), row(15), cell(10), row(1)),      --house,bl
      rect(cell(12), row(15), cell(11), row(1)),  --house,br
        
      rect(cell(7),row(10),cell(1),row(4)), --sep left
      rect(cell(12), row(10), cell(1), row(4)),   --sep rig
    }


end


function map:draw_debug()
    --grid

    -- g.var.colors.fg_set("white")
    -- gr.rectangle("line",0,0,scr_w,scr_h)
    -- for y = 0, scr_h / 32 do
    --     for x = 0, scr_w / 32 do
    --         gr.rectangle("line", x * g.var.cell_width, y * g.var.cell_height,
    --             g.var.cell_width, g.var.cell_height)
    --     end
    -- end
    -- collisions
    g.var.colors.fg_set("wall")
    for _, col in pairs(self._collision_rects) do
        col:draw()
    end

    --mouse_pos
    g.var.colors.fg_set("red")

    local pos = self:current_cellpos()
    gr.print("cell_mouse: "..pos.x..":"..pos.y)
    gr.rectangle("line",cell(pos.x),cell(pos.y)    ,g.var.cell_width,g.var.cell_height)

    g.var.colors.reset()

end

--- checks if objects collides on the map , use global coords
function map:check_collision(obj)
    local collides = false
    for _, collision in pairs(self._collision_rects) do
        r1 = g.helper.rect_to_2p(collision)
        r2 = g.helper.rect_to_2p(obj)
        if g.helper.rect_collision_tables(r1.p1,r1.p2,r2.p1,r2.p2) == true then
            return true
        end
    end

    return false
end 

function map:draw()

  gr.draw(g.var.map_img.image, 0, 0)

  for _, obj in pairs(self._objects) do
    obj:draw()
  end

  self:draw_debug()

end

function map:interact_with(obj_id)
  if obj_id ~= nil then
    self._objects[obj_id]:interact()
  end
end

function map:update()
  g.cur_selected = nil
  -- check fence bounds
  for _, obj in pairs(self._objects) do
    if obj:update() == true then
      g.cur_selected = _
    end
  end
end


return map
