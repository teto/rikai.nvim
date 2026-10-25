rockspec_format = "3.0"
package = "rikai.nvim"
version = "scm-1"

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
	"mega.logging==1.1.6",
	"luautf8==0.2.1",
	"lsqlite3==0.9.6",
	"mega.cmdparse==1.2.0",
}

source = {
    url = 'git+https://github.com/teto/rikai.nvim'
}

build = {
	type = "builtin",
}
