-- run "just watch" from project root

local stub = require("luassert.stub")
local spy = require("luassert.spy")

local github_util = require("github-util")
describe("github_util", function()
  it("gets http remote url", function()
    stub(os, "execute")
    local url = github_util.get_http_remote_url()
    assert.equal("https://github.com/ErikAasen-RSS/github-util", url)
  end)

  it("gets relative file path", function()
    stub(vim.api, "nvim_buf_get_name").returns("/RSS/plugins-custom/github-util/lua/github-util/init.test.lua")
    local relative_file_name = github_util.get_filepath_relative_to_repo_root()
    assert.equal("/lua/github-util/init.test.lua", relative_file_name)
  end)

  it("opens web client", function()
    stub(os, "execute")
    local execute = spy.on(os, "execute")
    github_util.open_web_client()
    assert.spy(execute).was.called_with("open https://github.com/ErikAasen-RSS/github-util")
  end)

  it("opens web client to file", function()
    stub(os, "execute")
    stub(vim.api, "nvim_buf_get_name").returns("/RSS/plugins-custom/github-util/lua/github-util/init.test.lua")
    local execute = spy.on(os, "execute")

    github_util.open_web_client_file()
    assert
        .spy(execute).was
        .called_with("open https://github.com/ErikAasen-RSS/github-util/blob/main/lua/github-util/init.test.lua")
  end)
end)
