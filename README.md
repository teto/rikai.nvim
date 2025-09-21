
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

Run `:Rikai download` to fetch the dictionaries (needed just once).

There are no default keymaps so you need to set one

```lua
vim.keymap.set('n', '<D-j>', function()
	vim.cmd[[ Rikai lookup ]]
end, { buffer = false, desc = "Japanese lookup" })
```

You can also call `:Rikai lookup 見`

Highlights used are:
- RikaiHighlightWordGroup
- RikaiNames


# Roadmap 

- lux packaging
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



<!-- Lua dependencies: -->

See [wiki][rikai-nvim-wiki] for more reference.

- https://towardsdatascience.com/mecab-usage-and-add-user-dictionary-to-mecab-9ee58966fc6

# How to get the various dictionaries used by rikai.nvim ?

Run `:Rikai download`, else do:

- clone https://github.com/odrevet/edict_database.git (fetch)
- nix shell nixpkgs#dart


# Related software

- [rikaitan][rikaitan]
- [tagainjisho](https://github.com/Gnurou/tagainijisho/)
- On android, I love [Kanji
  study](https://play.google.com/store/apps/details?id=com.mindtwisted.kanjistudy&pli=1)
- [ichiran][ichiran-github]

[alogger-luarocks]: https://luarocks.org/modules/swarg/alogger/
[edict-as-sqlite]: https://github.com/odrevet/edict_database
[ichiran-github]: https://github.com/tshatrov/ichiran
[jisho-rikai]: https://jisho.org/search/%E7%90%86%E8%A7%A3
[lual-luarocks]: https://luarocks.org/modules/arthur-debert/lual
[lsqlite-luarocks]: https://luarocks.org/modules/javierguerragiraldez/lsqlite3
[luautf8-github]: https://github.com/starwing/luautf8
[rikai-nvim-wiki]: https://github.com/teto/rikai.nvim/wiki/Home
[rikai-wiki]: https://github.com/teto/rikai.nvim/wiki
[rikaitan]: https://addons.mozilla.org/en-US/firefox/addon/rikaitan/
[sudachi-rs]: https://github.com/WorksApplications/sudachi.rs
<!-- - [lsqlite3](https://luarocks.org/modules/javierguerragiraldez/lsqlite3) ? -->
<!-- - https://github.com/uga-rosa/utf8.nvim (last commit 2 years ago) -->
