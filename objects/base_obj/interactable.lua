--- @class interactable
local interact = class_base:extend()


--- @function point collision 
function interact:in_distance(point)
  return g.helper.circ_point_collision(self.pos.x,self.pos.y,self.rad, point.x,point.y)
end

function interact:check_circ_area(circ)
    return g.helper.circ_collision(self.pos.x, self.pos.y, self.rad,
                                   circ.pos.x,circ.pos.y,circ.rad )
end

function interact:rect_to_circ(rect)
    return {
        pos = {
          x = rect.pos.x + rect.width / 2,
          y = rect.pos.y + rect.height / 2
        },
        rad = rect.width / 1.5
  }
end


function interact:draw_hint(txt)
  gr.print(txt, self.pos.x + self.rad, self.pos.y)
end

--- @function show_area,  debug draws the are
function interact:show_area()
  g.var.colors.fg_set("red")
  gr.circle("line", self.pos.x, self.pos.y, self.rad)
  g.var.colors.reset()
end


function interact:interact()
end

return interact
