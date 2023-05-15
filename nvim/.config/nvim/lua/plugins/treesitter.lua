return {
  "nvim-treesitter/nvim-treesitter",
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
