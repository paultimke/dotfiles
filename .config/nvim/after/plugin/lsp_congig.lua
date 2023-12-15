local lsp_config = require('lsp-zero')

lsp_config.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_config.default_keymaps({buffer = bufnr})
end)

-- Configure mason
require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {
		'lua_ls',
		'clangd',
        'pylsp',
		'rust_analyzer',
	},
	handlers = {
		lsp_config.default_setup,
	},
})

-- Setup python LSP to ignore certain warnings
require('lspconfig').pylsp.setup({
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {enabled = false},
                pylint = {
                    --enabled = false
                    args = {'--ignore=E501,E231,E221,E226,W391', '-'}
                },
            },
        },
    },
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
    sources = {
        {name = 'path'},
        {name = 'nvim_lsp'},
        {name = 'nvim_lua'},
    },
    formatting = lsp_config.cmp_format(),
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({select = true}),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
})
