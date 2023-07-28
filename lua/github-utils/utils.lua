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

return M
