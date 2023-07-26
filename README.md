# [Tim Park](https://github.com/tpar-rss) contributed nothing to this plugin.

## Installation

### Use lazy
```lua
return {
	"ErikAasen-RSS/github-utils.nvim",
}
```

## Open github repo on browser
vim.keymap.set("n", "<leader>gw", require("github-utils").open_web_client)

## Open file on github
vim.keymap.set("n", "<leader>gf", require("github-utils").open_web_client_file)

## Create permalink to current line and copy to clipboard
vim.keymap.set("n", "<leader>gp", require("github-utils").create_permalink)
