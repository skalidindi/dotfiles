return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    config = function(_, opts)
      catpuccin = require("catppuccin")
      -- opts.term_colors = true
      -- opts.transparent_background = true
      opts.integrations.bufferline = true
      -- print(vim.inspect(opts))
      catpuccin.setup(opts)
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
