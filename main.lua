import 'CoreLibs/graphics.lua'

print( "Example ~ Bouncy ball ~ RWSS" )

local gfx = playdate.graphics
playdate.display.setRefreshRate( 50 )

gfx.setBackgroundColor( gfx.kColorWhite )

minX = 0
maxX = 400
minY = 0
maxY = 240

ballX = minX
ballY = maxY / 2
ballR = 15
velX = 5
velY = 0

friction = 25

accX = (velX) / 2 

function playdate.update()
    if playdate.buttonIsPressed(playdate.kButtonA) then
        velX = 5
        velY = 0
        friction = 25
    end
    
    if playdate.buttonIsPressed(playdate.kButtonB) then
        ballX = minX
        ballY = maxY / 2
        velX = 0
        velY = 0
    end

    -- Updates

    if (ballX > 100) then
        accX = -velX / friction
        velX += accX
    end

    ballX = ballX + velX
    ballY = ballY + velY

    if ( ballX > maxX or ballX < minX ) then
        velX = -velX
    end

    if ( ballY > maxY or ballY < minY ) then
        velY = -velY
    end

    -- Drawing
    gfx.clear( gfx.kColorWhite )
    gfx.setColor( gfx.kColorBlack )
    gfx.fillCircleAtPoint( ballX, ballY, ballR )
  
end


-- User presses buttons
-- function playdate.leftButtonDown()
--     velX += 1
-- end

-- function playdate.rightButtonDown()
--     velX += 1
-- end

function playdate.upButtonDown()
    if (velX > 0) then
        friction += 2
    end
end

function playdate.downButtonDown()
    if (velX > 0) then
        friction += 2
    end
end
