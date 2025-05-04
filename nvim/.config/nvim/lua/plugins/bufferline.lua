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
        require("snacks").bufdelete()
      end,
      desc = "Delete Buffer"
    },
  },
}
