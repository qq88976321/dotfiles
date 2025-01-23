return {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
        require("ts_context_commentstring").setup({ enable_autocmd = false })

        require("Comment").setup({
            -- Use ts-context-commentstring to pick the correct comment syntax
            -- for the language under the cursor (e.g. JS inside a Vue template)
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        })

        local api = require("Comment.api")

        -- Normal mode: toggle comment on current line
        vim.keymap.set("n", "<C-/>", api.toggle.linewise.current, { desc = "Toggle comment" })
        -- <C-_> is what most terminals send for Ctrl+/
        vim.keymap.set("n", "<C-_>", api.toggle.linewise.current, { desc = "Toggle comment" })

        -- Visual mode: toggle comment on selection
        local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
        vim.keymap.set("v", "<C-/>", function()
            vim.api.nvim_feedkeys(esc, "nx", false)
            api.toggle.linewise(vim.fn.visualmode())
        end, { desc = "Toggle comment" })
        vim.keymap.set("v", "<C-_>", function()
            vim.api.nvim_feedkeys(esc, "nx", false)
            api.toggle.linewise(vim.fn.visualmode())
        end, { desc = "Toggle comment" })
    end,
}
