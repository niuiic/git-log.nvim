local M = {}

function M.check_log(options)
	options = options or {}

	local file_name = vim.api.nvim_buf_get_name(0)
	if not file_name then
		vim.notify("buffer is not valid", vim.log.levels.WARN)
		return
	end

	local selection_area = require("omega").get_selected_area()
	local commands = { "git", "log" }
	commands = vim.list_extend(commands, options.extra_args or {})
	commands = vim.list_extend(
		commands,
		{ "-L", string.format("%s,%s:%s", selection_area.start_lnum, selection_area.end_lnum, file_name) }
	)

	vim.system(
		commands,
		{ cwd = vim.fs.root(0, ".git") },
		vim.schedule_wrap(function(result)
			if result.code ~= 0 then
				vim.notify(result.stderr, vim.log.levels.ERROR)
				return
			end
			M._display_log(
				result.stdout,
				options.window_width_ratio or 0.6,
				options.window_height_ratio or 0.8,
				options.quit_key or "q"
			)
		end)
	)
end

function M._display_log(log, width_ratio, height_ratio, quit_key)
	local lines = vim.split(log, require("omega").get_line_ending(0))

	local separate_lnums = {}
	for lnum, line in ipairs(lines) do
		if string.match(line, "^commit") then
			table.insert(separate_lnums, lnum)
		end
	end

	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_open_win(bufnr, true, M._get_window_options(width_ratio, height_ratio))
	vim.api.nvim_set_option_value("filetype", "git", { buf = bufnr })
	vim.keymap.set("n", quit_key, function()
		pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
	end, { buffer = bufnr })

	vim.api.nvim_set_option_value("modifiable", true, { buf = bufnr })
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })

	local columns = vim.opt.columns:get()
	local chars = string.rep("-", columns)
	local ns_id = vim.api.nvim_create_namespace("git-log")

	for i, lnum in ipairs(separate_lnums) do
		if i ~= 1 then
			vim.api.nvim_buf_set_extmark(bufnr, ns_id, lnum - 1, 0, {
				virt_lines = { { { chars, "CursorLineNr" } } },
				virt_lines_above = true,
			})
		end
	end
end

function M._get_window_options(width_ratio, height_ratio)
	local screen_w = vim.opt.columns:get()
	local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
	local window_w = screen_w * width_ratio
	local window_h = screen_h * height_ratio
	local window_w_int = math.floor(window_w)
	local window_h_int = math.floor(window_h)
	local center_x = (screen_w - window_w) / 2
	local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()

	return {
		relative = "editor",
		width = window_w_int,
		height = window_h_int,
		row = center_y,
		col = center_x,
		border = "rounded",
		title = "git log",
		style = "minimal",
		title_pos = "center",
	}
end

return M
