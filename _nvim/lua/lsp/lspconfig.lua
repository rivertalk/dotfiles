-----------------------------------------------------------
-- Neovim LSP configuration file
-----------------------------------------------------------

-- Native LSP setup (removes nvim-lspconfig dependency for config loading)
-- This fixes the deprecation errors in Neovim 0.11+

local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

-- Root directory function
local root_dir = function()
  return vim.fn.getcwd()
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Highlighting references
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
      group = "lsp_document_highlight",
      desc = "Document Highlight",
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = vim.lsp.buf.clear_references,
      buffer = bufnr,
      group = "lsp_document_highlight",
      desc = "Clear All the References",
    })
  end

  -- Keymappings
  local function keymap(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true, buffer = bufnr }
    if opts then
      options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
  end

  keymap("n", "gD", vim.lsp.buf.declaration)
  keymap("n", "gd", vim.lsp.buf.definition)
  keymap("n", "K", vim.lsp.buf.hover)
  keymap("n", "gi", vim.lsp.buf.implementation)
  keymap("n", "gr", vim.lsp.buf.references, { desc = "lsp list references" })
  keymap("n", "<C-k>", vim.lsp.buf.signature_help)
  keymap("n", "<leader>lD", vim.lsp.buf.type_definition, { desc = "lsp type definition" })
  keymap("n", "<leader>lr", vim.lsp.buf.rename, { desc = "lsp apply rename" })
  keymap("n", "<leader>la", vim.lsp.buf.code_action, { desc = "lsp apply code action" })
  keymap("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, { desc = "lsp apply format" })
end

-- Diagnostic configuration
vim.diagnostic.config({
  update_in_insert = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Show line diagnostics automatically in hover window
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

-- Diagnostic keymaps
local function keymap(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "diagnostic got prev" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "diagnostic got next" })
keymap("n", "<leader>d", vim.diagnostic.setloclist, { desc = "diagnostic list" })

-- -------------------------------------------------------------------------
-- Server Definitions (Manual)
-- -------------------------------------------------------------------------

local servers = {
  bashls = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh", "bash" },
  },
  pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_dir = function(fname)
      local util = require("lspconfig.util")
      return util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git")(fname) or vim.fn.getcwd()
    end,
  },
  html = {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html" },
  },
  cssls = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
  },
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  },
  gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
  },
  clangd = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
  },
  mlir_lsp_server = {
    cmd = { "mlir-lsp-server" },
    filetypes = { "mlir" },
  },
  tblgen_lsp_server = {
    cmd = {
      "tblgen-lsp-server",
      "--tablegen-extra-dir=/home/jint/mygit/llvm-project/mlir/include",
    },
    filetypes = { "tablegen" },
  },
}

-- Setup Loop (Native)
for name, config in pairs(servers) do
  local final_config = vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
    root_dir = root_dir, -- default fallback
    name = name,
  }, config)

  -- Create autocommand to start LSP
  if final_config.filetypes then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = final_config.filetypes,
      callback = function(ev)
        -- Determine root_dir dynamically if it's a function
        local root = final_config.root_dir
        if type(root) == "function" then
           root = root(ev.file)
        end
        
        final_config.root_dir = root
        vim.lsp.start(final_config)
      end,
    })
  end
end
