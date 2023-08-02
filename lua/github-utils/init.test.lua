-- run "just watch" from project root

local stub = require("luassert.stub")
local spy = require("luassert.spy")

local github_utils = require("github-utils")
local utils = require("github-utils.utils")

describe("github_utils", function()
  local snapshot

  before_each(function()
    vim.cmd.e("./lua/github-utils/test-file.lua")
    snapshot = assert:snapshot()
  end)
  after_each(function()
    vim.cmd.bd("./lua/github-utils/test-file.lua")
    snapshot:revert()
  end)

  it("gets http remote url", function()
    stub(os, "execute")
    local url = github_utils.get_http_remote_url()
    assert.equal("https://github.com/ErikAasen-RSS/github-utils.nvim", url)
  end)

  it("gets relative file path", function()
    local relative_file_name = github_utils.get_filepath_relative_to_repo_root()
    assert.equal("/lua/github-utils/test-file.lua", relative_file_name)
  end)

  it("opens web client", function()
    stub(os, "execute")
    local execute = spy.on(os, "execute")
    github_utils.open_web_client()
    assert.spy(execute).was.called_with("open https://github.com/ErikAasen-RSS/github-utils.nvim")
  end)

  it("opens web client to file", function()
    stub(os, "execute")
    stub(github_utils, "get_git_branch").returns("main")
    local execute = spy.on(os, "execute")

    github_utils.open_web_client_file()
    assert
        .spy(execute).was
        .called_with("open https://github.com/ErikAasen-RSS/github-utils.nvim/blob/main/lua/github-utils/test-file.lua")
  end)

  describe("creates filenumber permalink", function()
    it("one line", function()
      stub(os, "execute")
      stub(github_utils, "get_commit_hash").returns("135726a7fe0cb9f457a324e68b5c3e00fb8c0a5e")

      vim.api.nvim_win_set_cursor(0, { 2, 0 })

      github_utils.create_permalink()

      local register_value = vim.fn.getreg("+")

      assert.equal(
        "https://github.com/ErikAasen-RSS/github-utils.nvim/blob/135726a7fe0cb9f457a324e68b5c3e00fb8c0a5e/lua/github-utils/test-file.lua#L2",
        register_value
      )
    end)

    it("multi line", function()
      stub(os, "execute")
      stub(github_utils, "get_commit_hash").returns("135726a7fe0cb9f457a324e68b5c3e00fb8c0a5e")
      stub(utils, "get_visual_selection_lines").returns(2, 4)

      github_utils.create_permalink_multiline()

      local register_value = vim.fn.getreg("+")

      assert.equal(
        "https://github.com/ErikAasen-RSS/github-utils.nvim/blob/135726a7fe0cb9f457a324e68b5c3e00fb8c0a5e/lua/github-utils/test-file.lua#L2-4",
        register_value
      )
    end)
  end)

  describe("gets current branch", function()
    it("has one word", function()
      stub(utils, "run_command").returns(
        "  main cd4faa4 [origin/main] feat: testing \n* test a95c385 [origin/random] wip \n"
      )

      local branch = github_utils.get_git_branch()
      assert.equal("random", branch)
    end)

    it("has hyphen", function()
      stub(utils, "run_command").returns(
        "  main cd4faa4 [origin/main] feat: testing \n* test a95c385 [origin/random-branch] wip \n"
      )

      local branch = github_utils.get_git_branch()
      assert.equal("random-branch", branch)
    end)

    it("has underscore", function()
      stub(utils, "run_command").returns(
        "  main cd4faa4 [origin/main] feat: testing \n* test a95c385 [origin/random_branch] wip \n"
      )

      local branch = github_utils.get_git_branch()
      assert.equal("random_branch", branch)
    end)

    it("has hyphen and underscore", function()
      stub(utils, "run_command").returns(
        "  main cd4faa4 [origin/main] feat: testing \n* test a95c385 [origin/r$ndom_br@nch-name] wip \n"
      )

      local branch = github_utils.get_git_branch()
      assert.equal("r$ndom_br@nch-name", branch)
    end)

    it("has multiple branches", function()
      stub(utils, "run_command").returns(
        "  main cd4faa4 [origin/main] feat: testing \n* test a95c385 [origin/r$ndom_br@nch-name] wip \n test2 a95c385 [origin/random_branch-name] wip "
      )

      local branch = github_utils.get_git_branch()
      assert.equal("r$ndom_br@nch-name", branch)
    end)

    it("has local ahead or behind origin", function()
      stub(utils, "run_command").returns(
        "  main cd4faa4 [origin/main] feat: testing \n* test a95c385 [origin/random: ahead 1] wip \n"
      )

      local branch = github_utils.get_git_branch()
      assert.equal("random", branch)
    end)
  end)
end)
