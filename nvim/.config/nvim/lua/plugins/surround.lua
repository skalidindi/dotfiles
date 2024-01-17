return {
  {
    "echasnovski/mini.surround",
    enabled = false
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {
      keymaps = {
        insert          = "<C-g>z",
        insert_line     = "gC-ggZ",
        normal          = "gz",
        normal_cur      = "gZ",
        normal_line     = "gzgz",
        normal_cur_line = "gZgZ",
        visual          = "gz",
        visual_line     = "gZ",
        delete          = "gzd",
        change          = "gzc",
      }
    }
  }
}
