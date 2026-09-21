local git_ref = '$git_ref'
local modrev = '0.0.2'
local specrev = '1'

local repo_url = 'https://github.com/teto/rikai.nvim'

rockspec_format = '3.0'
package = 'rikai.nvim'

-- in the luarocks-tag-release action, we set $summary to "USED_AS_TEMPLATE"
-- to know if the rockspec is running in actual release mode
local release_mode = '$summary' == "USED_AS_TEMPLATE"

version = modrev ..'-'.. specrev

dependencies = { 'lua == 5.1', 'sqlite', 'utf8', 'mega.cmdparse' } 

test_dependencies = { }

if release_mode then
  source = {
    url = repo_url .. '/archive/' .. git_ref .. '.zip',
    dir = 'avante.nvim-' .. git_ref,
  }
else
  source = {
    url = repo_url:gsub('https', 'git')
  }
end

build = {
  type = 'builtin',
  copy_directories = { 'plugin' } ,
}

description = {
  summary = 'rikaitan for neovim, i.e., japanese translation integrated ',
  detailed = [[
rikai.nvim]],
  labels = { 'neovim' } ,
  homepage = 'https://github.com/teto/rikai.nvim',
  license = 'GPL-3.0'
}
