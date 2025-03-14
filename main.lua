import 'CoreLibs/graphics.lua'

print( "Example ~ Bouncy ball ~ RWSS" )

local gfx = playdate.graphics
playdate.display.setRefreshRate( 50 )

gfx.setBackgroundColor( gfx.kColorWhite )

minX = 0
maxX = 400
minY = 0
maxY = 240

startingX = 20
startingV = 4
ballX = startingX
ballY = maxY / 2
ballR = 15
velX = 0
velY = 0

friction = 25

scoreX = maxX - 50
scoreY = maxY / 2

accX = (velX) / 2 

player_score = 0
add_score = 1

ring1 = 15
ring2 = 30
ring3 = 45

infoY = 20

-- Game States
-- 0 - Starting Screen
-- 1 - Play Screen

screen = 0

function playdate.update()
    if (screen == 0) then
        gfx.clear(gfx.kColorWhite)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawText("Curling", maxX/2, maxY*1/3)
        gfx.drawText("Press 'A' to launch puck", 0, maxY/2)
        gfx.drawText("Press 'B' to return to starting position", 0, maxY*2/3)
        gfx.drawText("Press 'B' to start!", 0, maxY*5/6)
        if playdate.buttonIsPressed(playdate.kButtonB) then
            screen = 1
        end
    end

    if (screen == 1) then
        if playdate.buttonIsPressed(playdate.kButtonA) then
            velX = startingV
            velY = 0
            friction = 25
        end
        
        if playdate.buttonIsPressed(playdate.kButtonB) then
            ballX = startingX
            ballY = maxY / 2
            velX = 0
            velY = 0
        end

        -- For Score keeping
        if (ballX == startingX) then
            add_score = 1
        end

        -- Updates
        -- Allow sweeping at certain point
        if (ballX > 100) then
            accX = -velX / friction
            velX += accX
        end
        if (math.abs(velX) < 0.01) then 
            velX = 0
        end
        -- ball updates
        ballX = ballX + velX
        ballY = ballY + velY
        -- bounce back
        if ( ballX > maxX or ballX < minX ) then
            velX = -velX
        end
        if ( ballY > maxY or ballY < minY ) then
            velY = -velY
        end
        

        -- Drawing
        gfx.clear(gfx.kColorWhite)
        gfx.setColor(gfx.kColorBlack)
        -- Score Circles
        gfx.drawCircleAtPoint(scoreX, scoreY, ring1)
        gfx.drawCircleAtPoint(scoreX, scoreY, ring2)
        gfx.drawCircleAtPoint(scoreX, scoreY, ring3)
        -- Curling Ball
        gfx.fillCircleAtPoint(ballX, ballY, ballR)
        gfx.drawText(string.format("Velocity: %2.2f", velX), maxX*2/3, infoY)
        gfx.drawText(string.format("Total Score: %.0f", player_score), infoY, infoY)
        -- Show Score
        -- Score calculation
        if ((velX == 0) and (not(ballX == startingX))) then
            dist = math.abs(ballX - scoreX)
            score = 0
            if (dist < ring3) then
                score = 3
            end
            if (dist < ring2) then
                score = 5
            end
            if (dist < ring1) then
                score = 10
            end
            gfx.drawText(string.format("Score: %.0f", score), maxX/2-20, maxY-(2*infoY))
            if (add_score == 1) then
                player_score += score
                add_score = 0
            end
        end
    end
end


-- User presses buttons
-- function playdate.leftButtonDown()
--     velX += 1
-- end

-- function playdate.rightButtonDown()
--     velX += 1
-- end

function playdate.upButtonDown()
    if ((velX > 0) and (ballX < maxX-100)) then
        friction += 5
    end
end

function playdate.downButtonDown()
    if ((velX > 0) and (ballX < maxX-100)) then
        friction += 5
    end
end
