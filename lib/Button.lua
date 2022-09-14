local drawCenteredText = require("lib/DrawCenteredText")

local Button = {}
Button.__index = Button

function Button:new(text, x, y, action, param, tButton, sound)
    self = setmetatable({}, Button)

    self.text = text

    self.x, self.y = x, y

    self.action = action
    self.param = param

    self.normal_img = tButton[1]
    self.highlight_img = tButton[2]
    self.pressed_img = tButton[3]

    self.image = self.normal_img

    if sound then
        self.sound = sound
    end

    self.w, self.h = self.image:getDimensions()

    self.isPressedOn = false

    return self
end

function Button:mousePressed(x,y)
    if  x > self.x and x < self.x + self.w
    and y > self.y and y < self.y + self.h
    then
        self.isPressedOn = true
        self:mouseMoved(x,y)
    else
        self.isPressedOut = true
    end
end

function Button:mouseMoved(x,y)
    if  x > self.x and x < self.x + self.w
    and y > self.y and y < self.y + self.h
    then if self.isPressedOn
        and self.image ~= self.pressed_img then
            self.image = self.pressed_img
        elseif not self.isPressedOn
        and not self.isPressedOut
        and self.image ~= self.highlight_img then
                self.image  = self.highlight_img end
    elseif self.image ~= self.normal_img then
        self.image = self.normal_img
    end
end

function Button:mouseReleased(x,y)
    if self.isPressedOn
    and x > self.x and x < self.x + self.w
    and y > self.y and y < self.y + self.h
    then

        self.image = self.normal_img
        self.isPressedOn = false
        self.action(self.param)

        if  self.sound and save.sound then
            self.sound:play()
        end

    else
        self.isPressedOut = false
        self.isPressedOn = false
    end
end

function Button:draw()
    love.graphics.draw(self.image, self.x, self.y)
    drawCenteredText(self.text, self.x, self.y, self.w, self.h)
end

return Button

