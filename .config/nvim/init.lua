-- checking if we're using WSL, setting up clipboard appropriately
local function is_wsl()
  local sys = vim.fn.system('uname -r');
  return sys:lower():match('wsl') ~= nil
end

if is_wsl() then 
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.clipboard = 'unnamedplus'

require("config.lazy")
