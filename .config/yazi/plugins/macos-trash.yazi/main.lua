local toggle_ui = ya.sync(function(st)
  if st.children then
    Modal:children_remove(st.children)
    st.children = nil
  else
    st.children = Modal:children_add(st, 10)
  end
  ui.render()
end)

local update_items = ya.sync(function(st, items)
  local selected = st.selected or {}
  local next_selected = {}
  for _, item in ipairs(items or {}) do
    if selected[item.id] then next_selected[item.id] = true end
  end
  st.items = items
  st.selected = next_selected
  st.cursor = math.max(0, math.min(st.cursor or 0, #st.items - 1))
  ui.render()
end)

local reset_items = ya.sync(function(st, items)
  st.items = items or {}
  st.selected = {}
  st.cursor = math.max(0, math.min(st.cursor or 0, #st.items - 1))
  ui.render()
end)

local update_cursor = ya.sync(function(st, step)
  if not st.items or #st.items == 0 then
    st.cursor = 0
  else
    st.cursor = ya.clamp(0, st.cursor + step, #st.items - 1)
  end
  ui.render()
end)

local get_active_item = ya.sync(function(st)
  return st.items and st.items[(st.cursor or 0) + 1]
end)

local get_visible_items = ya.sync(function(st)
  return st.items or {}
end)

local toggle_selected = ya.sync(function(st)
  local item = st.items and st.items[(st.cursor or 0) + 1]
  if not item then return 0 end

  st.selected = st.selected or {}
  if st.selected[item.id] then
    st.selected[item.id] = nil
  else
    st.selected[item.id] = true
  end

  local count = 0
  for _ in pairs(st.selected) do
    count = count + 1
  end

  ui.render()
  return count
end)

local set_selected_ids = ya.sync(function(st, ids)
  st.selected = {}
  for _, id in ipairs(ids or {}) do
    st.selected[id] = true
  end

  local count = 0
  for _ in pairs(st.selected) do
    count = count + 1
  end

  ui.render()
  return count
end)

local get_target_items = ya.sync(function(st)
  local selected = st.selected or {}
  local items = {}
  for _, item in ipairs(st.items or {}) do
    if selected[item.id] then
      items[#items + 1] = item
    end
  end

  if #items > 0 then return items end

  local current = st.items and st.items[(st.cursor or 0) + 1]
  return current and { current } or {}
end)

local function run_trash(args)
  return Command("trash"):arg(args):output()
end

local function restore_item(path)
  return Command("sh")
      :arg({ "-c", 'echo "0" | trash restore "$1"', "--", path })
      :output()
end

local function empty_trash(days)
  if days then
    return Command("sh")
        :arg({ "-c", 'echo "y" | trash empty "$1"', "--", tostring(days) })
        :output()
  end

  return Command("sh")
      :arg({ "-c", 'echo "y" | trash empty' })
      :output()
end

local function display_path(path)
  return (path or ""):gsub("^/System/Volumes/Data", "")
end

local function prompt_value(title, default_value)
  local value, event = ya.input({
    title = title,
    value = default_value or "",
    pos = { "center", y = 3, w = 60 },
  })
  if event ~= 1 then return nil end
  return value
end

local function parse_deleted_time(date, time)
  local year, month, day = date:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
  local hour, min, sec = time:match("^(%d%d):(%d%d):(%d%d)$")
  if not year then return nil end

  return os.time({
    year = tonumber(year),
    month = tonumber(month),
    day = tonumber(day),
    hour = tonumber(hour),
    min = tonumber(min),
    sec = tonumber(sec),
  })
end

local M = {
  keys = {
    { on = "q",      run = "quit" },
    { on = "<Esc>",  run = "quit" },
    { on = "k",      run = "up" },
    { on = "<Up>",   run = "up" },
    { on = "j",      run = "down" },
    { on = "<Down>", run = "down" },
    { on = "<Space>", run = "toggle_select" },
    { on = "r",      run = "restore" },
    { on = "d",      run = "purge" },
    { on = "D",      run = "mark_days" },
    { on = "E",      run = "empty" },
  },
}

function M:new(area)
  self:layout(area)
  return self
end

function M:layout(area)
  local chunks = ui.Layout()
      :direction(ui.Layout.VERTICAL)
      :constraints({
        ui.Constraint.Percentage(12),
        ui.Constraint.Percentage(76),
        ui.Constraint.Percentage(12),
      })
      :split(area)

  local hchunks = ui.Layout()
      :direction(ui.Layout.HORIZONTAL)
      :constraints({
        ui.Constraint.Percentage(5),
        ui.Constraint.Percentage(90),
        ui.Constraint.Percentage(5),
      })
      :split(chunks[2])

  self._area = hchunks[2]
end

function M:redraw()
  if not self._area then return {} end
  local count = #(self.items or {})
  local selected = self.selected or {}
  local marked = 0
  for _ in pairs(selected) do
    marked = marked + 1
  end

  local title = string.format(
    "r Restore   d Delete   D Mark by Days   E Empty",
    marked
  )

  local rows = {}
  for i, item in ipairs(self.items or {}) do
    local mark = selected[item.id] and "|" or " "
    rows[i] = ui.Row {
      mark,
      item.name,
      item.drive,
      item.date .. " " .. item.time,
      item.display_path or item.path,
    }
  end

  return {
    ui.Clear(self._area),
    ui.Border(ui.Edge.ALL)
        :area(self._area)
        :type(ui.Border.ROUNDED)
        :style(ui.Style():fg("blue"))
        :title(ui.Line(title):align(ui.Align.CENTER)),
    ui.Table(rows)
        :area(self._area:pad(ui.Pad(1, 2, 1, 2)))
        :header(ui.Row({ "", "Name (" .. count .. ")", "Drive", "Deleted At", "Original Path" }):style(ui.Style():bold()))
        :row(self.cursor)
        :row_style(ui.Style():fg("cyan"):underline())
        :widths {
          ui.Constraint.Percentage(2),
          ui.Constraint.Percentage(18),
          ui.Constraint.Percentage(15),
          ui.Constraint.Percentage(20),
          ui.Constraint.Percentage(45),
        },
  }
end

function M:reflow() return { self } end

function M:click() end

function M:scroll() end

function M:touch() end

function M.obtain()
  local output, err = run_trash({ "list" })
  if err or not output or not output.status.success then
    ya.notify {
      title = "macOS Trash",
      content = "trash list failed: " .. (err or "unknown"),
      timeout = 5,
      level = "error",
    }
    return {}
  end

  local items = {}
  for line in output.stdout:gmatch("[^\r\n]+") do
    local date, time, path = line:match("^(%d%d%d%d%-%d%d%-%d%d) (%d%d:%d%d:%d%d) (.+)$")
    if date and path then
      local shown_path = display_path(path)
      local drive = "Home"
      local m = shown_path:match("^/run/media/[^/]+/([^/]+)")
          or shown_path:match("^/mnt/([^/]+)")
          or shown_path:match("^/Volumes/([^/]+)")
      if m then drive = m end
      local name = shown_path:match("([^/]+)$") or shown_path
      local id = table.concat({ date, time, path }, "\0")
      table.insert(items, {
        id = id,
        name = name,
        drive = drive,
        path = path,
        display_path = shown_path,
        date = date,
        time = time,
        deleted_time = parse_deleted_time(date, time),
      })
    end
  end
  table.sort(items, function(a, b) return (a.date .. a.time) > (b.date .. b.time) end)
  return items
end

function M:entry(job)
  local output, err = Command("trash"):arg("--version"):output()
  if not output or not output.status.success then
    return ya.notify {
      title = "macOS Trash",
      content = "trash cli not found. Please install it to use this plugin.",
      timeout = 5,
      level = "error",
    }
  end

  toggle_ui()
  reset_items(self.obtain())

  while true do
    local key_idx = ya.which { cands = self.keys, silent = true }
    if not key_idx then break end
    local run = self.keys[key_idx].run
    if run == "quit" then
      break
    elseif run == "up" then
      update_cursor(-1)
    elseif run == "down" then
      update_cursor(1)
    elseif run == "toggle_select" then
      toggle_selected()
    elseif run == "restore" then
      local items = get_target_items()
      if #items > 0 then
        local restored = 0
        local failed = 0
        local last_err = nil
        for _, item in ipairs(items) do
          local out, err = restore_item(item.path)
          if out and out.status.success then
            restored = restored + 1
          else
            failed = failed + 1
            last_err = err or "unknown"
          end
        end

        update_items(self.obtain())

        if failed == 0 then
          if restored == 1 then
            ya.notify { title = "macOS Trash", content = "Restored: " .. items[1].name, timeout = 3 }
          else
            ya.notify {
              title = "macOS Trash",
              content = string.format("Restored %d item(s)", restored),
              timeout = 3,
            }
          end
        else
          ya.notify {
            title = "macOS Trash",
            content = string.format("Restored %d, failed %d: %s", restored, failed, last_err),
            timeout = 5,
            level = "error",
          }
        end
      end
    elseif run == "purge" then
      local items = get_target_items()
      if #items > 0 then
        local label = #items == 1
            and string.format("Purge '%s' [%s]? (cannot be undone)", items[1].name, items[1].drive)
            or string.format("Purge %d marked item(s)? (cannot be undone)", #items)

        local ok = ya.which {
          title = label,
          cands = {
            { on = "y", desc = "Yes, delete permanently" },
            { on = "n", desc = "No, cancel" },
          },
        }
        if ok == 1 then
          local purged = 0
          local failed = 0
          local last_err = nil
          for _, item in ipairs(items) do
            local out, err = run_trash({ "rm", item.path })
            if out and out.status.success then
              purged = purged + 1
            else
              failed = failed + 1
              last_err = err or "unknown"
            end
          end

          update_items(self.obtain())

          if failed == 0 then
            if purged == 1 then
              ya.notify { title = "macOS Trash", content = "Purged: " .. items[1].name, timeout = 3 }
            else
              ya.notify {
                title = "macOS Trash",
                content = string.format("Purged %d item(s)", purged),
                timeout = 3,
              }
            end
          else
            ya.notify {
              title = "macOS Trash",
              content = string.format("Purged %d, failed %d: %s", purged, failed, last_err),
              timeout = 5,
              level = "error",
            }
          end
        end
      end
    elseif run == "mark_days" then
      local raw_days = prompt_value("Delete trash items older than (days)", "30")
      if not raw_days then
        ya.notify { title = "macOS Trash", content = "Empty by days cancelled", timeout = 3 }
      else
        local days = tonumber(raw_days)
        if not days or days <= 0 or math.floor(days) ~= days then
          ya.notify {
            title = "macOS Trash",
            content = "Invalid input: please enter a positive integer",
            timeout = 5,
            level = "error",
          }
        else
          local cutoff = os.time() - (days * 24 * 60 * 60)
          local marked_ids = {}
          for _, listed in ipairs(get_visible_items()) do
            if listed.deleted_time and listed.deleted_time < cutoff then
              marked_ids[#marked_ids + 1] = listed.id
            end
          end

          if #marked_ids == 0 then
            ya.notify {
              title = "macOS Trash",
              content = string.format("No items found that are older than %d days", days),
              timeout = 4,
            }
          else
            local marked = set_selected_ids(marked_ids)
            ya.notify {
              title = "macOS Trash",
              content = string.format("Marked %d item(s) older than %d days", marked, days),
              timeout = 4,
            }
          end
        end
      end
    elseif run == "empty" then
      local ok = ya.which {
        title = "Empty ALL trash across all drives? (cannot be undone)",
        cands = {
          { on = "y", desc = "Yes, delete everything" },
          { on = "n", desc = "No, cancel" },
        },
      }
      if ok == 1 then
        local out, err = empty_trash()
        if out and out.status.success then
          ya.notify { title = "macOS Trash", content = "All trash cleared.", timeout = 3 }
          update_items(self.obtain())
        else
          ya.notify { title = "macOS Trash", content = "Empty failed: " .. (err or "unknown"), timeout = 5, level = "error" }
        end
      end
    end
  end

  toggle_ui()
end

return M
