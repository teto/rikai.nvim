
This plugin aims at providing offline translations when hovering asian (japanese for now) characters.

The name is inspired by the great browser [rikaitan][rikaitan] plugin.
理解 ("rikai") [translates][jisho-rikai] to "understanding", "comprehension".



# How to install ?

Right now it's in development so it's fully declarative but soon we should get a
nix build along with a rockspec.


Dependencies:
- [sudachi_rs][sudachi-rs] as a tokenizer (ie., split words)
- [edict_database][edict-as-sqlite] as sqlite databases
- [lual for logging][lual-luarocks]
- [official sqlite bindings][lsqlite-luarocks] for lua 'sqlite'

# Roadmap 

- support more tokenizers
- 
<!-- - jiten  -->
<!-- - wordbase  -->

<!-- Lua dependencies: -->
<!-- - [lsqlite3](https://luarocks.org/modules/javierguerragiraldez/lsqlite3) ? -->
<!-- - https://github.com/uga-rosa/utf8.nvim (last commit 2 years ago) -->

See wiki for more reference
using CLI   "wordbase-cli --output json lookup 出る"
import jamdict
https://jamdict.readthedocs.io/en/latest/
https://github.com/Top-Ranger/jmdict-to-sqlite3
https://github.com/ant32bit/JMDict2JSON

https://towardsdatascience.com/mecab-usage-and-add-user-dictionary-to-mecab-9ee58966fc6

TODO list 
create a top-level Rikai command with subcommands:
 "lookup"


* How to generate DB ?

nix shell nixpkgs#dart
clone https://github.com/odrevet/edict_database.git (fetch)


rikaitan: https://addons.mozilla.org/en-US/firefox/addon/rikaitan/
jisho-rikai: https://jisho.org/search/%E7%90%86%E8%A7%A3
sudachi-rs: https://github.com/WorksApplications/sudachi.rs
edict-as-sqlite: https://github.com/odrevet/edict_database
lual-luarocks: https://luarocks.org/modules/arthur-debert/lual
lsqlite-luarocks: https://luarocks.org/modules/javierguerragiraldez/lsqlite3
