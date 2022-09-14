--[[

    Title: Labyrinthus
    Author: Bigfoot71
    Soft version: 0.1a

    Date: 09/14/2022
    File version: 01

    License:

        BSD 3-Clause License

        Copyright (c) 2022, Le Juez Victor
        All rights reserved.

        Redistribution and use in source and binary forms, with or without
        modification, are permitted provided that the following conditions are met:

        1. Redistributions of source code must retain the above copyright notice, this
        list of conditions and the following disclaimer.

        2. Redistributions in binary form must reproduce the above copyright notice,
        this list of conditions and the following disclaimer in the documentation
        and/or other materials provided with the distribution.

        3. Neither the name of the copyright holder nor the names of its
        contributors may be used to endorse or promote products derived from
        this software without specific prior written permission.

        THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
        AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
        IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
        DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
        FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
        DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
        SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
        CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
        OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
        OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

]]

local Player = {}
Player.__index = Player

function Player:new()
    local self = setmetatable({}, Player)

    self.model = g3d.newModel("assets/models/player.obj", "assets/textures/player.jpg", {25, 0, 0}, nil, .5)

    self.speed = 10

    return self
end

function Player:setValues(tileSize, map, walk, stair)

    self.tileSize = tileSize

    if save.dimension == "3D" then
        self.grid_x, self.grid_y = -2, -2
        self.act_x, self.act_y = -2, -2
    else
        self.grid_x, self.grid_y = 2, 2
        self.act_x = 2 * tileSize
        self.act_y = 2 * tileSize
    end

    self.map = map
    self.walk = walk
    self.stair = stair

    self.endLevel = false

end

function Player:update(dt)

    -- Verfication of gyroscopic movement if requested --

    if save.commands == "GYRO" then self:gyroMoved(dt) end

    -- Movement with slip effect and check if the end of the level has been reached --

    if save.dimension == "3D" then

        self.act_y = self.act_y - ((self.act_y - self.grid_y) * self.speed * dt)
        self.act_x = self.act_x - ((self.act_x - self.grid_x) * self.speed * dt)

        self.model:setTranslation(25, self.act_x, self.act_y)

        if self.stair[self.map[math.abs(self.grid_x)][math.abs(self.grid_y)]] == 1 then
            self.grid_x, self.grid_y = -2, -2
            self.endLevel = true
        end

    else

        self.act_y = self.act_y - ((self.act_y - (self.grid_y * self.tileSize)) * self.speed * dt)
        self.act_x = self.act_x - ((self.act_x - (self.grid_x * self.tileSize)) * self.speed * dt)

        if self.stair[self.map[self.grid_x][self.grid_y]] == 1 then
            self.grid_x, self.grid_y = 2, 2
            self.endLevel = true
        end

    end

end

function Player:draw(lightingShader)

    if save.dimension == "3D" then
        self.model:draw(lightingShader)
    else
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle(
            "fill",
            self.act_x,
            self.act_y,
            self.tileSize,
            self.tileSize
        )
    end

end

local joystick = love.joystick.getJoysticks()
joystick = joystick[#joystick]

function Player:gyroMoved()
    if joystick then

        local ax, ay = joystick:getAxes()
        local mx, my = math.abs(ax), math.abs(ay)

        if save.dimension == "3D" then

            if mx ~= 0 then mx = ax/mx -- Left/right
                if self.walk[self.map[math.abs(self.grid_x)+mx][math.abs(self.grid_y)]] == 1
                then self.grid_x = self.grid_x + mx end
            end

            if my ~= 0 then my = ay/my -- Up/down
                if self.walk[self.map[math.abs(self.grid_x)][math.abs(self.grid_y)+my]] == 1
                then self.grid_y = self.grid_y + my end
            end

        else

            if mx ~= 0 then mx = ax/mx -- Left/right
                if self.walk[self.map[self.grid_x+mx][self.grid_y]] == 1
                then self.grid_x = self.grid_x + mx end
            end

            if my ~= 0 then my = ay/my -- Up/down
                if self.walk[self.map[self.grid_x][self.grid_y+my]] == 1
                then self.grid_y = self.grid_y + my end
            end

        end

    end
end

function Player:mouseMoved(dx,dy)

    local mx, my = math.abs(dx), math.abs(dy)

    if save.dimension == "3D" then

        if mx > 2 then mx = dx/mx -- Left/right
            if self.walk[self.map[math.abs(self.grid_x)+mx][math.abs(self.grid_y)]] == 1
            then self.grid_x = self.grid_x - mx end
        end

        if my > 2 then my = dy/my -- Up/down
            if self.walk[self.map[math.abs(self.grid_x)][math.abs(self.grid_y)+my]] == 1
            then self.grid_y = self.grid_y - my end
        end

    else

        if mx > 2 then mx = dx/mx -- Left/right
            if self.walk[self.map[self.grid_x+mx][self.grid_y]] == 1
            then self.grid_x = self.grid_x + mx end
        end

        if my > 2 then my = dy/my -- Up/down
            if self.walk[self.map[self.grid_x][self.grid_y+my]] == 1
            then self.grid_y = self.grid_y + my end
        end

    end

end

return Player