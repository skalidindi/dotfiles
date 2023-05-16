return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  opts = {
    ensure_installed = {
      -- defaults
      "vim",
      "lua",
      "vimdoc",

      -- web dev
      "json",
      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",
      -- "vue", "svelte",

      -- low level
      "rust",

      -- other
      "bash",
      "markdown",
      "markdown_inline",
      "query",
      "regex",
    },
  },
}
