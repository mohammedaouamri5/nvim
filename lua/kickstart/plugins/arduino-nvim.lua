return {
  'glebzlat/arduino-nvim',
  config = {
    function()
      require('arduino-nvim').setup()
    end,
    filetype = 'arduino',
    clangd = '/usr/local/bin/clangd',
    arduino = '/usr/local/bin/arduino-cli',
  },

}
