local M = {}

local utils = require("github-utils.utils")

function M.get_remote_url(remote_name)
  return utils.run_command(string.format("git remote get-url %s", remote_name or "origin"))
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
  local repo_path = utils.run_command("git rev-parse --show-toplevel")

  local repoLength = string.len(repo_path)

  local buffer_path = vim.api.nvim_buf_get_name(0)
  local relative_file_name = string.sub(buffer_path, repoLength, string.len(buffer_path))

  return relative_file_name
end

function M.get_git_branch()
  local branches = utils.run_command("git branch -vv")

  local after_asterisk = string.match(branches, "%*(.*)")
  local remote_branch = after_asterisk:match("/(.-)[%]:]")

  return remote_branch
end

function M.open_web_client_file(remote_name)
  local url = M.get_http_remote_url(remote_name)

  local branch = M.get_git_branch()
  local filepath = M.get_filepath_relative_to_repo_root()

  local cmd = string.format("open %s/blob/%s%s", url, branch, filepath)

  os.execute(cmd)
end

function M.get_commit_hash()
  local commit_hash = utils.run_command("git rev-parse HEAD")

  commit_hash = string.gsub(commit_hash, "\n", "")

  return commit_hash
end

function M.create_permalink(remote_name)
  local url = M.get_http_remote_url(remote_name)
  local commit_hash = M.get_commit_hash()
  local filepath = M.get_filepath_relative_to_repo_root()
  local current_line, current_col = unpack(vim.api.nvim_win_get_cursor(0))

  local permalink = string.format("%s/blob/%s%s#L%s", url, commit_hash, filepath, current_line)
  local register_name = "+"

  vim.fn.setreg(register_name, permalink)
end

function M.create_permalink_multiline(remote_name)
  local url = M.get_http_remote_url(remote_name)
  local commit_hash = M.get_commit_hash()
  local filepath = M.get_filepath_relative_to_repo_root()

  local start_line, end_line = utils.get_visual_selection_lines()

  local permalink = string.format("%s/blob/%s%s#L%s-%s", url, commit_hash, filepath, start_line, end_line)
  local register_name = "+"

  vim.fn.setreg(register_name, permalink)
end

return M
