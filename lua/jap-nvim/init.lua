local util = vim.lsp.util

local M = {}


-- romaji to katakana
M.ro2ka = function (args)
    print("ro2ka called for range ", args.line1, args.line2)
    print("ro2ka not implemented yet, use jiten")
    -- TODO edit buffer
end


-- romaji to hiragana
M.ro2hi = function (args)
    print("ro2hi called for range ", args.line1, args.line2)
    print("ro2hi not implemented yet, use jiten")
end

-- translate cword
M.lookup = function ()
    local bufnr = 0
    local r,_c = unpack(vim.api.nvim_win_get_cursor(0))
-- print(r, c)
    -- j'aim
    local content = vim.api.nvim_buf_get_lines(bufnr, r, r, false)
    print(content)

    -- take only first part
    -- read output and use it in create_popup
    -- this is a hack until I can start ichiran in a better way
    -- local args = {'docker', 'exec', '-it', 'ichiran-main-1', '-i', content}
    local args = {'nix'}

    local output = {}
    jobId = vim.fn.jobstart(args
    -- options
    , {
        stdout_buffered = true,
        -- ({chan-id}, {data}, {name})
        on_stdout = function(_chan_id, data, _stream_name) 
            print("callback args:", data)
            -- output = output .. vim.fn.join(data)
            return {
                "line 1",
                "line 2"

            }

            -- return output
        end
    }
    )

    -- os.execute([[docker exec -it ichiran-main-1 ichiran-cli -i "一覧は最高だぞ"]])
   -- local r = io.popen("nix-prefetch-url --unpack "..url)
   -- local checksum = r:read()
   -- return checksum

   return output
end


M.show_info = function ()
    -- os.execute([[docker exec -it ichiran-main-1 ichiran-cli -i "一覧は最高だぞ"]])
    local content = M.lookup ()
    -- {
    --     "THIS IS THE CONTENT"
    -- }
    --
    M.create_popup(content)
end

M.create_popup = function (content)
    vim.validate{
        content={content,'table' }
    }
    local params = vim.lsp.util.make_position_params()
    vim.pretty_print(params)
    -- E5108: Error executing lua ...nwrapped-26cc946/share/nvim/runtime/lua/vim/lsp/util.lua:1682: 'width' key must be a positive Integer                                                             
-- stack traceback:                                                                                                                                                                                
    --     [C]: in function 'nvim_open_win'                                                                                                                                                        
    --     ...nwrapped-26cc946/share/nvim/runtime/lua/vim/lsp/util.lua:1682: in function 'open_floating_preview'
    local width = 100
    local height = 30
    local opts = {
        -- border = "single"
    }
    local popupOptions = util.make_floating_popup_options(width, height, opts)
    local _floating_bufnr, _floating_winnr = util.open_floating_preview(content, "text", popupOptions)
end

return M
