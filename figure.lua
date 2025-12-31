--Pandoc Lua function adds caption and formats an image according to the standard markdown format
--It reads the image caption and location from a yaml file located in the figures folder
--It expects to find an (over)loaded Pandoc image tag with figure class and filename
-- Pandoc Lua filter for figures (Pandoc 3.x compatible)

local stringify = pandoc.utils.stringify

function Image(img)
  -- check class properly
  if not img.classes:includes('figure') then
    return nil
  end

  local fn = img.src
  local path = "figures/" .. fn

  local f = io.open(path, 'r')
  if not f then
    io.stderr:write("figure.lua: could not open " .. path .. "\n")
    return nil
  end

  local content = f:read('*a')
  f:close()

  local doc = pandoc.read(content, 'markdown')

  local figid = fn:gsub("%.%w+$", "")

  local src = stringify(doc.meta.image_url or "")
  if src ~= "" then
    src = ".." .. src
  end

  local caption = stringify(doc.meta.caption or "")

  if not src or src:match("%.md$") then
    io.stderr:write("figure.lua: skipping invalid figure " .. fn .. "\n")
    return nil
  end


  return pandoc.Image(
    caption,
    src,
    nil,
    { id = "fig:" .. figid }
  )
end


