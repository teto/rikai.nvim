Contributing to rikai.nvim
======================

Getting started
---------------

nixos.org 

$ nix develop

`

```
echo "export LUA_PATH='$(lx path lua)'" > .lua.env
source .lua.env
```

# regenerate those dictionaries

- clone https://github.com/odrevet/edict_database.git (fetch)
- nix shell nixpkgs#dart


Reporting problems
------------------


- [Search existing issues][github-issues] (including closed!)
- Update Neovim to the latest version to see if your problem persists.
- Try to reproduce with `nvim --clean` ("factory defaults").
- If a specific configuration or plugin is necessary to recreate the problem, use the minimal template in `contrib/minimal.lua` with `nvim --clean -u contrib/minimal.lua` after making the necessary changes.

[github-issues]: https://github.com/teto/rikai.nvim/issues
