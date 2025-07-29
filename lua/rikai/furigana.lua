local M = {}

local furigana_ns = 'rikai-furigana'

function M.add_furigana(_args)
    -- Get the buffer number (0 refers to the current buffer)
    local bufnr = 0

    -- Create a namespace for virtual text
    local namespace_id = vim.api.nvim_create_namespace(furigana_ns)

    -- Define the virtual text to be added
    local virtual_text = {{'This is virtual text', 'RikaiVirtualText'}}

    -- Set the virtual text on a specific line and column
    vim.api.nvim_buf_set_extmark(bufnr, namespace_id, 5, 0, {
        virt_text = virtual_text,
        -- Optional: Position it on the right side of the line
        virt_text_pos = 'right_align'
    })
end

function M.clear()
end

function M.setup_autocommands()
        vim.api.nvim_create_autocmd('CursorMoved', {
            callback = function()
                -- delete
            end,
        })
end

return M
