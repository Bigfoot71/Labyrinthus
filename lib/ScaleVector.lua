local scaleVec = function(x, y, sv)
    x = x / sv.x
    y = y / sv.y
    return x, y
end

return scaleVec