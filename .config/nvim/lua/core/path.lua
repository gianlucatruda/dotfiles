local M = {}

-- Keep both ends visible so long paths stay identifiable.
function M.shorten_middle(path, max_width)
  if not path or path == '' or not max_width or max_width <= 0 then
    return path
  end

  if vim.fn.strdisplaywidth(path) <= max_width then
    return path
  end

  local sep = package.config:sub(1, 1)
  local parts = vim.split(path, sep, { plain = true, trimempty = true })
  if #parts <= 4 then
    return path
  end

  local function build(head, tail)
    local result = {}
    for i = 1, head do
      table.insert(result, parts[i])
    end
    table.insert(result, '...')
    for i = #parts - tail + 1, #parts do
      table.insert(result, parts[i])
    end
    return table.concat(result, sep)
  end

  for _, candidate in ipairs({ build(2, 2), build(1, 2), build(1, 1) }) do
    if vim.fn.strdisplaywidth(candidate) <= max_width then
      return candidate
    end
  end

  return '...' .. sep .. parts[#parts]
end

return M
