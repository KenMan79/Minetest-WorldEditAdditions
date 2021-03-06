
--[[
Convolves over a given 2D heightmap with a given matrix.
Note that this *mutates* the given heightmap.
Note also that the dimensions of the matrix must *only* be odd.
@param	{number[]}			heightmap		The 2D heightmap to convolve over.
@param	{[number,number]}	heightmap_size	The size of the heightmap as [ height, width ]
@param	{number[]}			matrix			The matrix to convolve with.
@param	{[number, number]}	matrix_size		The size of the convolution matrix as [ height, width ]
]]--
function worldeditadditions.conv.convolve(heightmap, heightmap_size, matrix, matrix_size)
	if matrix_size[0] % 2 ~= 1 or matrix_size[1] % 2 ~= 1 then
		return false, "Error: The matrix size must contain only odd numbers (even number detected)"
	end
	
	local border_size = {}
	border_size[0] = (matrix_size[0]-1) / 2		-- height
	border_size[1] = (matrix_size[1]-1) / 2		-- width
	-- print("[convolve] matrix_size", matrix_size[0], matrix_size[1])
	-- print("[convolve] border_size", border_size[0], border_size[1])
	-- print("[convolve] heightmap_size: ", heightmap_size[0], heightmap_size[1])
	-- 
	-- print("[convolve] z: from", (heightmap_size[0]-border_size[0]) - 1, "to", border_size[0], "step", -1)
	-- print("[convolve] x: from", (heightmap_size[1]-border_size[1]) - 1, "to", border_size[1], "step", -1)
	
	-- Convolve over only the bit that allows us to use the full convolution matrix
	for z = (heightmap_size[0]-border_size[0]) - 1, border_size[0], -1 do
		for x = (heightmap_size[1]-border_size[1]) - 1, border_size[1], -1 do
			local total = 0
			
			
			local hi = (z * heightmap_size[1]) + x
			-- print("[convolve/internal] z", z, "x", x, "hi", hi)
			
			-- No continue statement in Lua :-/
			if heightmap[hi] ~= -1 then
				for mz = matrix_size[0]-1, 0, -1 do
					for mx = matrix_size[1]-1, 0, -1 do
						local mi = (mz * matrix_size[1]) + mx
						local cz = z + (mz - border_size[0])
						local cx = x + (mx - border_size[1])
						
						local i = (cz * heightmap_size[1]) + cx
						
						-- A value of -1 = nothing in this column (so we should ignore it)
						if heightmap[i] ~= -1 then
							total = total + (matrix[mi] * heightmap[i])
						end
					end
				end
				-- Rounding hack - ref https://stackoverflow.com/a/18313481/1460422
				-- heightmap[hi] = math.floor(total + 0.5)
				heightmap[hi] = math.ceil(total)
			end
		end
	end
	
	return true, heightmap
end
