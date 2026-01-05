local M = {}

-- translate cword
---@return table
M.lookup = function ()
    local bufnr = 0
    local r,_c = unpack(vim.api.nvim_win_get_cursor(0))
    local content = vim.api.nvim_buf_get_lines(bufnr, r, r, false)
    print(content)

    -- take only first part
    -- read output and use it in create_popup
    -- this is a hack until I can start ichiran in a better way
    -- local args = {'docker', 'exec', '-it', 'ichiran-main-1', '-i', content}
    local args = {'nix'}

    local output = {}
    local _jobId = vim.fn.jobstart(args
    -- options
    , {
        stdout_buffered = true,
        -- ({chan-id}, {data}, {name})
        ---@param _chan_id number
        ---@param data table
        ---@param _stream_name string
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

return M
