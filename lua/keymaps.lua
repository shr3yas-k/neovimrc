local opts = { noremap = true, silent = true }

-- Clear search highlights on esc
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- Disable arrow keys in normal/insert modes.
vim.keymap.set({ "n", "i" }, "<Up>", "<Nop>", opts)
vim.keymap.set({ "n", "i" }, "<Down>", "<Nop>", opts)
vim.keymap.set({ "n", "i" }, "<Left>", "<Nop>", opts)
vim.keymap.set({ "n", "i" }, "<Right>", "<Nop>", opts)

-- Navigate across terminals (t => terminal mode)
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]])
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]])
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]])
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]])

-- Mapping to build and run C++ Files
vim.keymap.set("n", "<leader>r", function()
    vim.cmd("w")

    local file = vim.fn.expand("%:t")        -- client.c
    local file_no_ext = vim.fn.expand("%:t:r") -- client
    local dir = vim.fn.expand("%:p:h")       -- full dir

    vim.cmd("split | terminal")
    vim.cmd("startinsert")

    local cmd = string.format(
        "cd %s && g++ -Wall -Wextra %s -o %s && ./%s\n",
        dir,
        file,
        file_no_ext,
        file_no_ext
    )

    vim.defer_fn(function()
        vim.fn.chansend(vim.b.terminal_job_id, cmd)
    end, 100)
end)

-- Enters start of next block instead of exactly moving down/up.
vim.keymap.set('n', 'j', 'j^', { noremap = true, silent = true })
vim.keymap.set('n', 'k', 'k^', { noremap = true, silent = true })
