-- excel-preview.yazi plugin - Preview .xlsx, .xls, .csv, and .tsv files
local M = {}

local function get_file_path(file)
	return tostring(file.path or file.cache or file.url.path or file.url)
end

function M:peek(job)
	local file_path = get_file_path(job.file)
	local ext = file_path:match("^.+%.([a-zA-Z0-9]+)$")
	if ext then ext = ext:lower() end

	local output, err
	if ext == "csv" or ext == "tsv" then
		-- For CSV/TSV, use column directly for fast preview
		local sep = ext == "csv" and "," or "\t"
		output, err = Command("column")
			:arg({ "-s" .. sep, "-t", file_path })
			:stdout(Command.PIPED)
			:stderr(Command.PIPED)
			:output()
	elseif ext == "xls" or ext == "xlsx" or ext == "ods" then
		-- Use LibreOffice (soffice) as a universal converter for .xls, .xlsx, and .ods
		-- Convert to CSV in a temporary directory and read it
		output, err = Command("sh")
			:arg({
				"-c",
				[[
					tmpdir=$(mktemp -d)
					soffice --headless --convert-to csv --outdir "$tmpdir" "$1" > /dev/null 2>&1
					csv_file="$tmpdir/$(basename "${1%.*}").csv"
					if [ -f "$csv_file" ]; then
						head -n 100 "$csv_file" | column -s, -t
					fi
					rm -rf "$tmpdir"
				]],
				"X",
				file_path,
			})
			:stdout(Command.PIPED)
			:stderr(Command.PIPED)
			:output()
	end
	
	if err then
		ya.preview_widget(
			job,
			ui.Text({
				ui.Line({ ui.Span("Table Preview Error"):style(ui.Style():fg("red"):bold()) }),
				ui.Line({}),
				ui.Line({ ui.Span("Failed to run preview tool: " .. tostring(err)):style(ui.Style():fg("yellow")) }),
			}):area(job.area):wrap(ui.Wrap.YES)
		)
		return
	end

	if not output or not output.status.success then
		local stderr = output and output.stderr or "no output"
		ya.preview_widget(
			job,
			ui.Text({
				ui.Line({ ui.Span("Table Preview Error"):style(ui.Style():fg("red"):bold()) }),
				ui.Line({}),
				ui.Line({ ui.Span("Preview exited with error:"):style(ui.Style():fg("yellow")) }),
				ui.Line({ ui.Span(stderr):style(ui.Style():fg("blue")) }),
			}):area(job.area):wrap(ui.Wrap.YES)
		)
		return
	end

	local text = output.stdout or ""
	if text == "" then
		ya.preview_widget(
			job,
			ui.Text({
				ui.Line({ ui.Span("No content found"):style(ui.Style():fg("yellow")) }),
			}):area(job.area)
		)
		return
	end

	-- Split text into lines
	local lines = {}
	for line in text:gmatch("[^\r\n]+") do
		table.insert(lines, ui.Line({ ui.Span(line) }))
	end

	-- Handle pagination
	local skip = job.skip or 0
	local limit = job.area.h
	local start_idx = skip + 1
	local end_idx = math.min(start_idx + limit - 1, #lines)

	local page_lines = {}
	for i = start_idx, end_idx do
		table.insert(page_lines, lines[i])
	end

	ya.preview_widget(job, ui.Text(page_lines):area(job.area):wrap(ui.Wrap.NO))
end

function M:seek(job)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		ya.emit("peek", {
			math.max(0, cx.active.preview.skip + job.units),
			only_if = job.file.url,
		})
	end
end

return M
