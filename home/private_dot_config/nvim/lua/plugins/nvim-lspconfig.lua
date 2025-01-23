return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- Keymaps applied whenever an LSP attaches to a buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local bufnr = args.buf
                    local nmap = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
                    end

                    nmap("gd", vim.lsp.buf.definition, "Go to Definition")
                    nmap("gr", vim.lsp.buf.references, "Go to References")
                    nmap("gh", vim.lsp.buf.hover, "Hover Documentation")
                    nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
                    nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
                end,
            })

            -- Diagnostics display settings
            vim.diagnostic.config({
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "●",
                },
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = true,
                },
            })

            -- Ruff (Python linter/formatter)
            vim.lsp.config("ruff", {
                settings = {
                    format = { args = {} },
                },
            })
            vim.lsp.enable("ruff")

            -- Pyright (Python type checker) — uncomment to enable
            -- vim.lsp.config("pyright", {
            --     settings = {
            --         python = {
            --             analysis = {
            --                 typeCheckingMode = "basic",
            --                 autoSearchPaths = true,
            --                 useLibraryCodeForTypes = true,
            --                 diagnosticMode = "workspace",
            --             },
            --         },
            --     },
            -- })
            -- vim.lsp.enable("pyright")
        end,
    },
}
