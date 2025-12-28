-----------------------------------------------------------
-- url: https://github.com/nvim-telescope/telescope.nvim

-- tips: use `<C-q>` to freeze live-search result to quickfix window.
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fr", builtin.resume, {})
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_workspace_symbols<CR>", { noremap = true, silent = true })

local opts = { noremap = true, silent = true, nowait = true }
vim.keymap.set("n", "<space><space>", builtin.find_files, opts)
vim.keymap.set("n", "<space>g", builtin.live_grep, opts)
vim.keymap.set("n", "<space>G", builtin.grep_string, opts)
vim.keymap.set("n", ";", builtin.buffers, opts)

-- one `ESC` to quite telescope window.
local actions = require("telescope.actions")
require("telescope").setup({
  defaults = {
    find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    mappings = {
      n = {
        ["<c-d>"] = actions.delete_buffer,
      },
      i = {
        ["<esc>"] = actions.close,
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key",
      },
    },
  },
  pickers = {
    buffers = {
      -- ignore_current_buffer = true,
      sort_lastused = true,
      sort_mru = true,
    },
  },
})
