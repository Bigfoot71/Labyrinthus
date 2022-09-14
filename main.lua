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

g3d = require("lib/g3d")
saveMan = require("lib/SaveMan")
local scaleVec = require("lib/ScaleVector")

local displayInfo = {
    size  = { w = WIN_W, h = WIN_H },
    scale = { x = 1, y = 1 }
}

save = {
    dimension = "3D",
    commands = "TOUCH",
    hiscore = 0,
    coins = 0
}

local gameState,
      titleState,
      playState

function setGameState(state)

    if state == "title" then
        titleState:setValues()
        gameState = titleState

    elseif state == "play" then
        playState:setValues()
        gameState = playState

    end
end

function love.load()

    if DEBUG then
        love.window.setMode(WIN_W/3, WIN_H/3)
        love.resize()
    end

    saveMan.getDataTable(save)
    saveMan.load("save.dat")

    love.graphics.setFont(
        love.graphics.newFont("assets/fonts/main.ttf", 52)
    )

    titleState = require("states/title"):new()
    playState  = require("states/play"):new()

    setGameState("title")

end

function love.update(dt)
    gameState:update(dt)
end

function love.mousepressed(x, y, dx, dy)
    x, y = scaleVec(x, y, displayInfo.scale)
    gameState:mousePressed(x, y, dx, dy)
end

function love.mousemoved(x, y, dx, dy)
    x, y = scaleVec(x, y, displayInfo.scale)
    gameState:mouseMoved(x, y, dx, dy)
end

function love.mousereleased(x, y, dx, dy)
    x, y = scaleVec(x, y, displayInfo.scale)
    gameState:mouseReleased(x, y, dx, dy)
end

function love.draw()

    love.graphics.push()

        love.graphics.scale(
            displayInfo.scale.x,
            displayInfo.scale.y
        )

        gameState:draw()

    love.graphics.pop()

end

function love.resize()
    displayInfo.size.w, displayInfo.size.h = love.graphics.getDimensions()
    displayInfo.scale.x = displayInfo.size.w / WIN_W
    displayInfo.scale.y = displayInfo.size.h / WIN_H
end
