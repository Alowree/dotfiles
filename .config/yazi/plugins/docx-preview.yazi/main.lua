-- doc-preview.yazi plugin - Preview .docx and .doc files
local M = {}

local function get_file_path(file)
	return tostring(file.path or file.cache or file.url.path or file.url)
end

-- Extract plain text from .pptx/.ppt files using python3
-- (pptx is a ZIP of XML slides; pandoc doesn't support pptx input)
local function extract_pptx_text(file_path)
	local script = [[
import zipfile, re, sys
with zipfile.ZipFile(sys.argv[1]) as z:
    for name in sorted(z.namelist()):
        if re.match(r'ppt/slides/slide\d+\.xml$', name):
            content = z.read(name).decode('utf-8')
            text = re.sub(r'<[^>]+>', ' ', content)
            text = re.sub(r'\s+', ' ', text).strip()
            if text:
                print(text)
                print()
]]
	local output, err = Command("python3")
		:arg({ "-c", script, file_path })
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()
	return output, err
end

function M:peek(job)
	local file_path = get_file_path(job.file)
	local ext = file_path:match("^.+%.([a-zA-Z0-9]+)$")
	if ext then ext = ext:lower() end

	local output, err
	local is_pptx = ext == "pptx" or ext == "ppt"

	if ext == "doc" then
		-- Use antiword for legacy .doc files
		output, err = Command("antiword")
			:arg({ file_path })
			:stdout(Command.PIPED)
			:stderr(Command.PIPED)
			:output()
	elseif is_pptx then
		-- Extract text from .pptx/.ppt via python3 (pandoc doesn't support pptx)
		output, err = extract_pptx_text(file_path)
	else
		-- Use pandoc for .docx files
		output, err = Command("pandoc")
			:arg({ "-t", "plain", "--wrap=auto", "--columns=100", file_path })
			:stdout(Command.PIPED)
			:stderr(Command.PIPED)
			:output()
	end

	local cmd = is_pptx and "python3-pptx-extract" or (ext == "doc" and "antiword" or "pandoc")

	if err then
		ya.preview_widget(
			job,
			ui.Text({
				ui.Line({ ui.Span("Doc Preview Error"):style(ui.Style():fg("red"):bold()) }),
				ui.Line({}),
				ui.Line({ ui.Span(cmd .. " command failed: " .. tostring(err)):style(ui.Style():fg("yellow")) }),
			}):area(job.area):wrap(ui.Wrap.YES)
		)
		return
	end

	if not output or not output.status.success then
		local stderr = output and output.stderr or "no output"
		ya.preview_widget(
			job,
			ui.Text({
				ui.Line({ ui.Span("Doc Preview Error"):style(ui.Style():fg("red"):bold()) }),
				ui.Line({}),
				ui.Line({ ui.Span(cmd .. " exited with error:"):style(ui.Style():fg("yellow")) }),
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
				ui.Line({ ui.Span("No text content found"):style(ui.Style():fg("yellow")) }),
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

	ya.preview_widget(job, ui.Text(page_lines):area(job.area):wrap(ui.Wrap.YES))
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
