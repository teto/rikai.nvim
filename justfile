# justfile to run Busted tests
# check:
# 	luacheck lua/rocks plugin/ installer.lua
# we use treefmt instead
# lint:
#     lx lint

lint:
    treefmt

lint-check:
    treefmt --fail-on-change

test-install-dictionaries:
    nvim --headless --clean --cmd 'set rtp^=.' +'Rikai download' -e +quitall!
    [ -d ~/.local/share/nvim/rikai/kanjivg ]
    [ -f ~/.local/share/nvim/rikai/kanji.db ]
    [ -f ~/.local/share/nvim/rikai/expression.db ]

# Target to run Busted tests
test:
    # we need to setup the environment so it can find the dictionaries
    # @busted --lua=nlua
    lx test

# check types
emmylua_check:
    # VIMRUNTIME=$(nvim --headless +'echo $VIMRUNTIME' -cq)
    emmylua_check --verbose .

test-busted:
    @busted --lua=nlua 

test-lx:
    lx test

docgen:
    mkdir -p doc
    # --prefix-func
    vimcats lua/rikai/{init,commands,config,log}.lua > doc/rikai.txt
    nvim -u NONE -i NONE --headless +'helptags doc' +'quit!'

kokoro-test:
    # pipe it into mpv ?
    python3 -m kokoro --text "The sky above the port was the color of television, tuned to a dead channel." -o file.wav --debug
