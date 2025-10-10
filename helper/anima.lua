print("finding components base path ...")
local BASE = (...) .. '.'
print(BASE)
local i = BASE:find("anima.$")
print(i)
local BASE = BASE:sub(1, i - 1)
print(BASE)


--- !doctype module


--- @module "load_helper"
local loader = require(BASE.."load_helper")



local anima = class_base:extend()

--anima libera ...
--- @class anima
function anima:new()
  self.__loaded_files = {}
  self.__anims = {}
end

function anima:load_file(file_path, name, options)
  self.__loaded_files[name] = loader.loadTiles(file_path, options.w, options.h)
end

--sample structure
-- s={
--   {
--     "walk",{1},{1,5},{0.2}
--   },
--   {
--     "run",{2},{1,3},{0.1}
--   }
-- }
function anima:gen_animations(base_name, sub_info_table)
  if self.__loaded_files[base_name] == nil then
    print("Did not find quad set with name " .. base_name)
    return false
  end

  for sub_struct in pairs(sub_info_table) do
    self.__anims[sub_struct[1]] = {
      quad_y = sub_struct[2],
      frame_start = sub_struct[3][1],
      frame_end = sub_struct[3][2],
      anim_speed = sub_struct[4]
    }
  end
end

return anima
