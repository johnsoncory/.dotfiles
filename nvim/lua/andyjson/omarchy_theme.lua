local M = {}

local theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
local fallback_colorscheme = "default"

local function load_theme_specs()
    if vim.fn.filereadable(theme_file) ~= 1 then
        return {}
    end

    local ok, specs = pcall(dofile, theme_file)
    if not ok or type(specs) ~= "table" then
        vim.notify("Unable to load Omarchy Neovim theme", vim.log.levels.WARN)
        return {}
    end

    return specs
end

local function theme_metadata(specs)
    for _, spec in ipairs(specs) do
        if spec[1] == "LazyVim/LazyVim" and type(spec.opts) == "table" then
            return {
                colorscheme = spec.opts.colorscheme,
                background = spec.opts.background,
            }
        end
    end

    return {}
end

function M.plugins()
    local plugins = {}

    for _, spec in ipairs(load_theme_specs()) do
        if type(spec) == "table" and spec[1] ~= "LazyVim/LazyVim" then
            table.insert(plugins, spec)
        end
    end

    return plugins
end

function M.apply()
    local metadata = theme_metadata(load_theme_specs())

    if metadata.background then
        vim.o.background = metadata.background
    end

    local colorscheme = metadata.colorscheme or fallback_colorscheme
    local ok = pcall(vim.cmd.colorscheme, colorscheme)

    if not ok and colorscheme ~= fallback_colorscheme then
        vim.notify("Unable to apply Omarchy colorscheme: " .. colorscheme, vim.log.levels.WARN)
        vim.cmd.colorscheme(fallback_colorscheme)
    end
end

return M
