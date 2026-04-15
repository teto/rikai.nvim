# justfile to run Busted tests
# check:
# 	luacheck lua/rocks plugin/ installer.lua
# we use treefmt instead
# lint:
#     lx lint

lint-check:
    treefmt --fail-on-change

test-install-dictionaries:
    nvim --clean --cmd 'set rtp^=.' +'Rikai download' -e +quitall!
    [ -d ~/.local/share/nvim/rikai/kanjivg ]
    [ -f ~/.local/share/nvim/rikai/kanji.db ]
    [ -f ~/.local/share/nvim/rikai/expression.db ]

# Target to run Busted tests
test:
    # we need to setup the environment so it can find the dictionaries
    # @busted --lua=nlua
    # can use impure
    # cp 
    lx test

# check types
emmylua_check:
    # VIMRUNTIME=$(nvim --headless +'echo $VIMRUNTIME' -cq)
    emmylua_check --verbose .

test-online:
    # @busted --lua=nlua 
    lx test

docgen:
    mkdir -p doc
    vimcats lua/rikai/{init,commands,config/init,meta,api/{init,hooks},log}.lua > doc/rikai.txt

kokoro-test:
    # pipe it into mpv ?
    python3 -m kokoro --text "The sky above the port was the color of television, tuned to a dead channel." -o file.wav --debug
