-- run "just watch" from project root

local stub = require("luassert.stub")
local spy = require("luassert.spy")

local github_utils = require("github-utils")
describe("github_utils", function()
  stub(vim.api, "nvim_buf_get_name").returns("/xxxxx/xxxxxxx/RSS/plugins-custom/github-utils/lua/github-utils/init.test.lua")

  it("gets http remote url", function()
    stub(os, "execute")
    local url = github_utils.get_http_remote_url()
    assert.equal("https://github.com/ErikAasen-RSS/github-utils", url)
  end)

  it("gets relative file path", function()
    local relative_file_name = github_utils.get_filepath_relative_to_repo_root()
    assert.equal("/lua/github-utils/init.test.lua", relative_file_name)
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
        .called_with("open https://github.com/ErikAasen-RSS/github-utils/blob/main/lua/github-utils/init.test.lua")
  end)

  -- it("opens web client to filenumber permalink", function()
  --   stub(os, "execute")
  --   stub(vim.api, "nvim_buf_get_name").returns("/RSS/plugins-custom/github-utils/lua/github-utils/init.test.lua")
  --   local execute = spy.on(os, "execute")
  --
  -- end)
end)
