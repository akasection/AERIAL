presplash = {}


elapsed=0
isSkipped = 0

function presplash:load()
fadetime=0.001
fadetime2=0.001
retVal = 1 -- Return value number of this form 
end

function presplash:draw()
    local a = love.graphics
    a.setColor(0,0,0,255)
    -- a.print(elapsed .. " " .. fadetime .. " " .. fadetime2, 10,10)
    a.setColor(255,255,255,fadetime)
    a.draw(section_logo, (a.getWidth() / 2 - (section_logo:getWidth()/2) ), (a.getHeight() / 2 - (section_logo:getHeight()/2) ))
    a.setColor(255,255,255,fadetime2)
    a.draw(section_text, (a.getWidth() / 2 - (section_text:getWidth()/2) ), (a.getHeight() / 2 - (section_text:getHeight()/2) ))
    a.setColor(255,255,255,255)
end

function presplash:update(dt)
    elapsed = elapsed + dt
   if elapsed > 1 and elapsed <= 3 then
      fadetime = fadetime + ( dt * 255 / 2 )
   elseif elapsed > 3  and elapsed <= 5 then
      fadetime = 255
   elseif elapsed > 5 and elapsed <= 7 then
      fadetime = fadetime - ( dt * 255 / 2 )
   end
   
   if elapsed > 7 and elapsed <= 9 then
      if isSkipped == 0 then isSkipped = 1 end
      fadetime2 = fadetime2 + ( dt * 255 / 2 )
   elseif elapsed > 9  and elapsed <= 11 then
      fadetime2 = 255
   elseif elapsed > 11 and elapsed <= 13 then
      fadetime2 = fadetime2 - ( dt * 255 / 2 )
   elseif elapsed > 14 then
      fadetime = 0.000
      fadetime2 = 0.000
      retVal = 2 -- next form
   end
   
   if fadetime < 0 then fadetime = 0 end
   if fadetime2 < 0 then fadetime2 = 0 end
end

function presplash:keypressed(key, unicode)
    if isSkipped == 0  then
        elapsed = 7 - (fadetime / 255) * 2
        isSkipped = isSkipped + 1
    elseif isSkipped == 1 and elapsed > 7 then
        isSkipped = 2
        elapsed =  13 - (fadetime2 / 255) * 2
    end
end

function presplash:keyreleased(key, unicode)

end

function presplash:mousepressed(x,y, button)

end

function presplash:mousereleased(x,y, button)
if button == 'l' then

if isSkipped == 0  then
elapsed = 7 - (fadetime / 255) * 2
isSkipped = isSkipped + 1
elseif isSkipped == 1 and elapsed > 7 then
isSkipped = 2
elapsed =  13 - (fadetime2 / 255) * 2
end

end
end

function presplash:getExit()
    return retVal
end
