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

local path = ...

local drawCenteredText = require("lib/DrawCenteredText")
local LabyMaker = require(path.."/LabyMaker")

local lightingShader = love.graphics.newShader(
    g3d.shaderpath, "assets/shaders/lighting.frag"
)

local PlayState = {}
PlayState.__index = PlayState

function PlayState:new()
    local self = setmetatable({}, PlayState)

    self.Player = require(path.."/Player"):new()
    self.Hud = require(path.."/Hud"):new()

    return self
end

function PlayState:setValues()

    love.graphics.setBackgroundColor(0, 0, 0)
    love.mouse.setRelativeMode(true)

    self.level = (self.level or 0) + 1
    self.timer = (self.timer or 4) + 2

    self.tileSize  = math.floor(WIN_W/30) - self.level

    self.mapWidth  = 5 + math.floor(self.level * 2)
    self.mapHeight = 15 + math.floor(self.level * 2)

    self.map = LabyMaker:genMap(self.mapWidth,self.mapHeight)
    self.walk, self.stair = {0, 1, 1}, {0, 0, 1}

    self.endGame = false

    self.Player:setValues(
        self.tileSize,
        self.map,
        self.walk,
        self.stair
    )

    if save.dimension == "3D" then

        g3d.camera.position = {0,
            LabyMaker.centerModel.x,
            LabyMaker.centerModel.y
        }

        g3d.camera.lookInDirection()

    end

end

function PlayState:update(dt)

    if not self.endGame then

        if self.timer < .8 then
            self.endGame = "GAME OVER"
        else

            self.timer = self.timer - dt

            self.Player:update(dt)
    
            if self.Player.endLevel then
                love.system.vibrate(0.05)
                self:setValues()
            end

        end

    end

    g3d.camera.firstPersonMovement(dt) -- DEBUG 3D POSITION

end

function PlayState:mousePressed(x,y)
    -- Empty but required for now
end

function PlayState:mouseMoved(x,y,dx,dy)

    if not self.endGame and save.commands == "TOUCH" then
        self.Player:mouseMoved(dx,dy)
    end

    --g3d.camera.firstPersonLook(dx,dy) -- DEBUG 3D VIEW

end

function PlayState:mouseReleased(x,y)

    if not self.endGame then
        self.Hud:mouseReleased(x,y)
    else

        if self.level > 1 then

            if self.level > save.hiscore then
                save.hiscore = self.level
            end

            local addCoins = self.level * 1.75

            if self.level > 10 then
                addCoins = addCoins * 1.5
            end

            save.coins = math.floor(save.coins + addCoins)
            saveMan.save("save.dat")

            self.level = nil
            self.timer = nil

        end

        setGameState("title")

    end
end

function PlayState:draw()

    if not self.endGame then

        if save.dimension == "3D" then

            g3d.camera.updateViewMatrix(lightingShader)
            g3d.camera.updateProjectionMatrix(lightingShader)

            love.graphics.setMeshCullMode("front")
            LabyMaker:draw(self.map, self.tileSize) -- param3 : lightingShader (TODO)

            love.graphics.setMeshCullMode("back")
            self.Player:draw(lightingShader)

        else

            love.graphics.push()

                love.graphics.translate( -- Center the maze in the middle of the screen
                    (WIN_W - (self.tileSize*self.mapWidth)) * .5 - self.tileSize,
                    (WIN_H - (self.tileSize*self.mapHeight)) * .5 - (self.tileSize + self.Hud.level.h * .5)
                )

                LabyMaker:draw(self.map, self.tileSize)

                self.Player:draw()

            love.graphics.pop()

        end

        self.Hud:draw(
            self.level,
            self.timer
        )

    else

        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill",0,0,WIN_W,WIN_H)
        love.graphics.setColor(1, 1, 1)

        drawCenteredText(self.endGame, WIN_W*.5, WIN_H*.5, 0, 0)

--[[
        if self.level > 10 then
            love.graphics.setColor(0, .75, 0)
            drawCenteredText("You're really fast !", WIN_W*.5, WIN_H*.725, 0, 0)
            drawCenteredText("Then we offer you a bonus ^^", WIN_W*.5, WIN_H*.775, 0, 0)
            love.graphics.setColor(1, 1, 1)
        end
]]

    end

end

return PlayState
