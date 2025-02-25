local static = require("git-log.static")
local core = require("core")
local utils = require("git-log.utils")

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
end

local check_log = function()
	local bufnr = vim.api.nvim_create_buf(false, true)
	local win_size_opts = core.win.proportional_size(static.config.win.width_ratio, static.config.win.height_ratio)

	-- check log
	local file_name = vim.api.nvim_buf_get_name(0)
	local line_range = utils.range()
	local args = { "git", "log" }
	args = vim.list_extend(args, static.config.extra_args)
	args = vim.list_extend(args, { "-L", string.format("%s,%s:%s", line_range[1], line_range[2], file_name) })
	local result = vim.system(args, { cwd = vim.fs.root(0, ".git") }):wait()

	-- format log
	local log = core.lua.string.split(result.stdout, "\n")
	local new_log = {}
	local first_commit = true
	for i = 1, table.maxn(log), 1 do
		if string.match(log[i], "^commit") then
			if first_commit then
				first_commit = false
			else
				table.insert(new_log, utils.separator(win_size_opts.width))
			end
		end
		table.insert(new_log, log[i])
	end
	log = new_log

	-- open float window
	core.win.open_float(bufnr, {
		enter = true,
		relative = "editor",
		width = win_size_opts.width,
		height = win_size_opts.height,
		row = win_size_opts.row,
		col = win_size_opts.col,
		border = static.config.win.border,
		title = "git log",
		style = "minimal",
		title_pos = "center",
	})

	-- set buffer
	vim.api.nvim_set_option_value("modifiable", true, {
		buf = bufnr,
	})
	vim.api.nvim_set_option_value("filetype", "git", {
		buf = bufnr,
	})
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, log)
	vim.api.nvim_set_option_value("modifiable", false, {
		buf = bufnr,
	})

	-- set keymap
	vim.keymap.set("n", static.config.keymap.close, function()
		pcall(vim.api.nvim_buf_delete, bufnr, {
			force = true,
		})
	end, {
		buffer = bufnr,
	})
end

return {
	setup = setup,
	check_log = check_log,
}
