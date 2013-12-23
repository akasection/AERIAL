-- Template for LOVE2D Engine
-- Main.lua

-- requires these files
require ("src/vis/home")
require ("src/vis/presplash")
require ("src/vis/splash")
require ("src/com/graphicsmanager")
require ("src/com/soundcontrol")
require ("src/vis/solo")

-- Global variable session block
-- Named by <varname> = <value>
game_isGamePaused = false
game_isGameStarted = false

mouse_pointX = 0
mouse_pointY = 0
dd = 0

screen_resWidth = 1366
screen_resHeight = 768
screen_fullScreen = true
screen_fsaa = 0
screen_vsync = false

--colours
n_c = 255
c_c = 255
fontc = 47

-- Rect Spam
deltacount = 255
delta_range = 200
delta_multiplier = 6

-- vis Settings

visObject = 0
visData = {}
visData[1] = presplash
visData[2] = splash
--visData[3] = "login"
visData[4] = home
visData[5] = solo
--visData[6] = "ranked"
--visData[7] = "lobby"
--visData[8] = "tiletic"
--visData[9] = "fourjam"
--visData[10] = "game"
--visData[11] = "score"
--visData[100] = "music"
--visData[101] = "option"

-- Function Lists
function initRect(num)
	local stacked = true
	local inc = 1
	local co = 1
	
	for id = 1,num,1 do
		stacked = true
		rect_table[id] = {math.random(love.graphics.getWidth()),math.random(love.graphics.getHeight()),math.random(5,50) }
		co = 1
	    repeat
			if id ~= co and iscollided(rect_table[id][1],rect_table[id][2],rect_table[id][3],rect_table[id][3], rect_table[co][1],rect_table[co][2],rect_table[co][3],rect_table[co][3]) then		
				rect_table[id] = {math.random(love.graphics.getWidth()),math.random(love.graphics.getHeight()),math.random(5,50) }
			else
				co = co + 1
				if co >= id then
					stacked = false
				end
			end
	    until stacked == false	
	end
end

function spamRect(num) 
	for id = 1,num,1 do
		rect_unit[id] = love.graphics.rectangle("fill",rect_table[id][1],rect_table[id][2],rect_table[id][3],rect_table[id][3])
	end
end

function absolute(n) --absolute 255
	if n < 0 then
		return absolute(n * -1) 
	end
	if n > 255 then
		return 255
	end
	return n
end

function blowRect(x,y,size)
	
	local isReusable = false
	for i,v in ipairs(origin) do
		if origin[i][5] == 1 then
			origin[i] = {x-(size/2), y-(size/2), -255, size , 0 }
			isReusable = true
			break
		end
	end
	
	if isReusable == false then
		origin[counter] = {x-(size/2), y-(size/2), -255, size , 0 }
		counter = counter + 1
	end
end
--END

-- These are callbacks
-- They will be called when user interacts, or something automated.
function love.load() -- when loading (init)
    
    --init info
    love.graphics.setMode( screen_resWidth, screen_resHeight, screen_fullScreen, screen_vsync, fsaa )
    love.graphics.setBackgroundColor(n_c,n_c,n_c)
	love.graphics.setCaption("Aerial - Rhythm Battle Game" )
    love.graphics.setFont(love.graphics.newFont("fonts/sansumi.ttf"),14)
    love.graphics.setColor(0,0,0,255)
	love.mouse.setVisible(false)
	--load splash page
    visObject = 1
    visData[visObject]:load()
    
    graphicsmanager:init()
   	soundcontrol:init()
		
end


function love.draw() -- executed continuously
	-- pre (parameter) [background overlay]
	--HERE start the bricks
	--//love.graphics.draw(bg_particle_small,0,0)
	-- spam teh brix!
	if game_isGameStarted then 
    local chance = math.random(1,1000)
	local f = math.random(5,75) 
	local bigf = math.random(50,250)
    if chance < 75 then
		py = math.random(1,love.graphics.getHeight() )
		py = py + math.mod(py,50)
		px = math.random(1,love.graphics.getWidth() )
		px = px + math.mod(px,50)
		blowRect(px,py, f)
	end
	
    if chance > 990 then
        py = math.random(1,love.graphics.getHeight() )
	    py = py + math.mod(py,5)
	    px = math.random(1,love.graphics.getWidth() )
		px = px + math.mod(px,5)
		blowRect(px,py, bigf)
	end
			for i,v in ipairs(origin) do
				if origin[i][5] == 0 then
					love.graphics.setColor(blue_intensity,255,255,255-absolute(origin[i][3]) )
					if origin[i][3] >= 255 then
						origin[i][5] = 1
						if origin[table.getn(origin)-1][5] == 1 then counter = counter - 1 end
					end
					love.graphics.rectangle("fill",origin[i][1],origin[i][2], origin[i][4],origin[i][4])
					love.graphics.setColor(c_c,c_c,c_c,255)
				end
			end
    end
		--THERE end the bricks
	-- in (render in layer mid) DO NOT EDIT
	visData[visObject]:draw()
	-- post (override, replace any origin render visData)
	
	--cursor
	if game_isGameStarted then
    love.graphics.draw(cursor, love.mouse.getX()-4, love.mouse.getY()-4)
	end
	-- Exit State
	if isDisabled and isQuit then 
		love.graphics.setColor(0,0,0, quitFace)
		love.graphics.rectangle("fill",0,0, love.graphics.getWidth(),love.graphics.getHeight())
		love.graphics.setColor(255,255,255)
	end
end

function love.update(dt) -- same as draw, but executed before buffer.
	-- pre (parameter)
	local f = 0.08
	for i,v in ipairs(origin) do
		origin[i][1] = origin[i][1] - (f/2 + (dt*10))
		origin[i][2] = origin[i][2] - (f/2 + (dt*10))
		origin[i][3] = origin[i][3] + (dt/f*25)
		origin[i][4] = origin[i][4] + (2*f)
	end
	-- visData set!
	if visObject ~= visData[visObject]:getExit() then
	    game_isGameStarted = true
	    visObject = visData[visObject]:getExit()
	    print('objectData ' .. visObject)
	    visData[visObject]:load()
	end
	-- in 
	visData[visObject]:update(dt)
	-- post (override)
end

function love.mousepressed(x,y, button)
    -- pre (parameter)
		
	-- in 
	visData[visObject]:mousepressed(x, y, button)
	-- post (override)
	if button == 'l' then
	    cursor =  cursor_pressed-- back
	end
	
	-- close button
	
    
end

function love.mousereleased(x, y, button)
	-- in 
	visData[visObject]:mousereleased(x, y, button)
	-- post (override)
	if button == 'l' then
		cursor = cursor_normal -- back
	end
end

function love.keypressed(key, unicode)
	-- pre (parameter)
		
	-- in 
	visData[visObject]:keypressed(key, unicode)
	-- post (override)
	if key=='p' then
		love.load()
	end
	
	if key=='f12' then
		ss = love.graphics.newScreenshot()
		ss:encode('tmpimg',png)
	end
end

function love.keyreleased(key, unicode)
	-- pre (parameter)
		
	-- in 
	-- post (override)
end

function love.focus(f)

end

function love.quit()
end
