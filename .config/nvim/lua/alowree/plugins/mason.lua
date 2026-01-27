-- Install Mason as LSP manager only
return {
	"mason-org/mason.nvim",
	event = { "BufReadPost", "BufNewFile", "VimEnter" },
	opts = {},
}
