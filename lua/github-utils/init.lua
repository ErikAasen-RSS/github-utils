local M = {}

function M.get_remote_url(remote_name)
  local handle = io.popen(string.format("git remote get-url %s", remote_name or "origin"))

  if not handle then
    return
  end

  local remote_url = handle:read("*a")
  handle:close()

  return remote_url
end

function M.get_http_remote_url(remote_name)
  local remote_url = M.get_remote_url(remote_name)

  if not remote_url then
    return
  end

  local url = string.gsub(remote_url, "%.git", "")

  -- Convert SSH url into HTTP url
  if string.find(url, "git@") then
    url = string.gsub(url, "git@", "")
    url = string.gsub(url, ":", "/")
    url = string.gsub(url, "\n", "")
    url = "https://" .. url
  end

  return url
end

function M.open_web_client(remote_name)
  local url = M.get_http_remote_url(remote_name)

  local cmd = string.format("open %s", url)

  os.execute(cmd)
end

function M.get_filepath_relative_to_repo_root()
  local handle = io.popen("git rev-parse --show-toplevel")

  if not handle then
    return
  end

  local repo_path = handle:read("*a")
  handle:close()

  local repoLength = string.len(repo_path)

  local buffer_path = vim.api.nvim_buf_get_name(0)
  local relative_file_name = string.sub(buffer_path, repoLength, string.len(buffer_path))

  return relative_file_name
end

function M.get_git_branch()
  local branch = io.popen(string.format("git branch"))

  if not branch then
    return
  end

  local gitBranch = branch:read("*l")
  gitBranch = string.gsub(gitBranch, "*", "")
  gitBranch = string.gsub(gitBranch, "%s", "")

  branch:close()

  return gitBranch
end

function M.open_web_client_file(remote_name)
  local url = M.get_http_remote_url(remote_name)

  local cmd = string.format("open %s/blob/%s%s", url, M.get_git_branch(), M.get_filepath_relative_to_repo_root())

  os.execute(cmd)
end

function M.get_commit_hash()
  local handle = io.popen("git rev-parse HEAD")

  if not handle then
    return
  end

  local commit_hash = handle:read("*a")
  handle:close()

  commit_hash = string.gsub(commit_hash, "\n", "")

  return commit_hash
end

function M.create_permalink()
  local url = M.get_http_remote_url(remote_name)
  local commit_hash = M.get_commit_hash()
  local filepath = M.get_filepath_relative_to_repo_root()
  local current_line, current_col = unpack(vim.api.nvim_win_get_cursor(0))

  local permalink = string.format("%s/blob/%s%s#L%s", url, commit_hash, filepath, current_line)
  local register_name = "+"

  vim.api.nvim_call_function("setreg", { register_name, permalink })

end

return M
