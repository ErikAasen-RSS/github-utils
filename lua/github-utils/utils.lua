local M = {}

function M.run_command(command)
  local handle = io.popen(command)

  if not handle then
    return ""
  end

  local str = handle:read("*a")

  handle:close()

  return str
end

function M.get_visual_selection_lines()
  local start_line = vim.api.nvim_buf_get_mark(0, "<")[1]
  local end_line = vim.api.nvim_buf_get_mark(0, ">")[1]

  return start_line, end_line
end

return M
