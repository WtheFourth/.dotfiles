return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "c_sharp", "lua", "vim", "vimdoc", "query", "typescript", "javascript", "html", "ruby" },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
        })
    end
 }
