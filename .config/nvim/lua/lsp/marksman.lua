return {
	cmd = { "marksman", "server" },
	-- `:checkhealth vimlsp`
	-- - ⚠️ WARNING Unknown filetype 'md' (Hint: filename extension != filetype).
	-- TODO: Should I remove "md"?
	filetypes = { "markdown", "md" },
	single_file_support = true,
	settings = {},
}
