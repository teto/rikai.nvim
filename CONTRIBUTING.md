==========================
Contributing to rikai.nvim
======================

Getting started
---------------

To get a shell with development dependencies


```nix
$ nix develop
```


You can get a REPL with lua dependencies via:
`lx lua`

To setup the env for other tools, one can do

```
echo "export LUA_PATH='$(lx path lua)'" > .lua.env
source .lua.env
```

# regenerate the dictionaries we are relying on:

- git clone https://github.com/odrevet/edict_database.git (fetch)
- nix shell nixpkgs#dart


Reporting problems
------------------


- [Search existing issues][github-issues] (including closed!)
- Update Neovim to the latest version to see if your problem persists.
- Try to reproduce with `nvim --clean` ("factory defaults").
- If a specific configuration or plugin is necessary to recreate the problem, use the minimal template in `contrib/minimal.lua` with `nvim --clean -u contrib/minimal.lua` after making the necessary changes.

[github-issues]: https://github.com/teto/rikai.nvim/issues
