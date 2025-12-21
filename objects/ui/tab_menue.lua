
local UI_BASE ="helper.SimpleUI."

---@class TabMenu
local tab_menu =  require(UI_BASE.."components.base_classes.__base_component_handler"):extend()

tab_menu:implement(require(UI_BASE .. "components.base_classes.__base_component"))

tab_menu:implement(require(UI_BASE.."components.interfaces.component_creator"))
tab_menu:implement(require(UI_BASE .. "components.interfaces.layout_creator"))
tab_menu:implement(require(UI_BASE .. "components.interfaces.groups"))

function tab_menu:add_tab_window()
end

function tab_menu:add_menue_entry(name, intern_name,window_obj)

    local toggle_id = self.layout:AddToggleButton(name, 0, 0, 0, 0)

    self.menue_entries[intern_name or name] = {
        name = name,
        id = toggle_id,
        window = window_obj

    }
    self.id_to_name[toggle_id]=intern_name or name

    self.layout:GetObject(toggle_id)
    self.layout:SetSpecialCallback(toggle_id,self.cb_fn)
    self.layout:AddToOptionGroup(toggle_id,self._group_name)
end

function tab_menu:new(o)
  o = o or {}   -- create object if user does not provide one

  print("creating tab_menu")

  self.name = "tab_menu"

  self.state = "default"
    self.visible = true
  self.enabled = true
  -- initing some defaults

  self.last_active_tab = 0
  self._id = self:id()
  self:increase_id()

  self.height = 50
  self.width = 50

  self.x = 0
  self.y = 0

  self.margin = 0


  self._group_name = "tab_menue_" .. self._id

  self.menue_entries = {}
  self.id_to_name = {}

    self.cb_fn = function(id, name, checked)
        print(id, name, checked)
        --self.layout:GetObject(id).text
        print(self.layout:GetObject(id).text)

        if self.last_active_tab ~= 0 and checked == true then
            self.menue_entries[self.id_to_name[ self.last_active_tab ]].window:set_visible(false)
        end

        self.menue_entries[ self.id_to_name[id] ].window:set_visible(checked)

        self:redraw()
        if checked == true then
          self.last_active_tab = id
        end
    end
       
  

  self.layout = self.controls.layouts.horizontal() ---@type Horizontal
  self:init_from_list(o)

  self.layout:set_size(self.width, self.height)
  self.layout:set_pos(self.x,self.y)
  self.layout:AddOptionGroup({},self._group_name)
end


function tab_menu:update(clicked, x, y, focused)
  if self.visible == true and self.enabled == true then
    self.layout:update(clicked, x, y, focused)
  end
  return self:focus()
end

function tab_menu:draw()
  if self.visible == true then
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    self.layout:draw()
  end
end

function tab_menu:set_size(width, height)
  self.width = width
    self.height = height

    self.layout:set_size(width - self.margin * 2,
        height - self.margin * 2)
end

function tab_menu:set_pos(x, y)
  self.x = x
  self.y = y


  if self.layout then
    self.layout:set_pos(self.x + self.margin,
                        self.y + self.margin)
  end
end



function tab_menu.create(x, y, w, h)
  local menue = tab_menu({ width = w, height = h, x = x, y = y })

  return menue
end

return tab_menu
