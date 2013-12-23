graphicsmanager = {}

function graphicsmanager:init()
    local a = love.graphics
    
    -- static images
    bg_particle_big = a.newImage("images/bg_particle_big.png") -- 1
    bg_particle_small = a.newImage("images/bg_particle_small.png") -- 2
    bg_big = a.newImage("images/bg_big.png") -- 3
    bar_down = a.newImage("images/bar_down.png") -- 4
    title = a.newImage("images/title_solo.png") -- 5
    close_button_normal = a.newImage("images/close_button.png") --6
    close_button_hover = a.newImage("images/close_button_hover.png") --6
    close_button_pressed = a.newImage("images/close_button_pressed.png") --6  
    cursor_normal = a.newImage("images/cursor_normal.png") -- back
    cursor_pressed = a.newImage("images/cursor_pressed.png") -- back
    aerial_logo = a.newImage("images/aerial_logo.png") -- logo
    aerial_solid = a.newImage("images/aerial_solid.png") -- logo solid
    screen_fonts = a.newFont("fonts/sansumi.ttf")
    section_logo = a.newImage("images/section_logo.png")
    section_text = a.newImage("images/section_text.png")
    left_normal = a.newImage("images/left_normal.png")
    right_normal = a.newImage("images/right_normal.png")
    left_hover = a.newImage("images/left_hover.png")
    right_hover = a.newImage("images/right_hover.png")
    
    title_menu_img = {}
    title_menu_img[1] = a.newImage("images/title_solo.png")
    title_menu_img[2] = a.newImage("images/title_ranksquare.png")
    title_menu_img[3] = a.newImage("images/title_4jam.png")
    title_menu_img[4] = a.newImage("images/title_tiletic.png")
    
    
    -- dynamic variables
    cursor = cursor_normal
    close_button = close_button_normal
    left = left_hover
    right = right_hover
    components = { bg_particle_big, bg_particle_small, bg_big, bar_down, title, close_button } --, left, right }
end
