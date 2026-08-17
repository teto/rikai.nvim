
This plugin aims at providing offline translations either on-demand and/or automatically when hovering asian (japanese for now) characters.

The name is inspired by the great browser [rikaitan][rikaitan] plugin.
理解 ("rikai") [translates][jisho-rikai] to "understanding", "comprehension".

Here are some possibly outdated screenshots: 
- Popup for a kanji
<img width="1112" height="542" alt="image" src="https://github.com/user-attachments/assets/16b04f0e-d0e1-4d9c-9f80-2c3724b297bf" />
- popup for an expression, the current word is automatically highlighted on cursor movement
 <img width="916" height="317" alt="image" src="https://github.com/user-attachments/assets/ab6433f6-758b-4566-827d-c0133fa4bb4e" />


# How to install ?

If you are using nix, you can use the flake to add the vim plugin to your system.
Dependencies are visible in the flake.nix.
Similarly if you want to test it out, you can just enter the shell with `nix
develop`.

On other systems, you must find a way to install these dependencies:

System Dependencies:
- [sudachi_rs][sudachi-rs] as a tokenizer (ie., split words), use the full version 
- [unzip][unzip] to unpack dictionaries

Lua dependencies:
- [mega.logging][mega-logging-luarocks] for logging
- [official sqlite bindings][lsqlite-luarocks] for lua 'sqlite'
- [utf8][luautf8-github] to get utf8

I recommand using the neovim package manager [rocks.nvim][rocks.nvim] since it
automatically installs the lua dependencies.

`:Rocks install rikai.nvim`

Once the plugin is installed, you will need to download the japanese
dictionaries with `:Rikai download` (needed just once):
- [edict_database][edict-as-sqlite] as sqlite databases


> [!TIP]
> Popups are written in markdown, to improve the rendering I advise installing
> [render-markdown-nvim][rendermarkdown-github] though it remains optional.

# How to configure ?

The plugin does not need any configuration: it works out of the box once installed.
You can tweak its behavior via `vim.g.rikai`, see `lua/rikai/config/default.lua`
for the available options.

> [!TIP]
> 
> Enable image preview if your terminal (for instance 'kitty') supports it with:
> ```lua
> vim.g.rikai = {
>   popup_options = {
>     render_images = true,
>   }
> }
> ```
>
> You will need to install [snacks.nvim][gh-snacks] as well.

You can tweak the highlights starting with `Rikai*` as well.

You can finally check your installation/configuration with `:checkhealth rikai`

# How to use ?

There are no default keymaps so you need to set one

```lua
vim.keymap.set({'n', 'v'}, '<D-j>', function() vim.cmd([[ Rikai lookup ]]) end, { buffer = false, desc = 'Japanese lookup' })

```

You can also call `:Rikai lookup 見` to see the translation.

To enable a more rikaichamp/yomitan-like experience, run `:Rikai live_hl enable`
to enable automatic translation and hilighting of current token. It's quite
experimental and not as polished as its inspiration though.

<!-- todo add link -->
Highlights used are visible in plugin/rikai.lua:
- RikaiHighlightWordGroup
- RikaiProperNoun
- RikaiCurrentToken
<!-- RikaiNames -->


# Roadmap 

- lux packaging
- romaji to kana and vice-versa
- let users customize display (support https://jpdb.io/)
- add rikai translate


<!-- Lua dependencies: -->

See [wiki][rikai-nvim-wiki] for more reference.


# How to get the various dictionaries used by rikai.nvim ?

Run `:Rikai download`.

# Related software

- [rikaitan][rikaitan]
- [tagainjisho](https://github.com/Gnurou/tagainijisho/)
- On android, I love [Kanji
  study](https://play.google.com/store/apps/details?id=com.mindtwisted.kanjistudy&pli=1)
- [ichiran][ichiran-github]

[rocks.nvim]: https://github.com/lumen-oss/rocks.nvim
[edict-as-sqlite]: https://github.com/odrevet/edict_database
[ichiran-github]: https://github.com/tshatrov/ichiran
[jisho-rikai]: https://jisho.org/search/%E7%90%86%E8%A7%A3
[lual-luarocks]: https://luarocks.org/modules/arthur-debert/lual
[lsqlite-luarocks]: https://luarocks.org/modules/javierguerragiraldez/lsqlite3
[luautf8-github]: https://github.com/starwing/luautf8
[mega-logging-luarocks]: https://luarocks.org/modules/colinkennedy/mega.logging
[rikai-nvim-wiki]: https://github.com/teto/rikai.nvim/wiki/Home
[rikai-wiki]: https://github.com/teto/rikai.nvim/wiki
[rikaitan]: https://addons.mozilla.org/en-US/firefox/addon/rikaitan/
[sudachi-rs]: https://github.com/WorksApplications/sudachi.rs
[rendermarkdown-github]: https://github.com/MeanderingProgrammer/render-markdown.nvim
[gh-snacks]: https://github.com/folke/snacks.nvim
<!-- - [lsqlite3](https://luarocks.org/modules/javierguerragiraldez/lsqlite3) ? -->
<!-- - https://github.com/uga-rosa/utf8.nvim (last commit 2 years ago) -->
