return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  config = function(_, opts)
    local bufferline = require("bufferline")
    -- opts.options.style_preset = bufferline.style_preset.no_italic
    -- opts.options.separator_style = "slant"
    -- opts.options.indicator = {
    --   style = "underline",
    -- }
    bufferline.setup(opts)
  end,
  keys = {
    {
      "<C-w>",
      function()
        require("mini.bufremove").delete(0, false)
      end,
      desc = "Delete Buffer"
    },
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
  },
}
