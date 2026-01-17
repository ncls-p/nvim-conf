local M = {}

local themes = {
  dark = "tokyonight-moon",
  light = "tokyonight-day",
}

local theme_file = vim.fn.stdpath("data") .. "/theme.txt"

local function read_theme()
  local ok, lines = pcall(vim.fn.readfile, theme_file)
  if ok and type(lines) == "table" and lines[1] then
    return lines[1]
  end
end

local function write_theme(name)
  pcall(vim.fn.writefile, { name }, theme_file)
end

function M.set(name)
  vim.o.background = name == themes.light and "light" or "dark"

  local ok = pcall(vim.cmd.colorscheme, name)
  if not ok then
    if name ~= themes.dark then
      vim.o.background = "dark"
      pcall(vim.cmd.colorscheme, themes.dark)
      name = themes.dark
    end
  end

  M.current = name
  write_theme(name)
end

function M.load()
  local saved = read_theme()
  if saved == themes.light or saved == themes.dark then
    M.set(saved)
  else
    M.set(themes.dark)
  end
end

function M.toggle()
  local current = M.current or read_theme() or themes.dark
  if current == themes.dark then
    M.set(themes.light)
  else
    M.set(themes.dark)
  end
end

return M
