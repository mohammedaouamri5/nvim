local function switch_chpp()
  local function file_exists(path)
    local f = io.open(path, "r")
    if f then
      f:close()
      return true
    else
      return false
    end
  end

  local __path = vim.api.nvim_buf_get_name(0)
  local new_path = ""

  -- Check for `.cpp` or `.hpp` at the end of the file path
  if string.sub(__path, -4) == ".cpp" then
    new_path = string.sub(__path, 1, -5) .. ".hpp"
  elseif string.sub(__path, -4) == ".hpp" then
    new_path = string.sub(__path, 1, -5) .. ".cpp"
  else
    print("Current file is neither a .cpp nor a .hpp file.")
    return
  end

  -- Check if the new file exists
  if not file_exists(new_path) then
    print("Corresponding file does not exist: " .. new_path)
  else
    vim.api.nvim_command("edit " .. new_path)
  end

  -- Open the new file or the current file (if the new one does not exist)
end

-- Create a user command to call the function
vim.api.nvim_create_user_command("SwitchChpp", switch_chpp, {})

vim.api.nvim_set_keymap('n', '<C-p>', ':SwitchChpp<CR>', { noremap = true, silent = true })

