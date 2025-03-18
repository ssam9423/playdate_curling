-- Ball Class

-- Imports
import 'CoreLibs/graphics.lua'
local gfx = playdate.graphics

Ball = Class{}

-- Universal Constants
minX = 0
maxX = 400
minY = 0
maxY = 240
ring1 = 15
ring2 = 30
ring3 = 45

function Ball:init(team)
    self.x_pos = 20
    self.y_pos = maxY / 2
    self.x_vel = 0
    self.y_vel = 0
    self.x_acc = self.x_vel / 2
    self.y_acc = self.y_vel / 2
    self.radius = 15
    self.friction = 25
    self.co_e = 0.9 -- Coefficient of Elasticity
    self.image = gfx.fillCircleAtPoint(self.x_pos, self.y_pos, self.radius)
    self.team = team
    self.score = 0
end

function Ball:start(x_vel, y_vel)
    self.x_vel = x_vel
    self.y_vel = y_vel
    self.x_acc = x_vel / 2
    self.y_acc = y_vel / 2
end

function Ball:collide(ball)
    if ((math.abs(self.x_pos - ball.x_pos) < 30) and 
        (math.abs(self.y_pos - ball.y_pos) < 30)) then
            -- Inelastic Collision, but Conservation of Momentum
            ball.x_vel = self.x_vel * c_e
            self.x_vel = ball.x_vel * (1 + (1 / co_e))
            ball.y_vel = self.y_vel * c_e
            self.y_vel = ball.y_vel * (1 + (1 / co_e))
    end
end

function Ball:update()
    -- Apply Friction when ball is past x=100
    if (self.x_pos > 100) then
        self.x_acc = -self.x_vel / self.friction
        self.x_vel += self.x_acc
    end
    if (self.x_pos > 100) then
        self.y_acc = -self.y_vel / self.friction
        self.y_vel += self.y_acc
    end

    -- Update Position
    self.x_pos = self.x_pos + self.x_vel
    self.y_pos = self.y_pos + self.y_vel

    -- Wall Collision
    if (self.x_pos > maxX or self.x_pos < minX) then
        self.x_vel = - (self.x_vel * co_e)
    end
    if (self.y_pos > maxY or self.y_pos < minY) then
        self.y_vel = - (self.y_vel * co_e)
    end

    -- Stop Ball 
    if (math.abs(self.x_vel) < 0.01) then 
        self.x_vel = 0
    end
    if (math.abs(self.y_vel) < 0.01) then 
        self.y_vel = 0
    end

    -- Draw Ball
    self.image = gfx.fillCircleAtPoint(self.x_pos, self.y_pos, self.radius)
end

function Ball:score(score_x, score_y)
    if ((self.x_vel == 0) and (self.y_vel == 0)) then
        x_dist = math.abs(self.x_pos - score_x)
        y_dist = math.abs(self.y_pos - score_y)
        dist = math.sqrt((x_dist * x_dist) + (y_dist * y_dist))
        if (dist < ring3) then
            self.score = 3
        end
        if (dist < ring2) then
            self.score = 5
        end
        if (dist < ring1) then
            self.score = 10
        end
    end
end

function Ball:friction()
    if ((self.x_vel > 0) and (self.y_vel > 0) and (self.x_pos < maxX-100)) then
        friction += 5
    end
end
