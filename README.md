
This plugin aims at providing offline translations when hovering asian (japanese for now) characters.

The name is inspired by the great browser [rikaitan][rikaitan] plugin.
理解 ("rikai") [translates][jisho-rikai] to "understanding", "comprehension".



# How to install ?

Right now it's in development so it's fully declarative but soon we should get a
nix build along with a rockspec.

Dependencies:
- [sudachi_rs][sudachi-rs] as a tokenizer (ie., split words)
- [edict_database][edict-as-sqlite] as sqlite databases
<!-- - [lual for logging][lual-luarocks] -->
- [alogger][alogger-luarocks] for logging
- [official sqlite bindings][lsqlite-luarocks] for lua 'sqlite'
- [utf8][luautf8-github] to get utf8


# How to use ?

Run `:RikaiDownload` to fetch the dictionaries (just once).


There are no default keymaps so you need to set one

```
vim.keymap.set('n', '<D-j>', function()
	vim.cmd[[ RikaiLookup ]]
end, { buffer = false, desc = "Japanese lookup" })
```

You can also 


# Roadmap 

- support more tokenizers
- romaji to kana and vice-versa
- let users customize display (support https://jpdb.io/)
- create a top-level Rikai command with subcommands: "lookup", ...
- ability to focus popup
- translate visual selection
- add examples
- list radicals
- open db on command (register handle in some state)
- close it at the end of after some time ?
- add rikai translate

<!-- - jiten  -->
<!-- - wordbase  -->


<!-- Lua dependencies: -->

See wiki for more reference
using CLI   "wordbase-cli --output json lookup 出る"
import jamdict
https://jamdict.readthedocs.io/en/latest/
https://github.com/Top-Ranger/jmdict-to-sqlite3
https://github.com/ant32bit/JMDict2JSON

https://towardsdatascience.com/mecab-usage-and-add-user-dictionary-to-mecab-9ee58966fc6

# TODO 

* How to generate DB ?

Until `:RikaiDownload` works, do:
clone https://github.com/odrevet/edict_database.git (fetch)
nix shell nixpkgs#dart


rikai-wiki: https://github.com/teto/rikai.nvim/wiki
rikaitan: https://addons.mozilla.org/en-US/firefox/addon/rikaitan/
jisho-rikai: https://jisho.org/search/%E7%90%86%E8%A7%A3
sudachi-rs: https://github.com/WorksApplications/sudachi.rs
edict-as-sqlite: https://github.com/odrevet/edict_database
lual-luarocks: https://luarocks.org/modules/arthur-debert/lual
lsqlite-luarocks: https://luarocks.org/modules/javierguerragiraldez/lsqlite3
luautf8-github: https://github.com/starwing/luautf8
<!-- - [lsqlite3](https://luarocks.org/modules/javierguerragiraldez/lsqlite3) ? -->
<!-- - https://github.com/uga-rosa/utf8.nvim (last commit 2 years ago) -->
