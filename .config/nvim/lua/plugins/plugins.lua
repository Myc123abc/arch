local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim' -- theme
  use 'morhetz/gruvbox'
  use {
    'nvim-lualine/lualine.nvim',  -- statu line
    requires = { 'nvim-tree/nvim-web-devicons', opt = true } -- statu line pictures
  }
  use {
    'nvim-tree/nvim-tree.lua',  -- file tree
    requires = {
      'nvim-tree/nvim-web-devicons', -- file tree pictures
    },
  }
  use 'nvim-treesitter/nvim-treesitter' -- syntax highlight
  use 'p00f/nvim-ts-rainbow'            -- rainbow brackets
  use {
    'williamboman/mason.nvim',          -- lsp
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig'
  }

  use('hrsh7th/nvim-cmp')               -- auto fix completion
  use('hrsh7th/cmp-nvim-lsp')
  use('L3MON4D3/LuaSnip')
  use('saadparwaiz1/cmp_luasnip')
  use('rafamadriz/friendly-snippets')
  use('hrsh7th/cmp-path')

  use 'numToStr/Comment.nvim'           -- gcc Comment
  use 'windwp/nvim-autopairs'           -- auto fix pairs

  use 'akinsho/bufferline.nvim'         -- buffer
  use 'lewis6991/gitsigns.nvim'         -- git Comment

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.2', -- file find
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
