return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",
    "tailwindcss-language-server",

    -- Rust
    "rust-analyzer",

    -- Debugger
    "codelldb",

    -- Python
    "pyright",
    "python-lsp-server",
    },
  },
}
