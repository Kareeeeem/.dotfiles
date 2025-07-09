-- completion

local cmp = require('cmp')
local cmp_lsp = require("cmp_nvim_lsp")
local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  cmp_lsp.default_capabilities()
)

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- search
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
vim.keymap.set('n', '<leader>c', builtin.colorscheme, {})
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

-- diagnostics
vim.diagnostic.config({
  -- virtual_text = true,
  -- virtual_lines = true,
  severity_sort = true,
  float = {
    source = true,
    severity_sort = true,
    focusable = false,
    -- header = "",
    -- prefix = "",
    -- style = "minimal",
    -- border = "single",
  },
})

-- lsp
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }

    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    -- vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover({ border = "single" })<cr>', opts)
    vim.keymap.set('n', 'gk', vim.lsp.buf.signature_help, opts)
    -- vim.keymap.set('n', 'gk', '<cmd>lua vim.lsp.buf.signature_help({ border = "single" })<cr>', opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>l', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<leader>e', function()
      vim.diagnostic.open_float({ scope = 'line' })
    end, opts)
  end,
})

vim.lsp.config('bashls', {
  capabilities = capabilities,
})
vim.lsp.enable('bashls')

vim.lsp.config('ts_ls', {
  capabilities = capabilities,
})
vim .lsp.enable('ts_ls')

vim.lsp.config('pyright', {
  capabilities = capabilities,
})
vim.lsp.enable('pyright')

vim.lsp.enable('ruff')
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})


vim.lsp.config('lua_ls', {
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
})
vim.lsp.enable('lua_ls')

-- linting
require('lint').linters_by_ft = {
  javascript = {'eslint_d'},
  javascriptreact = {'eslint_d'},
  typescript = {'eslint_d'},
  typescriptreact = {'eslint_d'},
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})


-- formatting
require("conform").setup({
  formatters_by_ft = {
    python = { "ruff_format", "ruff_organize_imports" },
    javascript = {'prettierd'},
    javascriptreact = {'prettierd'},
    typescript = {'prettierd'},
    typescriptreact = {'prettierd'},
    ["*"] = { "trim_whitespace" },
  },
  notify_on_error = false,
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

-- statusline
require('lualine').setup {
  options = {
    theme = 'material',
    icons_enabled = false,
    section_separators = '',
    component_separators = '',
  },
  tabline = {
    -- lualine_a = {
    --   {
    --     'buffers',
    --     symbols = {
    --       modified = '+',
    --       alternate_file = '#',
    --     },
    --   }
    -- }
  },
  sections = {
    lualine_a = {
      {
        'mode',
        -- Only show the first letter of the mode. ex: N I V
        fmt = function(str) return str:sub(1, 1) end
      }
    },
    lualine_b = {
      "branch",
      {
        "diff",
        colored = false,  -- the default colors of my colorscheme suck for this
      },
      {
        "diagnostics",
        fmt = function(str)
          -- Only show the highest severity level diagnostic.
          -- The value is a string listing diagnostics separated by spaces
          for level in string.gmatch(str, '%S+') do
            return level
          end
          return nil
        end
      }
    },
    lualine_c = {
      {
        'filename',
        path = 3,
        -- 1: Relative path
        -- 2: Absolute path
        -- 3: Absolute path, with tilde as the home directory
        -- 4: Filename and parent dir, with tilde as the home directory
      }
    }
  }
}
