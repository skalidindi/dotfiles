return {
  {
    "OXY2DEV/helpview.nvim",
    lazy = false,
    ft = "help",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = { ensure_installed = { "vimdoc" } },
    },
  },
}
