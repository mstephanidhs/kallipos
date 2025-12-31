-- Add figure title and license text to figure references (Pandoc 3.x compatible)

local stringify = pandoc.utils.stringify

function Note(el)
  -- only simple footnotes
  if #el.content ~= 1 then
    return nil
  end

  local ft = stringify(el.content[1])

  -- only @fig:... references
  if not ft:match("^@fig:") then
    return nil
  end

  local fn = ft:sub(6)
  local path = "figures/" .. fn .. ".md"

  local f = io.open(path, "r")
  if not f then
    io.stderr:write("footnote.lua: could not open " .. path .. "\n")
    return nil
  end

  local content = f:read("*a")
  f:close()

  local doc = pandoc.read(content, "markdown")

  local title = stringify(doc.meta.title or "")
  local license_text = stringify(doc.meta.license_text or "")

  local extra = ""
  if title ~= "" or license_text ~= "" then
    extra = " " .. title
    if license_text ~= "" then
      extra = extra .. " (" .. license_text .. ")"
    end
  end

  return pandoc.Note("Βλ. Εικόνα " .. fn .. extra)
end
