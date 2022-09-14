require("lib/TSerial")

local SM = {}

function SM.getDataTable(data)
    SM.data = data
end

function SM.save(save_name, data)

    if type(data) ~= "table" then
        if type(SM.data) == "table" then
            data = SM.data else return false
        end
    end

    local temp = TSerial.pack(data)

    temp = love.data.compress("string", "zlib", temp, 9)
    temp = love.data.encode("string", "base64", temp)

    love.filesystem.write(save_name, temp)

    return true

end

function SM.load(save_name)

    local data

    if love.filesystem.getInfo(save_name) then
        data = love.data.decode("string", "base64", love.filesystem.read(save_name))
        data = love.data.decompress("string", "zlib", data)
        data = TSerial.unpack(data)
    else
        return nil
    end

    if SM.data then

        for i,v in pairs(data) do
            SM.data[i] = v
        end

        return true

    end

    return data

end

return SM
