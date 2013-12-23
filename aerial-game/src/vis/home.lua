home = {}

-- require ("src/com/graphicsmanager")
-- require ("src/com/soundcontrol") 

close_button=nil
isClosePressed = false
isAnimated = true
outTrans = 255
normal_alpha = 0

layout = {}
layout[1] = {0,0}
layout[2] = {0,0}
layout[3] = {0,0}
layout[4] = {0,602}
layout[5] = {0,634}
layout[6] = {1295, 697}
--layout[7] = {0,634}
--layout[8] = {850,634}

title_menu = {"title_solo.png", "title_ranksquare.png", "title_4jam.png", "title_tiletic.png" }
title_set = 1

tooltip = {}
tooltip[1] = "Play the game in offline state, just yourself." 
tooltip[2] = "Gets your game ranked in online ranking. Beats people and be number one!" 
tooltip[3] = "Jamming with up to 4 players in an epic jam game. Shows them who's the pro!" 
tooltip[4] = "Clear your favorite songs in certain unique conditions."

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

--function list

isDisabled = false
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



--endfunction

function home:load()
    --print('home:load')
    isDisabled = true
    isAnimated = true
    deltacount = 255
	normal_alpha = 0
	isOut = false
	home.retVal = 4
	initRect(40)
end

function home:draw()
  
  for i,v in ipairs(layout) do
  local cols = 255
  if i == 5 and (leftAction or rightAction) then
		if (leftAction)  then
			love.graphics.setColor(cols,cols,cols,delta_transp)
			love.graphics.draw(title_buffer,layout[i][1]-deltacount,layout[i][2])
      
			love.graphics.setColor(cols,cols,cols,cols-delta_transp)	
			love.graphics.draw(title_left,layout[i][1]+delta_range-deltacount,layout[i][2])
			love.graphics.setColor(c_c,c_c,c_c,normal_alpha)
		end
		
    if (rightAction) then
			love.graphics.setColor(cols,cols,cols,delta_transp)
			love.graphics.draw(title_buffer,layout[i][1]+deltacount,layout[i][2])
				
      love.graphics.setColor(cols,cols,cols,255-delta_transp)	
			love.graphics.draw(title_left,layout[i][1]-delta_range+deltacount,layout[i][2])
			love.graphics.setColor(c_c,c_c,c_c,normal_alpha)
		end
		elseif i == 3 or i == 2 or i == 1 then 
    -- Since 3 2 1 is empty, we null-ed them.
		else
		-- Drawing other content 4 and 6
		if i == 4 or i == 6 and isOut then
		  love.graphics.setColor(255,255,255,255)
    else
      love.graphics.setColor(255,255,255,normal_alpha)
		end
		-- Drawing other contents, sort by i
        love.graphics.draw(components[i], layout[i][1],layout[i][2])
		end
	end
  -- Printing Debug Text
	local clr = fontc
	love.graphics.setColor(clr-20,clr,clr,normal_alpha)
	love.graphics.print(tooltip[title_set], 19, 743)
	love.graphics.print(love.timer.getFPS().."fps|home|delta " ..delta .. "|transp ".. normal_alpha,10,10)
	love.graphics.print(dd, 10, 25)
  love.graphics.setColor(255,255,255)
	
	--last position
	--logo
  love.graphics.setColor(255,255,255,normal_alpha)
  love.graphics.draw(aerial_logo, 972, 0)
	love.graphics.setColor(255,255,255,normal_alpha)
end

function home:update(dt)
  -- Close Button Management
  if inside(love.mouse.getX(),love.mouse.getY(), layout[6][1]+28, layout[6][2]+28, close_button:getWidth()-32,close_button:getHeight()-32) then
		if isClosePressed then
	    close_button  = close_button_pressed -- 6
		else
	    close_button = close_button_hover --6
		end
	else
		close_button  = close_button_normal -- 6
	end
	components[6] = close_button
  
  normal_alpha = absolute(normal_alpha + (dt * 600) )
  if normal_alpha > 250 and isAnimated then isDisabled = false isAnimated = false end
        
  -- Left and Right Slide Animation Menu (Solo, Ranksquare ...)
  if (leftAction or rightAction) and deltacount < delta_range then
		deltacount = deltacount + (delta_range*delta_multiplier*dt)	
		delta_transp = delta_transp - (255/(62-(dt*1000) ))-- calculating animation based on delta
		dd = dd+1
	else
	  leftAction = false
	  rightAction = false
    deltacount = 0
	  delta_transp = 255
	  delta=dt
  end
  
  -- If State is Fade Out Animation to Quit
	if isOut then
	  normal_alpha = normal_alpha - (255/(87-(dt*1000) ))
	  if normal_alpha < 0 then
	    normal_alpha = 0
	    print("isOut Proceed")
	    home.retVal = 5 -- will be changed according to title_set
	  end
	end
		
	-- See what happens when UI has been disabled dude something.
  if isDisabled then
		if isQuit then
		  quitFace = quitFace + (dt*300)
		  if quitFace > 255 then love.event.quit() end
		end
	end
end

function home:keypressed(key, unicode)
  dd = 0
  if not isDisabled then 
    -- Click Alt+F4
    if love.keyboard.isDown("lalt") and love.keyboard.isDown("f4") then 
      bgm_main:setVolume(0.1)
      isDisabled = true
      isQuit = true
      quitFace = 0
      sound_click:stop()
      sound_click:play()
    end
    
    -- Click "Left"
    if key == "left" and leftAction == false and rightAction == false then
      leftAction = true
      title_buffer = title_menu_img[title_set]
      sound_move:stop()
      sound_move:play()
      title_set = title_set - 1
      if title_set == 0 then
        title_set = 4 
      end
      title_left = title_menu_img[title_set] 
      title = title_menu_img[title_set]
      components[5] = title
    end
    
    -- Click "Right"
    if key == "right" and leftAction == false and rightAction == false then
      rightAction = true
      title_buffer = title_menu_img[title_set]
      sound_move:stop()
      sound_move:play()
      title_set = title_set + 1
      if title_set == 5 then
        title_set = 1 
      end
      title_left = title_menu_img[title_set]
      title = title_menu_img[title_set] 
      components[5] = title
    end
    
    -- Clicking "Enter"
    if (key == "return" or key == "kpenter") and leftAction == false and rightAction == false then
      if title_set == 1 then
        sound_menu:stop()
        sound_menu:play()
        -- menu is OUT!
        isDisabled = true
        isOut = true
      else
        sound_fail_menu:stop()
        sound_fail_menu:play()
      end
    end
  end
end

function home:mousereleased( x, y, button )
    if not isDisabled and button == 'l' then   
	    -- for close button
	    if inside(x,y, layout[6][1]+28, layout[6][2]+28, close_button:getWidth()-32,close_button:getHeight()-32) and isClosePressed == true then
		    bgm_main:setVolume(0.1)
		    isDisabled = true
		    isQuit = true
		    
		    quitFace = 0
	    end
	    
	    -- for menu
	    if inside(x,y, layout[4][1], layout[4][2]+25, 850, components[5]:getHeight() ) then
	        isMenuPressed = true
	        if title_set == 1 then
            -- put sound mouse release success change menu
            -- change to SOLO!
            print("CUK CUK CUK")
            isDisabled = true
            isOut = true
          else
            -- put sound mouse release fail change menu
          end
	    end  
    isClosePressed = false
    isMenuPressed = false
	end
end

function home:mousepressed(x, y, button)
	if not isDisabled and button == 'l' then 
	  if inside(x,y, layout[6][1]+28, layout[6][2]+28, close_button:getWidth()-32,close_button:getHeight()-32) then
		  isClosePressed=true
		  sound_click:stop()
		  sound_click:play()
	  end
	  
    -- menu click
	  if inside(x,y, layout[4][1], layout[4][2]+25, 850, components[5]:getHeight()+25 ) then
	    isMenuPressed = true
	    if title_set == 1 then
        sound_menu:stop()
        sound_menu:play()                
      else
        sound_fail_menu:stop()
        sound_fail_menu:play()
      end    
	  end
	end
	
  -- For "Mouse wheel Up"
	if button == "wu" and leftAction == false and rightAction == false and not isDisabled then
		rightAction = true
		title_buffer = title_menu_img[title_set]
		sound_move:stop()
		sound_move:play()
		
		title_set = title_set + 1
		if title_set == 5 then
			title_set = 1 
		end
		title_left = title_menu_img[title_set]
	  title = title_menu_img[title_set] 
	  components[5] = title
	
  -- For "Mouse Wheel Down"
  elseif button == "wd" and leftAction == false and rightAction == false and not isDisabled then
		leftAction = true
		title_buffer = title_menu_img[title_set]
		sound_move:stop()
		sound_move:play()
		title_set = title_set - 1
		if title_set == 0 then
			title_set = 4 
		end
    title_left = title_menu_img[title_set] 
	  title = title_menu_img[title_set]
	  components[5] = title
  end
end

function home:getExit()
 --return (isSkipped == 3)
   return home.retVal
end