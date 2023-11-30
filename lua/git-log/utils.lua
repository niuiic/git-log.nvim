local separator = function(length)
	local result = ""
	for _ = 1, length, 1 do
		result = result .. "-"
	end
	return result
end

local range = function()
	if vim.fn.mode() == "n" then
		local pos = vim.api.nvim_win_get_cursor(0)
		return {
			pos[1],
			pos[1],
		}
	end

	return {
		vim.fn.getpos("v")[2],
		vim.fn.getpos(".")[2],
	}
end

return {
	separator = separator,
	range = range,
}
