return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      -- web dev
      "css",
      "html",
      "svelte",
      "vue",
    })
  end,
}
