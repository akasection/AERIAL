splash = {}

splash.elapsed=0
splash.isSkipped = false

function splash:load()
splash.fadetime=0.001
splash.fadetime2=0.001
splash.retVal = 2
bgm_main:play()
end

function splash:draw()
    local a = love.graphics
    a.setColor(47,47,47,255)
    a.print(splash.elapsed .. " " .. splash.fadetime .. " " .. splash.fadetime2, 10,10)
    a.setColor(255,255,255,splash.fadetime)
    a.draw(aerial_solid, (a.getWidth() / 2 - (aerial_solid:getWidth()/2) ), (a.getHeight() / 2 - (aerial_solid:getHeight()/2) - 100 ))
    a.setColor(47,47,47,splash.fadetime2)
    local txt = "P r e s s   a n y   k e y   t o   s t a r t"
    a.print(txt, a.getWidth()/2 - 100, a.getHeight()/2 - 10)
    --a.setFont(screen_fonts, 14)
    --a.draw(section_text, (a.getWidth() / 2 - (section_text:getWidth()/2) ), (a.getHeight() / 2 - (section_text:getHeight()/2) ))
    a.setColor(255,255,255,255)
end

function splash:update(dt)
   splash.elapsed = splash.elapsed + dt
   if splash.elapsed > 1 and splash.elapsed <= 2 then
      splash.fadetime = absolute(splash.fadetime + ( dt * 255 ) )
   elseif splash.elapsed > 2 and splash.elapsed <= 3 then
      splash.fadetime = 255
      splash.fadetime2 = splash.fadetime2 + ( dt * 255 )
   elseif splash.elapsed > 3 then
        if splash.isSkipped then
            splash.fadetime = splash.fadetime - ( dt * 255 )
            splash.fadetime2 = splash.fadetime2 - ( dt * 255 )
        else
            splash.fadetime = 255
            splash.fadetime2 = 255
        end
   end
   
   if splash.fadetime < 0 then splash.fadetime = 0 splash.retVal = 4 end
   if splash.fadetime2 < 0 then splash.fadetime2 = 0 splash.retVal = 4 end
end

function splash:keypressed(key, unicode)
    if splash.isSkipped == false and splash.elapsed > 3 then
        splash.isSkipped = true
        sound_click:play()
    end
end

function splash:keyreleased(key, unicode)

end

function splash:mousepressed(x,y, button)
    if splash.isSkipped == false and splash.elapsed > 3 then
        splash.isSkipped = true
        sound_click:play()
    end
end

function splash:mousereleased(x,y, button)

end

function splash:getExit()
    return splash.retVal
end
