return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set header
		dashboard.section.header.val = {
			"                                                                                       ",
			" ███████╗ ██████╗ ██╗   ██╗███╗   ██╗██████╗ ███████╗██████╗ ███████╗ █████╗  ██████╗  ",
			" ██╔════╝██╔═══██╗██║   ██║████╗  ██║██╔══██╗██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗ ",
			" ███████╗██║   ██║██║   ██║██╔██╗ ██║██║  ██║█████╗  ██████╔╝█████╗  ███████║██║   ██║ ",
			" ╚════██║██║   ██║██║   ██║██║╚██╗██║██║  ██║██╔══╝  ██╔══██╗██╔══╝  ██╔══██║██║▄▄ ██║ ",
			" ███████║╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝██║     ██║  ██║███████╗██║  ██║╚██████╔╝ ",
			" ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚══▀▀═╝  ",
			"                                                                                       ",
		}

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
			dashboard.button("Space ee", "  > Toggle Sidebar", "<cmd>NvimTreeToggle<CR>"),
			dashboard.button("Space ff", "󰱼  > Find File", "<cmd>FzfLua files<CR>"),
			dashboard.button("Space fg", "  > Find Word", "<cmd>FzfLua live_grep<CR>"),
			dashboard.button("Space wr", "󰁯  > Restore Session", "<cmd>SessionRestore<CR>"),
			dashboard.button("q", "  > Quit NeoVim", "<cmd>qa<CR>"),
		}

		-- Randomly selects one quote each time Neovim starts
		local function footer()
			local quotes = {
				"The only way to do great work is to love what you do. – Steve Jobs",
				"Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
				"It always seems impossible until it's done. – Nelson Mandela",
				"Do what you can, with what you have, where you are. – Theodore Roosevelt",
				"Believe you can and you're halfway there. – Theodore Roosevelt",
				"Happiness depends upon ourselves. – Aristotle",
				"Don't cry because it's over, smile because it happened. – Dr. Seuss",
				"You must be the change you wish to see in the world. – Mahatma Gandhi",
				"Opportunities don't happen. You create them. – Chris Grosser",
				"Do what you love and success will follow. – Richard Branson",
				"Don't Stop Until You are Proud...",
			}
			return quotes[math.random(#quotes)]
		end

		dashboard.section.footer.val = footer()

		-- custom styling
		dashboard.section.footer.opts.hl = "Type"
		dashboard.section.header.opts.hl = "Include"
		dashboard.section.buttons.opts.hl = "Keyword"

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
