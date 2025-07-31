-- Settings for Markdown files

-- Local settings
vim.opt_local.conceallevel = 0
vim.opt_local.spell = true
vim.opt_local.spelllang = { "en_us", "cjk" }
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.autoindent = true

-- Arrow abbreviations
local arrows = {
    [">>"] = "→",
    ["<<"] = "←",
    ["^^"] = "↑",
    ["VV"] = "↓",
    ["【【"] = "「",
    ["】】"] = "」",
    ["《《"] = "『",
    ["》》"] = "』",
}
for key, val in pairs(arrows) do
    vim.cmd(string.format("iabbrev <buffer> %s %s", key, val))
end

-- Abbreviations
local abbreviations = {
    ["btw"] = "By the way,",
    ["fyi"] = "For your information ——",
    ["asap"] = "as soon as possible.",
    ["fedex"] = "FedEx",
    ["dhl"] = "DHL",
    ["ndl"] = "Nolan Digital Limited",
    ["tcl"] = "Twine Company Limited",
}
for key, val in pairs(abbreviations) do
    vim.cmd(string.format("iabbrev <buffer> %s %s", key, val))
end

-- Handle code blocks
local function MarkdownCodeBlock(outside)
    vim.cmd("call search('```', 'cb')")
    vim.cmd(outside and "normal! Vo" or "normal! j0Vo")
    vim.cmd("call search('```')")
    if not outside then
        vim.cmd("normal! k")
    end
end

-- Set keymaps
local function set_keymaps()
    -- Code block text objects
    for _, mode in ipairs({ "o", "x" }) do
        for _, mapping in ipairs({
            { "am", true },
            { "im", false },
        }) do
            vim.keymap.set(mode, mapping[1], function()
                MarkdownCodeCodeBlock(mapping[2])
            end, { buffer = true, desc = "Around markdown code block" })
        end
    end
end

pcall(function()
    vim.keymap.del("n", "]c", { buffer = true })
end)
set_keymaps()
