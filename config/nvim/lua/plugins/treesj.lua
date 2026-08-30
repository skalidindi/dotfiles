return {
  "Wansmer/treesj",
  keys = {
    {
      "<leader>gm",
      function()
        require("treesj").toggle()
      end,
      desc = "Toggle Split / Join Block",
    },
    {
      "<leader>gj",
      function()
        require("treesj").join()
      end,
      desc = "Join Block",
    },
    {
      "<leader>gs",
      function()
        require("treesj").split()
      end,
      desc = "Split Block",
    }
  },
  cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesj").setup({ use_default_keymaps = false })
  end,
}
