local groups = {
    "Normal",
    "NormalFloat",
    "FloatBorder",
    "Pmenu",
    "Terminal",
    "EndOfBuffer",
    "FoldColumn",
    "Folded",
    "SignColumn",
    "LineNr",
    "CursorLineNr",
    "NormalNC",
    "WhichKeyFloat",
    "TelescopeBorder",
    "TelescopeNormal",
    "TelescopePromptBorder",
    "TelescopePromptTitle",
    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "NeoTreeVertSplit",
    "NeoTreeWinSeparator",
    "NeoTreeEndOfBuffer",
    "NvimTreeNormal",
    "NvimTreeVertSplit",
    "NvimTreeEndOfBuffer",
    "NotifyINFOBody",
    "NotifyERRORBody",
    "NotifyWARNBody",
    "NotifyTRACEBody",
    "NotifyDEBUGBody",
    "NotifyINFOTitle",
    "NotifyERRORTitle",
    "NotifyWARNTitle",
    "NotifyTRACETitle",
    "NotifyDEBUGTitle",
    "NotifyINFOBorder",
    "NotifyERRORBorder",
    "NotifyWARNBorder",
    "NotifyTRACEBorder",
    "NotifyDEBUGBorder",
}

local function make_transparent(name)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if ok then
        hl.bg = nil
        vim.api.nvim_set_hl(0, name, hl)
    end
end

local function apply_transparency()
    for _, name in ipairs(groups) do
        make_transparent(name)
    end
end

apply_transparency()

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.schedule(apply_transparency)
    end,
})
