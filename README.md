# git-log.nvim

Check git log of the selected code.

## Usage

Call `require("git-log").check_log()` in mode `n` or mode `v`.

> Remember to save the file before calling this function.

<img src="https://github.com/niuiic/assets/blob/main/git-log.nvim/usage.gif" />

## Dependencies

- [niuiic/core.nvim](https://github.com/niuiic/core.nvim)

## Config

Default configuration here.

```lua
{
	-- args of git log
	extra_args = {},
	-- window options
	win = {
		border = "rounded",
		width_ratio = 0.6,
		height_ratio = 0.8,
	},
	keymap = {
		-- keymap to close the window
		close = "q",
	},
}
```
