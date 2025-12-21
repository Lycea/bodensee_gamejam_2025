local sample_state =class_base:extend()

function sample_state:new()
    print("initialised!!")
end


function load_graphics()
  -- load images and atlases
  g.var.map_img = g.lib.loader.loadTiles("assets/map.png", scr_w, scr_h)
  g.var.tiles = g.lib.loader.loadTiles("assets/tiles.png", 32, 32)
  g.var.bee = g.lib.loader.loadTiles("assets/bee.png")
  g.var.plants = g.lib.loader.loadTiles("assets/plants.png", 8, 8)

  -- load animations
  g.var.anims = {}
  g.var.anims.done = g.lib.anim() ---@type anima
  g.var.anims.done:set_loaded(g.var.imgs.done, "done")
  g.var.anims.done:gen_animations("done", {
    { "var1", 1, { 1, 4 }, 0.2 },
    { "var2", 2, { 1, 4 }, 0.2 },
  })
end


function shop_ui()
  print("width,height", scr_w, scr_h)
  local upgrade_win = g.lib.ui:GetObject(g.lib.ui:add_window(10, 10, scr_w - 20, scr_h - 20)) --- @type Window
  upgrade_win:enable_titlebar(false)
  upgrade_win.options.has_background = true

  local shop_tab = upgrade_win:GetObject(upgrade_win:AddContainer(0, 50, 100, 40))
  local upgrade_tab = upgrade_win:GetObject(upgrade_win:AddContainer(0, 100, 100, 40))

  shop_tab:set_layout("vertical")
  shop_tab:AddToggleButton("shop", 0, 0, 0, 0)
  shop_tab:set_visible(false)

  upgrade_tab:set_layout("vertical")
  upgrade_tab:AddToggleButton("upgrade", 0, 0, 0, 0)
  upgrade_tab:set_visible(false)

  local main_select_menue = g.lib.tab_menue.create(0, 0, upgrade_win.width - upgrade_win.margin*2 ,30)

  main_select_menue:add_menue_entry("Shop","shop",shop_tab)
  main_select_menue:add_menue_entry("Upgrades","upgrades",upgrade_tab)
  

  upgrade_win:add_component(main_select_menue, main_select_menue._id)
    local close_btn = upgrade_win:AddButton("close", 0, upgrade_win.height - 50, upgrade_win.width - upgrade_win.margin *
    2, 30)
    upgrade_win:SetSpecialCallback(close_btn, function()
                                   g.var.uis.shop_ui_main_window:set_visible(false)
                                   end)
  g.var.uis.shop_ui_main_window = upgrade_win

end

--- @deprecated dont use , hehe
function shop_ui_old()
  print("width,height", scr_w, scr_h)
  local upgrade_win = g.lib.ui:GetObject(g.lib.ui:add_window(10, 10, scr_w - 20, scr_h - 20)) --- @type Window
  upgrade_win:enable_titlebar(false)
  upgrade_win.options.has_background = true
  first_selection = upgrade_win:GetObject(upgrade_win:AddHLayout(upgrade_win.width, 50, 0, 0)) --- @type 
  first_selection:set_size(upgrade_win.width, 50)
  first_selection:set_pos(upgrade_win.x, upgrade_win.y)

  upgrade_toggle = first_selection:AddToggleButton("Upgrades", 10, 10, 10, 10)
  first_selection:SetSpecialCallback(upgrade_toggle, function() print("to upgrade menue") end)

  shop_toggle = first_selection:AddToggleButton("Shop", 10, 10, 10, 10)

  first_selection:SetSpecialCallback(shop_toggle, function() print("to shop menue") end)

  first_selection:AddOptionGroup({upgrade_toggle,shop_toggle},"main_shop_toggle")

  local function buy_menue()

    sub_selection = upgrade_win:GetObject(upgrade_win:AddHLayout(upgrade_win.width, 50, 0, 0)) --- @type
    sub_selection:set_size(upgrade_win.width, 20)
    sub_selection:set_pos(upgrade_win.x, upgrade_win.y + 50)


    sub_selection:AddToggleButton("Plants",0,0,0,0)
    sub_selection:AddToggleButton("Machines", 0, 0, 0, 0)
    sub_selection:AddToggleButton("Misc", 0, 0, 0, 0)
  end


  local function upgrade_menue()
    sub_selection = upgrade_win:GetObject(upgrade_win:AddHLayout(upgrade_win.width, 50, 0, 0)) --- @type
    sub_selection:set_size(upgrade_win.width, 20)
    sub_selection:set_pos(upgrade_win.x, upgrade_win.y + 90)

    sub_selection:AddToggleButton("Plants", 0, 0, 0, 0)
    sub_selection:AddToggleButton("Machines", 0, 0, 0, 0)
    sub_selection:AddToggleButton("Misc", 0, 0, 0, 0)
  end

  buy_menue()
  upgrade_menue()


end

function setup_uis()
    -- upgrade ui
    shop_ui()
    g.var.uis.shop_ui_main_window:set_visible(false)
  -- inventory ui
end


function sample_state:startup()
    g.lib.ui:init()
  g.lib.ui:set_pre_11_colors()
  g.var.map = g.lib.objects.map()
  g.var.player = g.lib.objects.player()
  g.var.imgs = {}
  g.var.imgs.done = g.lib.loader.loadTiles("assets/done_x2.png", 32, 32)
  
  load_graphics()
  setup_uis()
end


function sample_state:draw()
  g.var.colors.bg_set("green")
  g.var.colors.reset()
  g.var.map:draw()
  g.var.player:draw()
  love.graphics.setColor(255,255,255,255)
  g.lib.ui:draw()
end



function sample_state:update(dt)
    g.lib.ui:update(dt)
    g.var.player:update()
    g.var.map:update()
    for _,anim in pairs(g.var.anims) do
      anim:update(dt)
    end
    
end

function sample_state:shutdown()
    
end





return sample_state()
