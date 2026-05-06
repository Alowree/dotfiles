require("config.options")
require("config.keymaps")
require("config.session")
require("config.diagnostics")
require("config.autocmds")
require("config.lsp")
require("config.packui")
require("config.ui2")
-- Do I still need to require `writing` here?
-- since it's already been required in `mail.lua` and `markdown.lua`?
require("config.writing")
