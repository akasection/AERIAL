solo = {}

solo.layout = {}
solo.layout[1] = {0,0}
solo.layout[2] = {0,0}
solo.layout[3] = {0,0}
solo.layout[4] = {0,602} --the bar
solo.layout[5] = {0,634} --the text
solo.layout[6] = {1295, 697} --close button
solo.layout[7] = {25, 0} -- left bar
solo.layout[8] = {355, 25} -- right bar

solo.tooltip = {}
solo.tooltip[1] = "NOTEXT"
solo.tt = 1
solo.isClosePressed = false
solo.isDisabled = false
solo.normal_alpha = 255
solo.retVal = 5
solo.leftAnim = 0 --//control height animation from 0 to 625
solo.rightAnim = 1366 --//control width animation from 1366 to 355
solo.leftAcc = 2
solo.rightAcc = 2
isOut = false
solo.animTrans = 0
function solo:load()
  solo.retVal = 5
  solo.normal_alpha = 255
  solo.leftAnim = 0 --//control height animation from 0 to 625
  solo.rightAnim = 1366 --//control width animation from 1366 to 355
  solo.leftAcc = 2
  solo.rightAcc = 2
  isOut = false
  solo.animTrans = 0
end

function solo:draw()
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
	
  for i,v in ipairs(solo.layout) do
    local cols = 255
    if i == 5 and (leftAction or rightAction) then
        
    elseif i == 3 or i == 2 or i == 1 or i == 5 then 
    -- Replacing Big square layer /images/bg_big.png)
    elseif i == 7 then --left bar
      love.graphics.setColor(102,153,153,(80/100*255)*(solo.animTrans/255)) 
      love.graphics.rectangle("fill", solo.layout[i][1], solo.layout[i][2], 300, solo.leftAnim) 
      love.graphics.setColor(255,255,255,solo.normal_alpha)
    elseif i == 8 then -- right bar
      love.graphics.setColor(102,153,153,(60/100*255)*(solo.animTrans/255)) 
      love.graphics.rectangle("fill", solo.rightAnim, solo.layout[i][2], 1366-solo.layout[i][1], 575) 
      love.graphics.setColor(255,255,255,normal_alpha)
    else 
      love.graphics.setBackgroundColor(n_c,n_c,n_c)
      love.graphics.setColor(255,255,255,solo.normal_alpha)
      love.graphics.draw(components[i], layout[i][1],layout[i][2])
    end
  end
	local clr = fontc
	love.graphics.setColor(clr-20,clr,clr,normal_alpha)
	love.graphics.print(solo.tooltip[solo.tt], 19, 743)
	love.graphics.print(love.timer.getFPS().."fps|solo|delta " ..delta .. "|transp ".. delta_transp,10,10)
	love.graphics.print(dd, 10, 25)
  love.graphics.setColor(255,255,255)
end

function solo:update(dt)
  if isOut == false then
    solo.animTrans = solo.animTrans + (480*dt)  
    --locking transparency
    if solo.animTrans > 255 then solo.animTrans = 255 end  
    
    if solo.leftAnim < 625 then --left animation proc
      solo.leftAcc = solo.leftAcc - (3 * dt)
      if solo.leftAcc < 0 then solo.leftAcc = 625/3000 end
      solo.leftAnim = solo.leftAnim + ( 625*solo.leftAcc  * dt * 1.5)
    end
      
    if solo.rightAnim > 355 then --right animation proc
      solo.rightAcc = solo.rightAcc - (3 * dt)
      if solo.rightAcc < 0 then solo.rightAcc = (1366-355)/3000 end 
      solo.rightAnim = solo.rightAnim - (1366-355)*solo.rightAcc * dt * 1.5
    end
  else -- isOUT == TRUE
    solo.animTrans = solo.animTrans - (480*dt)  
    --locking transparency
    if solo.animTrans < 0 then solo.animTrans = 0 end
    if solo.leftAnim > 0 then --left animation proc
      solo.leftAcc = solo.leftAcc - (3 * dt)
      if solo.leftAcc < 0 then solo.leftAcc = 625/3000 end
      solo.leftAnim = solo.leftAnim - ( 625*solo.leftAcc  * dt * 1.5)
    else
      solo.retVal = 4
    end
    
    if solo.rightAnim < 1366 then --right animation proc
      solo.rightAcc = solo.rightAcc - (3 * dt)
      if solo.rightAcc < 0 then solo.rightAcc = (1366-355)/3000 end 
      solo.rightAnim = solo.rightAnim + (1366-355)*solo.rightAcc * dt * 1.5
    end
  end -- end of isOut
end

function solo:mousereleased(x, y, button)
   if inside(x,y, layout[6][1]+28, layout[6][2]+28, close_button:getWidth()-32,close_button:getHeight()-32) and isClosePressed == true then
    --bgm_main:setVolume(0.1)
	  --solo.isDisabled = true
	  --solo.retVal = 4
	  isOut = true
	  solo.leftAcc = 2
    solo.rightAcc = 2
    --quitFace = 0
	end
end

function solo:mousepressed(x, y, button)
  if inside(x,y, layout[6][1]+28, layout[6][2]+28, close_button:getWidth()-32,close_button:getHeight()-32) then
	  isClosePressed=true
	  sound_click:stop()
	  sound_click:play()
	 end    
end

function solo:keypressed(key, unicode)
  if key == 'escape' then
    isOut = true
    solo.leftAcc = 2
    solo.rightAcc = 2
    sound_click:stop()
    sound_click:play()
  end
end

function solo:getExit()
  return solo.retVal
end