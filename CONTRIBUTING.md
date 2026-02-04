
$ nix develop

`

```
echo "export LUA_PATH='$(lx path lua)'" > .lua.env
source .lua.env
```

# regenerate those dictionaries

- clone https://github.com/odrevet/edict_database.git (fetch)
- nix shell nixpkgs#dart


