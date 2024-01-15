return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, {
        -- lua stuff
      "lua-language-server",
      "stylua",

      -- web dev stuff
      "css-lsp",
      "html-lsp",
      "typescript-language-server",
      "deno",
      "tailwindcss-language-server",

      -- Rust
      "rust-analyzer",

      -- Debugger
      "codelldb",

      -- Python
      "pyright",
      "python-lsp-server",
    })
  end
}
