return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      hover = {
        enabled = true,
        delay = 200,
        reveal = {"close"}
      }
    },
  },
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
