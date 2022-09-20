--[[

    Title: Labyrinthus
    Author: Bigfoot71
    Soft version: 0.1a

    Date: 09/19/2022
    File version: 02

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

local sineShader = love.graphics.newShader[[

    uniform vec2 imgSize;
    uniform float phase;

    vec4 effect(vec4 colour, Image texture, vec2 texturePos, vec2 screenPos)
    {
        vec2 samplePos;
        samplePos.x = texturePos.x * ((imgSize.x + 20.0) / imgSize.x);

        float sinScale = 10.0 / imgSize.x;
        samplePos.x -= sinScale * (1.0 + sin(phase + 0.05*imgSize.y*texturePos.y));

        samplePos.y = texturePos.y;

        return Texel(texture, samplePos) * colour;
    }

]]

local TitleAnim = {}
TitleAnim.__index = TitleAnim

function TitleAnim:new()
    local self = setmetatable({}, TitleAnim)

    self.image = love.graphics.newImage("assets/textures/title.png")
    self.image:setWrap("clampzero", "clampzero")

    self.w, self.h = self.image:getDimensions()
    sineShader:send("imgSize", {self.w, self.h})

    self.x = (WIN_W-self.w) / 2
    self.y = (WIN_H-self.h) / 5

    return self
end

function TitleAnim:setValues()
    self.phase = 0
end

function TitleAnim:update(dt)
    self.phase = self.phase + 5 * dt
end

function TitleAnim:draw()

    love.graphics.setShader(sineShader)
    sineShader:send("phase", self.phase)

        love.graphics.draw(self.image,
            self.x - 10, self.y, 0,
            (self.w + 20)/self.w, 1
        )

    love.graphics.setShader()

end

return TitleAnim
