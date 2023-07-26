-- run "just watch" from project root

local stub = require("luassert.stub")
local spy = require("luassert.spy")

local github_utils = require("github-utils")
describe("github_utils", function()
  before_each(function()
    vim.cmd.e("./lua/github-utils/test-file.lua")
  end)
  after_each(function()
    vim.cmd.bd("./lua/github-utils/test-file.lua")
  end)

  it("gets http remote url", function()
    stub(os, "execute")
    local url = github_utils.get_http_remote_url()
    assert.equal("https://github.com/ErikAasen-RSS/github-utils", url)
  end)

  it("gets relative file path", function()
    local relative_file_name = github_utils.get_filepath_relative_to_repo_root()
    assert.equal("/lua/github-utils/test-file.lua", relative_file_name)
  end)

  it("opens web client", function()
    stub(os, "execute")
    local execute = spy.on(os, "execute")
    github_utils.open_web_client()
    assert.spy(execute).was.called_with("open https://github.com/ErikAasen-RSS/github-utils")
  end)

  it("opens web client to file", function()
    stub(os, "execute")
    local execute = spy.on(os, "execute")

    github_utils.open_web_client_file()
    assert
        .spy(execute).was
        .called_with("open https://github.com/ErikAasen-RSS/github-utils/blob/main/lua/github-utils/test-file.lua")
  end)

  it("creates filenumber permalink", function()
    stub(os, "execute")
    stub(github_utils, "get_commit_hash").returns("135726a7fe0cb9f457a324e68b5c3e00fb8c0a5e")

    local execute = spy.on(os, "execute")

    local current_line, current_col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_win_set_cursor(0, { current_line + 3, current_col })

    github_utils.create_permalink()

    local register_value = vim.api.nvim_call_function("getreg", {"+"})

    assert.equal(
      "https://github.com/ErikAasen-RSS/github-utils/blob/135726a7fe0cb9f457a324e68b5c3e00fb8c0a5e/lua/github-utils/test-file.lua#L4",
      register_value
    )
  end)
end)
