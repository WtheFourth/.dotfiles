return {
  {
    "williamboman/mason.nvim",
    config = function() require("mason").setup() end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "ruby_lsp", "rubocop", "cssls", "eslint", "csharp_ls" }
      })
      require("mason-lspconfig").setup_handlers {
        function(server_name)
          require("lspconfig")[server_name].setup {}
        end
        -- server-specific handlers
        -- ["server-name'] = function()
        --   require("other-thing").setup {}
        -- end
      }
    end
  },
  {
    "neovim/nvim-lspconfig"
  }
}
