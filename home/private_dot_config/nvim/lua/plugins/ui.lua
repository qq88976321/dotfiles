return {
    -- Icons (used by neo-tree, lualine, telescope, etc.)
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- Better vim.ui.select / vim.ui.input
    { "stevearc/dressing.nvim", event = "VeryLazy" },

    -- Startup time profiler (:StartupTime)
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        init = function()
            vim.g.startuptime_tries = 10
        end,
    },
}
