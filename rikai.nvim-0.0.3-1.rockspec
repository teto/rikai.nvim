rockspec_format = "3.0"
package = "rikai.nvim"
version = "0.0.3-1"

description = {
	summary = "Neovim plugin that helps with japanese translation",
	license = "GPL-2.0",
	maintainer = "teto",
	labels = {
		"neovim",
		"japanese",
	},
}

dependencies = {
	"lua>=5.1",
	"mega.cmdparse==1.2.1",
	"luautf8==0.2.1",
	"lsqlite3==0.9.7",
	"mega.logging==1.1.6",
}

source = {
	url = "https://github.com/teto/rikai.nvim/archive/refs/tags/2e179886d2bcbdd2e9839424c7437018228d3f95.zip",
}

build = {
	type = "builtin",
}
