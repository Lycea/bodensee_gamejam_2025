local sample_state =class_base:extend()


function sample_state:new()

    
    print("initialised!!")
end




function sample_state:startup()
    g.var.map_img = g.lib.loader.loadTiles("assets/map.png", scr_w, scr_h)
    g.var.tiles = g.lib.loader.loadTiles("assets/tiles.png",32,32)

    g.var.map = g.lib.objects.map()
    g.var.player = g.lib.objects.player()
end





function sample_state:draw()
    g.var.colors.bg_set("green")
    g.var.colors.reset()
    g.var.map:draw()
    g.var.player:draw()
end



function sample_state:update()
    g.var.player:update()
    g.var.map:update()
    
end

function sample_state:shutdown()
    
end





return sample_state()
