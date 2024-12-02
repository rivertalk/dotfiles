-----------------------------------------------------------
-- Neovim LSP configuration file
-----------------------------------------------------------

-- Plugin: nvim-lspconfig
-- url: https://github.com/neovim/nvim-lspconfig

-- For configuration see the Wiki: https://github.com/neovim/nvim-lspconfig/wiki
-- Autocompletion settings of "nvim-cmp" are defined in plugins/nvim-cmp.lua

local lsp_status_ok, lspconfig = pcall(require, "lspconfig")
if not lsp_status_ok then
  return
end

local cmp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_status_ok then
  return
end

-- Add additional capabilities supported by nvim-cmp
-- See: https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Highlighting references.
  -- See: https://sbulav.github.io/til/til-neovim-highlight-references/
  -- for the highlight trigger time see: `vim.opt.updatetime`
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

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions

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
  -- keymap("n", "<leader>la", vim.lsp.buf.add_workspace_folder, { desc = "lsp add workspace folder" })
  -- keymap("n", "<leader>lr", vim.lsp.buf.remove_workspace_folder, { desc = "lsp remove workspace folder" })
  -- keymap("n", "<leader>ll", function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end)
end

-- Diagnostic settings:
-- see: `:help vim.diagnostic.config`
-- Customizing how diagnostics are displayed
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
vim.cmd([[
  autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, { focus = false })
]])

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- keymap("n", "<space>e", vim.diagnostic.open_float, opts)
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

--[[
Language servers setup:

For language servers list see:
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

Language server installed:

Bash          -> bashls
Python        -> pyright
C-C++         -> clangd
HTML/CSS/JSON -> vscode-html-languageserver
JavaScript/TypeScript -> ts_ls
--]]

-- Define `root_dir` when needed
-- See: https://github.com/neovim/nvim-lspconfig/issues/320
-- This is a workaround, maybe not work with some servers.
local root_dir = function()
  return vim.fn.getcwd()
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches.
-- Add your language server below:
local servers = {
  "bashls",
  "pyright",
  "html",
  "cssls",
  "ts_ls",
  "mlir_lsp_server",
  "gopls",
  -- 'tblgen_lsp_server',
}

-- Call setup
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    root_dir = root_dir,
    capabilities = capabilities,
    flags = {
      -- default in neovim 0.7+
      debounce_text_changes = 150,
    },
  })
end

--
require("lspconfig").clangd.setup({
  filetypes = { "c", "cpp", "objc", "objcpp" }, -- drop "proto", too many errors.
  on_attach = on_attach,
  root_dir = root_dir,
  capabilities = capabilities,
  flags = {
    -- default in neovim 0.7+
    debounce_text_changes = 150,
  },
})

-- require'lspconfig'.mlir_lsp_server.setup{}
require("lspconfig").tblgen_lsp_server.setup({
  on_attach = on_attach,
  root_dir = root_dir,
  capabilities = capabilities,
  flags = {
    -- default in neovim 0.7+
    debounce_text_changes = 150,
  },
  -- the tblgen_lsp_server use tablegen_compile_commands.yml only for root finding
  -- not pass it as parameter for the binary
  cmd = {
    "tblgen-lsp-server",
    -- "--tablegen-compilation-database=tablegen_compile_commands.yml",
    "--tablegen-extra-dir=/home/jint/mygit/llvm-project/mlir/include",
  },
})
