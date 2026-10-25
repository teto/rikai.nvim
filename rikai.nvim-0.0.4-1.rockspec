rockspec_format = "3.0"
package = "rikai.nvim"
version = "0.0.4-1"

description = {
	summary = "Neovim plugin that helps with japanese translation",
	license = "GPL-2.0",
	maintainer = "teto",
	labels = {
		"neovim",
	},
}

dependencies = {
	"lua>=5.1",
	"luautf8==0.2.1",
	"mega.cmdparse==1.2.1",
	"mega.logging==1.1.6",
	"lsqlite3==0.9.7",
}

source = {
	url = "https://github.com/teto/rikai.nvim/archive/refs/tags/3adaf39a26b69f46b2a6ce83b577b7826dbca223.zip",
}

build = {
	type = "builtin",
}
