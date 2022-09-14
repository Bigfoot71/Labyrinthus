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

local drawCenteredText = require("lib/DrawCenteredText")

local Hud = {}
Hud.__index = Hud

function Hud:new()
    local self = setmetatable({}, Hud)

    local bg_w, bg_h = WIN_W, WIN_W/5
    local bg_x, bg_y = 0, WIN_H-bg_h

    self.level = {}
    self.level.w, self.level.h = bg_w/3, bg_h
    self.level.x, self.level.y = 0, bg_y

    self.timer = {}
    self.timer.w, self.timer.h = bg_w/3, bg_h
    self.timer.x, self.timer.y = self.level.w, bg_y

    self.commands = {}
    self.commands.w, self.commands.h = self.timer.w, self.timer.h
    self.commands.x, self.commands.y = self.level.w*2, self.timer.y

    return self
end

function Hud:mouseReleased(x,y)

    -- Click switch touch/gyro --

    if  x > self.commands.x and x < self.commands.x + self.commands.w
    and y > self.commands.y and y < self.commands.y + self.commands.h
    then
        if save.commands == "TOUCH" then save.commands = "GYRO"
        else save.commands = "TOUCH" end
    end

end

function Hud:draw(level, timer)

    -- DRAW RECTS SECTIONS --

    love.graphics.setColor(.15, .15, .15)
    love.graphics.rectangle("fill", self.level.x, self.level.y, self.level.w, self.level.h)

    love.graphics.setColor(.175, .175, .175)
    love.graphics.rectangle("fill", self.timer.x, self.timer.y, self.timer.w, self.timer.h)

    love.graphics.setColor(.2, .2, .2)
    love.graphics.rectangle("fill", self.commands.x, self.commands.y, self.commands.w, self.commands.h)

    -- DRAW LEVEL/TIMER/COMMANDS --

    love.graphics.setColor(1, 1, 1)
    drawCenteredText("LEVEL: "..level, self.level.x, self.level.y, self.level.w, self.level.h)
    drawCenteredText("TIMER: "..math.floor(timer), self.timer.x, self.timer.y, self.timer.w, self.timer.h)
    drawCenteredText(save.commands, self.commands.x, self.commands.y, self.commands.w, self.timer.h)

end

return Hud