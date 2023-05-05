-- general vim settings
vim.diagnostic.config({
    underline = {severity = 'error'},
    virtual_text = false,
    severity_sort = true,
    float = {
        source = true,
        severity_sort = false,
    },
})
vim.keymap.set('n', '<leader>e', function()
    vim.diagnostic.open_float({ scope = 'line' })
end)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>l', vim.diagnostic.setloclist)

-- language Server Protocol

local function on_attach(client, bufnr)
    if client.name == "tsserver" then
        client.server_capabilities.documentFormattingProvider = false
    end
    local function is_null_ls_formatting_enabled(bufnr_)
        local file_type = vim.api.nvim_buf_get_option(bufnr_, "filetype")
        local generators = require("null-ls.generators").get_available(
            file_type,
            require("null-ls.methods").internal.FORMATTING
        )
        return #generators > 0
    end

    if client.server_capabilities.documentFormattingProvider then
        if
            client.name == "null-ls" and is_null_ls_formatting_enabled(bufnr)
            or client.name ~= "null-ls"
        then
            vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
            vim.keymap.set("n", "<leader>gq", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")
        else
            vim.bo[bufnr].formatexpr = nil
        end
    end
end

local lspconfig = require('lspconfig')
local cmp = require('cmp')
local capabilities = require("cmp_nvim_lsp").default_capabilities()

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp' },
        {
            name = 'buffer',
            option = {
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                end
            }
        },
    })
})


lspconfig.racket_langserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "racket", "scheme", "sicp" },
}

lspconfig.tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

lspconfig.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

lspconfig.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                diagnosticSeverityOverrides = {
                    reportIncompatibleMethodOverride = "error",
                    reportIncompatibleVariableOverride = true,
                    reportImportCycles = "warning",
                    reportUnnecessaryTypeIgnoreComment = "warning",
                    reportMissingTypeArgument = "none",
                    reportUnknownArgumentType = "none",
                    reportUnknownLambdaType = "none",
                    reportUnknownMemberType = "none",
                    reportUnknownParameterType = "none",
                    reportUnknownVariableType = "none",
                    -- reportUnknownVariableType = "none",
                    -- reportPropertyTypeMismatch = "error",
                    -- reportMissingSuperCall = "error",
                },
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "strict"
            }
        }
    }
}

local null_ls = require("null-ls")

null_ls.setup({
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            local formatting_augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            vim.api.nvim_clear_autocmds({ group = formatting_augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = formatting_augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({
                        async = false,
                        bufnr = bufnr,
                        filter = function(client_)
                            return client_.name == "null-ls"
                        end
                    })
                end,
            })
        end
        on_attach(client, bufnr)
    end,
    sources = {
        null_ls.builtins.diagnostics.flake8.with({
            extra_args = { '--max-line-length=88' },
        }),
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.formatting.eslint_d,
        null_ls.builtins.formatting.prettierd,
        -- null_ls.builtins.diagnostics.mypy
    },
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gk', vim.lsp.buf.signature_help, opts)
        -- vim.keymap.set('n', 'gs', function ()
        --     vim.lsp.buf.workspace_symbol()
        -- end,opts)
        -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        -- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        -- vim.keymap.set('n', '<leader>wl', function()
        --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

-- statusline
require('lualine').setup {
    options = {
        theme = '16color',
        icons_enabled = false,
        section_separators = '',
        component_separators = '',
    },
    sections = {
        lualine_c = { '%.50f' },  -- filepath
        lualine_z = { 'location', require 'dap'.status }
    }
}

local telescope = require('telescope')
telescope.setup {
    defaults = {
        layout_strategy = 'vertical',
        layout_config = {
            preview_cutoff = 60
        }
    }
}
telescope.load_extension('fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>p', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>h', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>t', function()
    require 'telescope.builtin'.lsp_dynamic_workspace_symbols({
        show_line = true,
        ignore_symbols = {
            'variable',
        }
    })
end, {})

-- Debug Adapter Protocol

local dap = require('dap')
dap.defaults.fallback.terminal_win_cmd = 'enew!'

require('dap-python').setup('~/.config/virtualenvs/debugpy/bin/python')

vim.api.nvim_set_hl(0, "DapBreakPoint", { reverse = true })
vim.api.nvim_set_hl(0, "DapBreakPointCondition", { link = "DapBreakPoint" })
vim.api.nvim_set_hl(0, "DapLogPoint", { link = "IncSearch" })
vim.api.nvim_set_hl(0, "DapStopped", { link = "Search" })
vim.api.nvim_set_hl(0, "DapBreakpointRejected", { link = "ErrorMsg" })

vim.fn.sign_define('DapBreakpoint', { text = 'B', texthl = '', linehl = 'DapBreakPoint', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = 'C', texthl = '', linehl = 'DapBreakpointCondition', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = 'L', texthl = '', linehl = 'DapLogPoint', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '>', texthl = '', linehl = 'DapStopped', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = 'X', texthl = '', linehl = 'DapBreakpointRejected', numhl = '' })

local py_configs = dap.configurations.python or {}
dap.configurations.python = py_configs
table.insert(py_configs, 1, {
    type = 'python',
    request = 'attach',
    name = 'Attach Running APP',
    dont_terminate_on_exit = true,
    connect = {
        host = '127.0.0.1',
        port = '${env:DEBUGPY_PORT}',
    },
})

require("dap-vscode-js").setup({
    debugger_path = "~/src/vscode-js-debug-1.77.2",
    adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
})

for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
    require("dap").configurations[language] = {
        {
            type = "pwa-chrome",
            name = "Attach - Remote Debugging",
            request = "attach",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            port = 9222,
            webRoot = "${workspaceFolder}",
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
                "./node_modules/jest/bin/jest.js",
                "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
        }
    }
end

vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end)
vim.keymap.set('n', '<leader>dn', function() require('dap').step_over() end)
vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end)
vim.keymap.set('n', '<leader>do', function() require('dap').step_out() end)
vim.keymap.set('n', '<leader>df', function() require('dap').focus_frame() end)
vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function()
    require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.toggle() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set('n', '<Leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end)
