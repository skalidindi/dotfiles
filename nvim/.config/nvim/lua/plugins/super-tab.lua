return {
  'saghen/blink.cmp',
  opts = {
    keymap = {
      preset = 'super-tab',
      ['<Tab>'] = {
        function(cmp)
          if cmp.snippet_active() then return cmp.accept()
          else return cmp.select_and_accept() end
        end,
        'snippet_forward',
        'fallback'
      }
    }
  }
}
