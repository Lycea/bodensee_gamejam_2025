local sample_state =class_base:extend()


function sample_state:new()

    
    print("initialised!!")
end




function sample_state:startup()
g.var.map_img = g.lib.loader.loadTiles("assets/map.png",scr_w,scr_h)

g.var.map = g.lib.objects.map()
g.var.player = g.lib.objects.player()


end





function sample_state:draw()
    
    g.var.colors.bg_set("green")
    love.graphics.setColor(255,255,255,255)
    gr.draw(g.var.map_img.image,0,0)
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
