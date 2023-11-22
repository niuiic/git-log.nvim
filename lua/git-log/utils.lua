local core = require("core")

local separator = function(length)
	local result = ""
	for _ = 1, length, 1 do
		result = result .. "-"
	end
	return result
end

local range = function()
	if vim.fn.mode() == "v" then
		local pos = core.text.selected_area()
		return {
			pos.s_start.row,
			pos.s_end.row,
		}
	end

	local pos = vim.api.nvim_win_get_cursor(0)
	return {
		pos[1],
		pos[1],
	}
end

return {
	separator = separator,
	range = range,
}
