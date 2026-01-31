
-- このマークは、国くにのルールを守まもっているおもちゃにつけます。 3歳さいまでの子こどものおもちゃは、このマークがついていないと、売うることができません

local function get_current_sentence()
  -- Get the current buffer and cursor position
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor_pos[1] - 1, cursor_pos[2]  -- Convert to 0-based indexing

  -- Get the current line
  local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]

  -- Define sentence delimiters
  local delimiters = {['.'] = true, ['。'] = true, ['！'] = true, ['？'] = true, ['?'] = true, ['!'] = true}

  -- Find the start and end of the sentence
  local start_col = col
  local end_col = col

  -- Find the start of the sentence (backwards)
  while start_col > 0 do
    local char = line:sub(start_col, start_col)
    if delimiters[char] then
      start_col = start_col + 1  -- Move past the delimiter
      break
    end
    start_col = start_col - 1
  end

  -- Find the end of the sentence (forwards)
  while end_col <= #line do
    local char = line:sub(end_col + 1, end_col + 1)
    if delimiters[char] then
      break
    end
    end_col = end_col + 1
  end

  -- Extract the sentence
  local sentence = line:sub(start_col, end_col)

  return sentence
end

-- Example usage: Print the current sentence
print(get_current_sentence())
