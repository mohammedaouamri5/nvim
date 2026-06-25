-- 1. Add the plugin to the pack manager
-- Note: 'gh' is local to your init.lua, so we use the full URL here
-- or you can redefine gh at the top of this file.
vim.pack.add { 'https://github.com/okuuva/auto-save.nvim' }

-- 2. Call the setup function with your options
require('auto-save').setup {
  enabled = true,
  -- 'execution_message' is REMOVED. We use the 'after_saving' hook instead.
  callbacks = {
    after_saving = function()
      -- This reproduces the old 'execution_message' behavior
      local msg = 'AutoSave: saved at ' .. vim.fn.strftime '%H:%M:%S'
      vim.api.nvim_echo({ { msg, 'None' } }, false, {})

      -- Optional: Clear the message after a delay (replacing cleaning_interval)
      vim.defer_fn(function() vim.api.nvim_echo({ { '', 'None' } }, false, {}) end, 1250)
    end,
  },
  trigger_events = {
    immediate_save = { 'BufLeave', 'FocusLost' },
    defer_save = { 'InsertLeave', 'TextChanged' },
    -- CORRECTED: cancel_defered_save -> cancel_deferred_save (two 'r's)
    cancel_deferred_save = { 'InsertEnter' },
  },
  condition = nil,
  write_all_buffers = false,
  noautocmd = false,
  lockmarks = false,
  debounce_delay = 1000,
  debug = false,
}
