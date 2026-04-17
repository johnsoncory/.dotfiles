local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        local opts = { buffer = args.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    end,
})

local plugins = require("andyjson.omarchy_theme").plugins()

vim.list_extend(plugins, {
    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })
            vim.lsp.config("roslyn", {
                capabilities = capabilities,
                settings = {
                    ["csharp|background_analysis"] = {
                        dotnet_analyzer_diagnostics_scope = "openFiles",
                        dotnet_compiler_diagnostics_scope = "openFiles",
                    },
                    ["csharp|completion"] = {
                        dotnet_show_completion_items_from_unimported_namespaces = true,
                        dotnet_show_name_completion_suggestions = true,
                    },
                },
            })
        end,
    },
    {
        "mason-org/mason.nvim",
        opts = {
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            },
        },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = { "lua_ls" },
            automatic_enable = { "lua_ls" },
        },
    },
    {
        "seblyng/roslyn.nvim",
        ft = { "cs", "csproj", "sln", "slnx", "props", "cshtml", "razor" },
        opts = {
            broad_search = true,
            filewatching = "roslyn",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            "windwp/nvim-autopairs",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,noselect",
                },
                performance = {
                    debounce = 120,
                    throttle = 80,
                    fetching_timeout = 500,
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                }, {
                    { name = "buffer", keyword_length = 4 },
                }),
            })

            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")

            harpoon:setup()

            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():add()
            end, { desc = "Harpoon add file" })
            vim.keymap.set("n", "<leader>h", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = "Harpoon menu" })
            vim.keymap.set("n", "<leader>1", function()
                harpoon:list():select(1)
            end, { desc = "Harpoon file 1" })
            vim.keymap.set("n", "<leader>2", function()
                harpoon:list():select(2)
            end, { desc = "Harpoon file 2" })
            vim.keymap.set("n", "<leader>3", function()
                harpoon:list():select(3)
            end, { desc = "Harpoon file 3" })
            vim.keymap.set("n", "<leader>4", function()
                harpoon:list():select(4)
            end, { desc = "Harpoon file 4" })
            vim.keymap.set("n", "<C-p>", function()
                harpoon:list():prev()
            end, { desc = "Harpoon previous file" })
            vim.keymap.set("n", "<C-n>", function()
                harpoon:list():next()
            end, { desc = "Harpoon next file" })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "lua", "vim", "vimdoc", "query", "c_sharp" },
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
})

require("lazy").setup(plugins)
