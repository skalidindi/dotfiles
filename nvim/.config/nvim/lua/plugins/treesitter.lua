return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      -- languages
      "python",
      "rust",

      -- web dev
      "css",
      "html",
      "jsonc",
      "svelte",
      "vue",

      -- other
      "toml",
    })
  end,
}
