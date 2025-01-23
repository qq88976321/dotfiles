return {
    dir = "~/project/lc.nvim",
    build = ":TSUpdate html",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "tree-sitter/tree-sitter-html",
    },
    config = function()
        require("leetcode").setup({
            lang = "python3",
            injector = {
                ["python3"] = { before = true },
                ["cpp"] = {
                    before = { "#include <bits/stdc++.h>", "using namespace std;" },
                    after = "int main() {}",
                },
            },
            storage = {
                home = vim.fn.stdpath("data") .. "/l",
                cache = vim.fn.stdpath("cache") .. "/l",
            },
        })
    end,
}
