return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
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
