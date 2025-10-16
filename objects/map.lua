
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

local max_hives = 5
local current_hive_upg = 0

local max_cap_upg = max_hives
local current_cap_upg = 0

local max_ext_upg = max_hives
local current_ext_upg = 0

local max_inv_upg = 3
local current_inv_upg = 0

function dummy_upg()
  print("upgraded ~")
end

-- hive upg helpers
local hive_row = 2.5
local hive_positions = {
  { 3.5, hive_row }, { 4.5, hive_row }, { 5.5, hive_row },
  { 2.5, hive_row + 2 }, { 3.5, hive_row + 2 }
}

local function hive_upg()
    if current_hive_upg < max_hives then
      local new_pos = hive_positions[current_hive_upg +1]
      g.var.map:_add_object(g.lib.objects.hive(cell(new_pos[1]), row(new_pos[2])))
      current_hive_upg = current_hive_upg + 1
      return true
    end
end

local function capper_upg()
  if current_cap_upg < max_cap_upg then
    g.var.map._capper:upgrade()
    return true
  end
end

local function ext_upg()
  if current_cap_upg < max_cap_upg then
    g.var.map._extractor:upgrade()
    return true
  end
end

local function inv_upg()
  if current_inv_upg < max_inv_upg then
    current_inv_upg = current_inv_upg + 1
    g.var.player.inventory_size_full = g.var.player.inventory_size_full + 5
    return true
  end
end

function map:__setup_upgraders()
  self:_add_object(g.lib.objects.upgrader(cell(3.5), row(10.5), 5, 1.5, hive_upg, 1, "buy hive",max_hives))
  self:_add_object(g.lib.objects.upgrader(cell(5.5), row(10.5), 5, 1.5, capper_upg, 2, "upg capper",max_cap_upg))
  self:_add_object(g.lib.objects.upgrader(cell(3.5), row(12.5), 5, 1.5, ext_upg, 3, "upg extractor",max_ext_upg))
  self:_add_object(g.lib.objects.upgrader(cell(5.5), row(12.5), 5, 1.5, inv_upg, 4, "upg inv",max_inv_upg))
end

function map:new()
    self.width = scr_w
    self.height = scr_h

    self._objects = {}
    self._grid = {}

    self:_add_object(g.lib.objects.hive(cell(2.5), row(2.5)))

    self._capper = g.lib.objects.capper(cell(5.5), row(8.5))
    self:_add_object(self._capper)

    self._extractor = g.lib.objects.extractor(cell(7.5), row(8.5))
    self:_add_object(self._extractor)

    self._register = g.lib.objects.money_register(cell(12.5),row(17.5))
    self:_add_object(self._register)
    self:_add_object(g.lib.objects.store(cell(10.5), row(17.5) ))

    self:__setup_upgraders()


    self._collision_rects ={
      rect(cell(1), row(1), cell(1) * 23, row(1)), --fence top
      rect(cell(1), row(1), cell(1), row(1) * 15), --fence left
      rect(cell(23), row(1), cell(1), row(1) * 15),--fence right

      rect(cell(1), row(9), cell(10), row(1)),        --house,tl
      rect(cell(12), row(9), cell(11), row(1)),       --house,trpl

      rect(cell(1), row(15), cell(10), row(1)),      --house,bl
      rect(cell(12), row(15), cell(11), row(1)),  --house,br
        
      rect(cell(7),row(10),cell(1),row(4)), --sep left
    rect(cell(12), row(10), cell(1), row(4)),       --sep rig

    rect(cell(17), row(2), cell(17), row(8)),       --inv start
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

  --self:draw_debug()

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
