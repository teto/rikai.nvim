rockspec_format = "3.0"
package = "rikai.nvim"
version = "0.1.0-1"

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
	"sqlite==v1.0.0",
	"utf8==1.3",
	"mega.cmdparse==1.0.4",
	"alogger==0.6.0",
}

source = {
	url = "https://github.com/teto/rikai.nvim/archive/refs/tags/ff532be327e1cdd347f7e92174e9975df24db25b.zip",
}

build = {
	type = "builtin",
}
