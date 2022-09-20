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

local labyMaker =  {}

function labyMaker:genMap(mapWidth,mapHeight)

	-- Creation of maze array --

	labyMaker.map = {}

	for x = 0, mapWidth + 1 do
		labyMaker.map[x] = {}
		for y = 0, mapHeight + 1 do
			labyMaker.map[x][y] = 1
		end
	end

	-- Maze outline --

	for x = 0, mapWidth+1 do
		labyMaker.map[x][0] = 2
		labyMaker.map[x][mapHeight+1] = 2
	end

	for y = 1, mapHeight do
		labyMaker.map[0][y] = 2
		labyMaker.map[mapWidth+1][y] = 2
	end

	-- Generate maze with correct path --

	local maker = { x = 2, y = 2 }

	labyMaker.map[maker.x][maker.y] = 7

	math.randomseed(os.time())

	repeat

		local r = math.random(4)

		if labyMaker.map[maker.x+2][maker.y] == 1
		or labyMaker.map[maker.x-2][maker.y] == 1
		or labyMaker.map[maker.x][maker.y+2] == 1
		or labyMaker.map[maker.x][maker.y-2] == 1
		then

			if r == 1 then

				if labyMaker.map[maker.x+2][maker.y] == 1 then
					maker.x = maker.x+2
					labyMaker.map[maker.x][maker.y] = 0
					labyMaker.map[maker.x-1][maker.y] = 0
				end

			elseif r == 2 then

				if labyMaker.map[maker.x-2][maker.y] == 1 then
					maker.x = maker.x-2
					labyMaker.map[maker.x][maker.y] = 0
					labyMaker.map[maker.x+1][maker.y] = 0
				end

			elseif r == 3 then

				if labyMaker.map[maker.x][maker.y+2] == 1 then
					maker.y = maker.y+2
					labyMaker.map[maker.x][maker.y] = 0
					labyMaker.map[maker.x][maker.y-1] = 0
				end

			elseif r == 4 then

				if labyMaker.map[maker.x][maker.y-2] == 1 then
					maker.y = maker.y-2
					labyMaker.map[maker.x][maker.y] = 0
					labyMaker.map[maker.x][maker.y+1] = 0
				end

			end

		elseif labyMaker.map[maker.x+1][maker.y] == 0
		or     labyMaker.map[maker.x-1][maker.y] == 0
		or 	   labyMaker.map[maker.x][maker.y+1] == 0
		or     labyMaker.map[maker.x][maker.y-1] == 0
		then

			labyMaker.map[maker.x][maker.y] = 2

			if r == 1 then
				if labyMaker.map[maker.x+1][maker.y] == 0 then
					maker.x = maker.x+2
					labyMaker.map[maker.x][maker.y] = 2
					labyMaker.map[maker.x-1][maker.y] = 2
				end

			elseif r == 2 then
				if labyMaker.map[maker.x-1][maker.y] == 0 then
					maker.x = maker.x-2
					labyMaker.map[maker.x][maker.y] = 2
					labyMaker.map[maker.x+1][maker.y] = 2
				end

			elseif r == 3 then
				if labyMaker.map[maker.x][maker.y+1] == 0 then
					maker.y = maker.y+2
					labyMaker.map[maker.x][maker.y] = 2
					labyMaker.map[maker.x][maker.y-1] = 2
				end

			elseif r == 4 then
				if labyMaker.map[maker.x][maker.y-1] == 0 then
					maker.y = maker.y-2
					labyMaker.map[maker.x][maker.y] = 2
					labyMaker.map[maker.x][maker.y+1] = 2
				end

			end
		end

	until labyMaker.map[2][2] == 2

	labyMaker.map[mapWidth-1][mapHeight-1] = 3

	-- Generation of floor and wall meshes --

	if save.dimension == "3D" then

		local wallsVertices, floorVertices = {}, {}

		local wall_size = .5

		for x, rows in pairs(labyMaker.map) do
			for y, value in pairs(rows) do

				if value == 1 then

					table.insert(wallsVertices, {-wall_size, wall_size + x, wall_size + y})
					table.insert(wallsVertices, {-wall_size, -wall_size + x, wall_size + y})
					table.insert(wallsVertices, {wall_size, wall_size + x, wall_size + y})
					table.insert(wallsVertices, {wall_size, wall_size + x, wall_size + y})
					table.insert(wallsVertices, {-wall_size, -wall_size + x, wall_size + y})
					table.insert(wallsVertices, {wall_size, -wall_size + x, wall_size + y})
					table.insert(wallsVertices, {wall_size, wall_size + x, wall_size + y})
					table.insert(wallsVertices, {wall_size, -wall_size + x, wall_size + y})
					table.insert(wallsVertices, {wall_size, wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {wall_size, wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {wall_size, -wall_size + x, wall_size + y})
					table.insert(wallsVertices, {wall_size, -wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {wall_size, wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {wall_size, -wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {-wall_size, wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {-wall_size, wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {wall_size, -wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {-wall_size, -wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {-wall_size, wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {-wall_size, -wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {-wall_size, wall_size + x, wall_size + y})
					table.insert(wallsVertices, {-wall_size, wall_size + x, wall_size + y})
					table.insert(wallsVertices, {-wall_size, -wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {-wall_size, -wall_size + x, wall_size + y})
					table.insert(wallsVertices, {-wall_size, wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {-wall_size, wall_size + x, wall_size + y})
					table.insert(wallsVertices, {wall_size, wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {wall_size, wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {-wall_size, wall_size + x, wall_size + y})
					table.insert(wallsVertices, {wall_size, wall_size + x, wall_size + y})
					table.insert(wallsVertices, {-wall_size, -wall_size + x, wall_size + y})
					table.insert(wallsVertices, {-wall_size, -wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {wall_size, -wall_size + x, wall_size + y})
					table.insert(wallsVertices, {wall_size, -wall_size + x, wall_size + y})
					table.insert(wallsVertices, {-wall_size, -wall_size + x, -wall_size + y})
					table.insert(wallsVertices, {wall_size, -wall_size + x, -wall_size + y})

				elseif value == 2 then

					table.insert(floorVertices, {wall_size, wall_size + x, wall_size + y})
					table.insert(floorVertices, {wall_size, -wall_size + x, wall_size + y})
					table.insert(floorVertices, {wall_size, wall_size + x, -wall_size + y})
					table.insert(floorVertices, {wall_size, wall_size + x, -wall_size + y})
					table.insert(floorVertices, {wall_size, -wall_size + x, wall_size + y})
					table.insert(floorVertices, {wall_size, -wall_size + x, -wall_size + y})

				end

			end
		end

		labyMaker.wallsModel = g3d.newModel(wallsVertices, "assets/textures/wall.jpg", {25,0,0}, {math.pi, 0, 0}, 1)
		labyMaker.floorModel = g3d.newModel(floorVertices, "assets/textures/floor.jpg", {25,0,0}, {math.pi, 0, 0}, 1)

		labyMaker.centerModel = { -- center according to a 2d plant
			x = labyMaker.floorModel.translation[2] - (wall_size * mapWidth),
			y = labyMaker.floorModel.translation[3] - (wall_size * mapHeight)
		}

	end

	return labyMaker.map
end

function labyMaker:draw(map, tileSize, sahder)

	if save.dimension == "3D" then

		labyMaker.wallsModel:draw(sahder)
		labyMaker.floorModel:draw(sahder)
	
	else

		for x, rows in pairs(map) do
			for y, value in pairs(rows) do

				if value == 1 then
					love.graphics.setColor(.8, 0, 0)
					love.graphics.rectangle('fill', x*tileSize, y*tileSize, tileSize, tileSize)
				elseif value == 2 then
					love.graphics.setColor(.4, 0, 0)
					love.graphics.rectangle('fill', x*tileSize, y*tileSize, tileSize, tileSize)
				end

			end
		end

	end

end

return labyMaker
