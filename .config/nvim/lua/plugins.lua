-- Set up packer if it's not already installed
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

-- Run PackerCompile on changes to this file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require("packer").startup(function(use)
  -- Let packer update itself
  use("wbthomason/packer.nvim")

  use({
    "ray-x/lsp_signature.nvim",
    config = function()
      local lspsignature = require("lsp_signature")
      lspsignature.setup({
        floating_window = false,
        hint_prefix = "",
        hint_enable = true,
      })
    end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
