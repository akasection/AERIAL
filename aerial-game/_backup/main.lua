-- Template for LOVE2D Engine
-- Main.lua

-- Global variable session block
-- Named by <varname> = <value>
game_isGamePaused = false

mouse_pointX = 0
mouse_pointY = 0

screen_resWidth = 1366
screen_resHeight = 768
screen_fullScreen = true
screen_fsaa = 0
screen_vsync = false

screen_fonts = "fonts/sansumi.ttf"
-- resources test

bg_particle_big = love.graphics.newImage("images/bg_particle_big.png") -- 1
bg_particle_small = love.graphics.newImage("images/bg_particle_small.png") -- 2
bg_big = love.graphics.newImage("images/bg_big.png") -- 3
bar_down = love.graphics.newImage("images/bar_down.png") -- 4
title = love.graphics.newImage("images/title_solo.png") -- 5
close_button = love.graphics.newImage("images/close_button.png") --6
cursor = love.graphics.newImage("images/cursor_normal.png") -- back
aerial_logo = love.graphics.newImage("images/aerial_logo.png") -- logo

components = { bg_particle_big, bg_particle_small, bg_big, bar_down, title, close_button }

layout = {}
layout[1] = {0,0}
layout[2] = {0,0}
layout[3] = {0,0}
layout[4] = {0,602}
layout[5] = {0,634}
layout[6] = {1295, 698}
layout[99] = {0,0} -- autoset

title_menu = {"title_solo.png", "title_ranksquare.png", "title_4jam.png", "title_tiletic.png" }
title_set = 1



tooltip = {}
tooltip[1] = "Play the game in offline state, just yourself." 
tooltip[2] = "Gets your game ranked in online ranking. Beats people and be number one!" 
tooltip[3] = "Jamming with up to 4 players in an epic jam game. Shows them who's the pro!" 
tooltip[4] = "Clear your favorite songs in certain unique conditions."

isClosePressed = false
cursor_state = "normal"

deltacount = 255
delta_range = 200
delta_multiplier = 6
delta_transp = 255

title_buffer = Image
title_left = Image

rect_table = {}
rect_unit = {}
	
-- animation list
origin = {}
counter = 1

n_c = 255
c_c = 255
fontc = 47

blue_intensity = 192

--audiolist
bgm_main = love.audio.newSource("bgm/Waveform.ogg")
sound_click = love.audio.newSource("sound/sp.wav", "static")
sound_move = love.audio.newSource("sound/move.wav", "static")
sound_select = love.audio.newSource("sound/select.wav", "static")
--function list

isQuit = false
quitFace = 0

function inside(mx, my, x, y, w, h)
    return mx >= x and mx <= (x+w) and my >= y and my <= (y+h)
end

function iscollided(x1,y1,w1,h1,x2,y2,w2,h2)
	local horizontal = false
	local vertical = false
	horizontal =  ((x1 > x2) and (x1 < x2+w2)) or ((x1+w1 > x2) and (x1+w1 < x2 + w2))
	vertical   =  ((y1 > y2) and (y1 < y2+h2)) or ((y1+h1 > y2) and (y1+h1 < y2 + h2))
	return (horizontal and vertical)
end

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

function absolute(n)
	if n < 0 then
		return n * -1 
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


--endfunction


-- These are callbacks
-- They will be called when user interacts, or something automated.
function love.load() -- when loading (init)
    love.graphics.setMode( screen_resWidth, screen_resHeight, screen_fullScreen, screen_vsync, fsaa )
    love.graphics.setBackgroundColor(n_c,n_c,n_c)
	love.graphics.setCaption("AERIAL ver. 1.00" )
	local f = love.graphics.newFont(screen_fonts, 14)
    love.graphics.setFont(f)
    love.graphics.setColor(0,0,0,255)
	love.mouse.setVisible(false)
	bgm_main:setLooping(true)
	bgm_main:setVolume(0.64)
	bgm_main:play()
	initRect(40)
end


function love.draw() -- executed continuously
	layout[99] = {love.mouse.getX()-4, love.mouse.getY()-4}
	if inside(love.mouse.getX(),love.mouse.getY(), layout[6][1]+28, layout[6][2]+28, close_button:getWidth()-32,close_button:getHeight()-32) then
		if isClosePressed then
		close_button  = love.graphics.newImage("images/close_button_pressed.png") -- 6
		else
		close_button = love.graphics.newImage("images/close_button_hover.png") --6
		end
	else
		close_button  = love.graphics.newImage("images/close_button.png") -- 6
	end
	components[6] = close_button
	for i,v in ipairs(layout) do
		if i == 5 and (leftAction or rightAction) then
			if (leftAction)  then
				love.graphics.setColor(255,255,255,delta_transp)
				love.graphics.draw(title_buffer,layout[i][1]-deltacount,layout[i][2])
				love.graphics.setColor(255,255,255,255-delta_transp)	
				love.graphics.draw(title_left,layout[i][1]+delta_range-deltacount,layout[i][2])
				love.graphics.setColor(c_c,c_c,c_c,255)
			end
			if (rightAction) then
				love.graphics.setColor(255,255,255,delta_transp)
				love.graphics.draw(title_buffer,layout[i][1]+deltacount,layout[i][2])
				love.graphics.setColor(255,255,255,255-delta_transp)	
				love.graphics.draw(title_left,layout[i][1]-delta_range+deltacount,layout[i][2])
				love.graphics.setColor(c_c,c_c,c_c,255)
			end
		elseif i == 3 then -- Replacing Big square layer /images/bg_big.png)
		--HERE
			local chance = math.random(1,1000)
			local f = math.random(5,75) 
			local bigf = math.random(50,250)
			
			
			
			if chance < 250 then

				py = math.random(1,love.graphics.getHeight() )
				py = py + math.mod(py,50)--(py math.mod 50)
				px = math.random(1,love.graphics.getWidth() )
				px = px + math.mod(px,50)
				blowRect(px,py, f)
			end
	
			if chance > 985 then

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
	
		
		--THERE
		else 
		love.graphics.setBackgroundColor(n_c,n_c,n_c)
		love.graphics.draw(components[i], layout[i][1],layout[i][2])
		end
		
		
	end
	local clr = fontc
	love.graphics.setColor(clr-20,clr,clr,255)
	love.graphics.print(tooltip[title_set], 19, 743)
		
	love.graphics.setColor(255,255,255)
	
	--last position
	--logo
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(aerial_logo, 972, 0)
	love.graphics.setColor(255,255,255,255)
	-- cursor
    love.graphics.draw(cursor, layout[99][1],layout[99][2])
	
	if isQuit then 
		love.graphics.setColor(0,0,0, quitFace)
		love.graphics.rectangle("fill",0,0, love.graphics.getWidth(),love.graphics.getHeight())
		love.graphics.setColor(255,255,255)
	end
end

function love.update(dt) -- same as draw, but executed before buffer.
	if (leftAction or rightAction) and deltacount < delta_range then
		deltacount = deltacount + (delta_range*delta_multiplier*dt)	
		delta_transp = delta_transp - 9
		else
		leftAction = false
		rightAction = false
		deltacount = 0
		delta_transp = 255
	end
	
	local f = 0.08
	for i,v in ipairs(origin) do
		origin[i][1] = origin[i][1] - f
		origin[i][2] = origin[i][2] - f
		origin[i][3] = origin[i][3] + (dt/f*25)
		origin[i][4] = origin[i][4] + (2*f)
	end
	print("size of array: " .. table.getn(origin) .. " framerate: " .. love.timer.getFPS() .. " delta: " .. dt )
	
	if isQuit then
		quitFace = quitFace + 2
		if quitFace > 255 then love.event.quit() end
	end
end

function love.mousepressed(x, y, button)

	if not isQuit and button == 'l' then 
	cursor = love.graphics.newImage("images/cursor_pressed.png") -- back
	if inside(x,y, layout[6][1]+28, layout[6][2]+28, close_button:getWidth()-32,close_button:getHeight()-32) then
		isClosePressed=true
		sound_click:stop()
		sound_click:play()
		close_button  = love.graphics.newImage("images/close_button_pressed.png") -- 6
	end
	
	end
end

function love.mousereleased(x, y, button)
	if not isQuit and button == 'l' then 
	cursor = love.graphics.newImage("images/cursor_normal.png") -- back
	if inside(x,y, layout[6][1]+28, layout[6][2]+28, close_button:getWidth()-32,close_button:getHeight()-32) and isClosePressed == true then

		bgm_main:setVolume(0.1)
		isQuit = true
	end
	isClosePressed = false
	end
end

function love.keypressed(key, unicode)
if not isQuit then 
	if love.keyboard.isDown("lalt") and love.keyboard.isDown("f4") then 
		bgm_main:setVolume(0.1)
		isQuit = true
	end
	
	if key == "left" and leftAction == false and rightAction == false then
		leftAction = true
		title_buffer = love.graphics.newImage("images/" .. title_menu[title_set])
		sound_move:stop()
		sound_move:play()
		title_set = title_set - 1
		if title_set == 0 then
			title_set = 4 
		end
		title_left = love.graphics.newImage("images/" .. title_menu[title_set])
	title = love.graphics.newImage("images/" .. title_menu[title_set])
	components[5] = title
	end
	
	if key == "right" and leftAction == false and rightAction == false then
		rightAction = true
		title_buffer = love.graphics.newImage("images/" .. title_menu[title_set])
		sound_move:stop()
		sound_move:play()
		
		title_set = title_set + 1
		if title_set == 5 then
			title_set = 1 
		end
		title_left = love.graphics.newImage("images/" .. title_menu[title_set])
		
	title = love.graphics.newImage("images/" .. title_menu[title_set])
	components[5] = title
	end
end
end

function love.keyreleased(key, unicode)

end

function love.focus(f)

end

function love.quit()

end
