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

local TitleState = {}
TitleState.__index = TitleState

local function setDimension(s) -- Note: optimize this function

    if save.dimension == "3D" then
         save.dimension = "2D"
    else save.dimension = "3D" end

    s.ButtonDimension.text = "DIMENSION: "..save.dimension

end

function TitleState:new()
    local self = setmetatable({}, TitleState)

    self.TitleAnim = require(path.."/TitleAnim"):new()
    self.HiScore = require(path.."/HiScoreDisplay"):new()

    local btnGreen = {
        love.graphics.newImage("assets/textures/buttons/green/normal.png"),
        love.graphics.newImage("assets/textures/buttons/green/highlight.png"),
        love.graphics.newImage("assets/textures/buttons/green/pressed.png")
    }

    self.ButtonPlay = require("lib/Button"):new(
        "PLAY",
        (WIN_W-512)*.5,
        (WIN_H-128)*.75,
        setGameState, "play",
        btnGreen
    )

    local btnGrey = {
        love.graphics.newImage("assets/textures/buttons/grey/normal.png"),
        love.graphics.newImage("assets/textures/buttons/grey/highlight.png"),
        love.graphics.newImage("assets/textures/buttons/grey/pressed.png")
    }

    self.ButtonDimension = require("lib/Button"):new(
        "DIMENSION: "..save.dimension,
        (WIN_W-512)*.5,
        (WIN_H-128)*.825,
        setDimension, self,
        btnGrey
    )

    return self
end

function TitleState:setValues()
    love.graphics.setBackgroundColor(.65, .1, .1)
    love.mouse.setRelativeMode(false)
    self.TitleAnim:setValues()
    self.HiScore:setValues()
end

function TitleState:update(dt)
    self.TitleAnim:update(dt)
    self.HiScore:update(dt)
end

function TitleState:mousePressed(x,y)
    self.ButtonPlay:mousePressed(x,y)
    self.ButtonDimension:mousePressed(x,y)
end

function TitleState:mouseMoved(x,y)
    self.ButtonPlay:mouseMoved(x,y)
    self.ButtonDimension:mouseMoved(x,y)
end

function TitleState:mouseReleased(x,y)
    self.ButtonPlay:mouseReleased(x,y)
    self.ButtonDimension:mouseReleased(x,y)
end

function TitleState:draw()
    self.TitleAnim:draw()
    self.HiScore:draw()
    self.ButtonPlay:draw()
    self.ButtonDimension:draw()
end

return TitleState
