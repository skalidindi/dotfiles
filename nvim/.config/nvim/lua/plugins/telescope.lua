return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
  keys = {
    {
      "<leader>pf",
      function() require("telescope.builtin").find_files() end,
      desc = "Find Project Files",
    },
    {
      "<leader>pg",
      function() require("telescope.builtin").live_grep() end,
      desc = "Grep Project",
    },
    {
      "<leader>gf",
      function() require("telescope.builtin").git_files() end,
      desc = "Find Git Files",
    },
  },
}
