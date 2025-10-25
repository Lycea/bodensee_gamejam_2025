local sample_state =class_base:extend()


function sample_state:new()

    
    print("initialised!!")
end




function sample_state:startup()
    g.var.map_img = g.lib.loader.loadTiles("assets/map.png", scr_w, scr_h)
    g.var.tiles = g.lib.loader.loadTiles("assets/tiles.png",32,32)
    g.var.bee = g.lib.loader.loadTiles("assets/bee.png")
    g.var.plants = g.lib.loader.loadTiles("assets/plants.png",8,8)


    g.var.map = g.lib.objects.map()
    g.var.player = g.lib.objects.player()
    g.var.imgs = {}
    g.var.imgs.done = g.lib.loader.loadTiles("assets/done_x2.png", 32, 32)

    g.var.anims = {}
    g.var.anims.done = g.lib.anim() ---@type anima
    g.var.anims.done:set_loaded(g.var.imgs.done, "done")
    g.var.anims.done:gen_animations("done",{
                                      { "var1",1,{1,4},0.2},      
                                      { "var2",2,{1,4}, 0.2 },
    })
end





function sample_state:draw()
    g.var.colors.bg_set("green")
    g.var.colors.reset()
    g.var.map:draw()
    g.var.player:draw()
end



function sample_state:update(dt)
    g.var.player:update()
    g.var.map:update()
    for _,anim in pairs(g.var.anims) do
      anim:update(dt)
    end
    
end

function sample_state:shutdown()
    
end





return sample_state()
