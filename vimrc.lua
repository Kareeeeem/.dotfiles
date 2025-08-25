-- diagnostics
vim.diagnostic.config({
  severity_sort = true,
  float = {
    source = true,
    severity_sort = true,
    focusable = false,
  },
})

vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.open_float({ scope = 'line' })
end)

-- telescope
local actions = require("telescope.actions")
local telescope = require('telescope')
telescope.setup {
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
      preview_cutoff = 60
    },
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
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

-- lsp
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    -- Enable auto-completion.
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
    end
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
vim.lsp.config('bashls', { capabilities = capabilities })
vim.lsp.enable('bashls')

vim.lsp.config('ts_ls', { capabilities = capabilities })
vim.lsp.enable('ts_ls')

vim.lsp.config('pyright', { capabilities = capabilities })
vim.lsp.enable('pyright')

vim.lsp.config('lua_ls', {
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
})
vim.lsp.enable('lua_ls')

vim.lsp.enable('emmet_language_server')

-- linting
require('lint').linters_by_ft = {
  javascript = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  typescript = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
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
    javascript = { 'prettierd' },
    javascriptreact = { 'prettierd' },
    typescript = { 'prettierd' },
    typescriptreact = { 'prettierd' },
    sh = { 'shfmt' },
    json = { 'jq' },
    ["*"] = { "trim_whitespace", "trim_newlines" },
  },
  notify_on_error = false,
  format_on_save = {
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
      { 'filename', path = 3 }
    }
  }
}
