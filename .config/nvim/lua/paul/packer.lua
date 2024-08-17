-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Telescope, fuzzy finder to look for files
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.4',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Rose Pine colorscheme
  --use({
    --  'rose-pine/neovim',
	--  as = 'rose-pine',
	--  config = function()
	--	  vim.cmd('colorscheme rose-pine')
	--  end
  --})

  -- VS Code colorscheme
  --use({
      --'Mofiqul/vscode.nvim',
      --as = 'vscode',
      --config = function()
      --    vim.cmd('colorscheme vscode')
      --end,

      --require('vscode').setup({
      --    transparent = true
      --})
  --})

  use({
      'lewis6991/gitsigns.nvim'
  })

  -- Treesitter for syntax highlighting
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

  -- Mason is used to install LSP packages
  use ({
	  "williamboman/mason.nvim",
	  "williamboman/mason-lspconfig.nvim",
	  "neovim/nvim-lspconfig",
  })

  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v3.x',
	  requires = {
		  --- Uncomment these if you want to manage LSP servers from neovim
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'L3MON4D3/LuaSnip'},
	  }
  }

 end)
