local g = {}

g.lib = {}
g.var = {}

g.helper = require("helper.helpers")
g.lib.console = require("helper.console")
g.lib.timer = require("helper.timer")
g.lib.objects = require("objects.game_objects")
g.lib.loader = require("helper.load_helper")
g.lib.anim = require("helper.anima")

-- TODO: add color helper to template
g.var.colors = require("helper.colors")

local col = g.var.colors
col.add("red", { 255, 0, 0 })
col.add("green", { 0, 255, 0 })
col.add("wall", {97, 61, 33})
col.add("street", { 122, 136, 158 })
col.add("white", {255,255,255})

g.var.map = nil --- @type map
g.var.player = nil --- @type player

g.var.cell_width = 32
g.var.cell_height = 32


function g.cell(num)
  return g.var.cell_width * num
end


function g.row(num)
  return g.var.cell_height * num
end

g.var.movement = {}
g.var.movement.x = 0
g.var.movement.y = 0

return g



