# git-log.nvim

Check git log of the selected code.

[More neovim plugins](https://github.com/niuiic/awesome-neovim-plugins)

## Usage

Just call `require("git-log").check_log()`.

Avaiable options:

```lua
require("git-log").check_log({
	extra_args = {},
	window_width_ratio = 0.6,
	window_height_ratio = 0.8,
	quit_key = "q",
})
```

> Remember to save the file before calling this function.

<img src="https://github.com/niuiic/assets/blob/main/git-log.nvim/usage.gif" />

## Dependencies

- [niuiic/omega.nvim](https://github.com/niuiic/omega.nvim)
