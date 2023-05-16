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
  },
}
