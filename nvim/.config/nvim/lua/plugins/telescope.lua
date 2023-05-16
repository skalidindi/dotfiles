return {
  {
    "telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      {
        "ahmedkhalf/project.nvim",
        opts = {},
        event = "VeryLazy",
        config = function(_, opts)
          require("project_nvim").setup(opts)
          require("telescope").load_extension("projects")
        end,
        keys = {
          { "<leader>fp", "<Cmd>Telescope projects<CR>", desc = "Projects" },
        },
      },
    },
    keys = {
      -- {
      --   "<leader>pf",
      --   function() require("telescope.builtin").find_files() end,
      --   desc = "Find Project Files",
      -- },
      {
        "<leader>pg",
        function() require("telescope.builtin").live_grep() end,
        desc = "Grep Project",
      },
      {
        "<leader>fg",
        function() require("telescope.builtin").git_files() end,
        desc = "Find Git Files",
      },
    },
  },
  {
    "goolord/alpha-nvim",
    opts = function(_, dashboard)
      local button = dashboard.button("p", " " .. " Projects", ":Telescope projects <CR>")
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
      table.insert(dashboard.section.buttons.val, 4, button)
    end,
  },
}
