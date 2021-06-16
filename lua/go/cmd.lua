-- commands module
local Job = require("plenary.job")
local Path = require("plenary.path")
local window = require("go.window")
local str = require("go.str")
local util = require("go.util")
local M = {}

M.close_win = function()
  vim.api.nvim_win_close(0, true)
end

-- :GoRun
M.run = function(file)
  local win = window.create_window("0.4", "0.4")
  local job_id = vim.api.nvim_open_term(win.bufnr, {})
  Job:new{
    "go",
    "run",
    vim.fn.expand(file),
    on_stdout = vim.schedule_wrap(function(_, data)
      vim.api.nvim_chan_send(job_id, data .. "\r\n")
    end),
    on_stderr = vim.schedule_wrap(function(_, data)
      vim.api.nvim_chan_send(job_id, data .. "\r\n")
    end),
  }:start()
end

-- :GoTest
-- 2. check if user is on _test file or check for test alternate file
-- 3. call test command
M.test = function(nearest)
  local current_file = vim.fn.expand("%:t")
  if not str.endswith(current_file, "_test.go") then
    print("current file is not a go test file")
    return
  end

  local args = {"test", "-v", "-json"}

  -- tries to get test name in current line
  if nearest then
    local test_name = str.get_test_name(vim.fn.getline('.'))
    if test_name == "" then
      vim.api.nvim_err_writeln("No tests found under cursor. Running all test suite")
    else
      table.insert(args, "-run=" .. test_name)
    end
  end

  local win = window.create_window("0.7", "0.7")
  local job_id = vim.api.nvim_open_term(win.bufnr, {})
  Job:new{
    command = "go",
    args = args,
    on_stdout = vim.schedule_wrap(function(_, data)
      -- local output = str.get_test_output(data)
      vim.api.nvim_chan_send(job_id, data)
    end),
    on_stderr = vim.schedule_wrap(function(_, data)
      vim.api.nvim_err_writeln(data)
    end),
  }:start()
end

-- :GoAlternate
M.alternate = function()
  local afile
  local file = vim.fn.expand("%")
  if file == "" then
    print("buffer is empty or file is not a go file")
    return
  elseif str.endswith(file, "_test.go") then
    local root, _ = string.gsub(file, "_test.go", "")
    afile = string.format("%s.go", root)
  else
    local root = vim.fn.expand("%:p:r")
    afile = string.format("%s_test.go", root)
  end

  if util.file_exists(afile) then
    vim.api.nvim_err_writeln("alternate file not found")
    return
  end
  vim.cmd("edit " .. afile)
end

-- :GoBrowse
M.browse = function()
  local function parse_uri(uri)
    local chars = "[_%-%w%.]+"
    local protocol_schema = "%g+[/@]"
    local host_schema = chars .. "%." .. chars
    local path_schema = "" .. chars .. "/" .. chars
    local host_capture =
      protocol_schema .. '(' .. host_schema .. ")[:/]" .. path_schema .. "%.git$"
    local path_capture = protocol_schema .. host_schema .. "[:/](" .. path_schema ..
                           ")%.git$"
    local repo = {host = uri:match(host_capture), path = uri:match(path_capture)}
    if not repo.host then
      return
    end
    return repo
  end

  local function get_rel_path()
    local git_root
    local job = Job:new{"git", "rev-parse", "--show-toplevel"}
    job:after_success(function(j)
      git_root = j:result()[1]
    end)
    job:sync()

    return Path:new(vim.api.nvim_buf_get_name(0)):make_relative(git_root)
  end

  local repo
  local job = Job:new{"git", "remote", "get-url", "origin"}
  job:after_success(function(j)
    repo = j:result()[1]
  end)
  job:sync()

  local url = parse_uri(repo)
  if not url then
    vim.api.nvim_err_writeln(string.format("cannot parse the host name from uri '%s'",
                                           repo))
    return
  end

  local rel_path = get_rel_path()
  local github_url = "https://" .. url.host .. "/" .. url.path .. "/blob/main/" ..
                       rel_path
  Job:new{"xdg-open", github_url}:start()
end

-- :GoLint
M.lint = function()
  local args = {"run"}

  if not vim.fn.executable("golangci-lint") then
    vim.api.nvim_err_writeln("golangci-lint not found. Please install it first")
    return
  end

  local cfg = ".golangci.yml"
  if util.file_exists(cfg) then
    table.insert(args, "-c", cfg)
  end

  Job:new{
    command = "golangci-lint",
    args = args,
    on_stderr = vim.schedule_wrap(function(error, _)
      vim.api.nvim_err_writeln(error)
    end),
    on_exit = vim.schedule_wrap(function(j, code, _)
      if code == 0 then
        util.print_msg("Function", "[PASS]")
        return
      else
        local win = window.create_window("0.7", "0.7")
        vim.api.nvim_open_term(win.bufnr, {})
        vim.api.nvim_buf_set_option(win.bufnr, "modifiable", true)
        vim.api.nvim_buf_set_lines(win.bufnr, 0, -1, false, j:result())
        vim.api.nvim_buf_set_option(win.bufnr, "modifiable", false)
      end
    end),
  }:start()
end

return M
