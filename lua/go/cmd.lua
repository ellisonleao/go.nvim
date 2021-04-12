-- commands module
local Job = require("plenary.job")
local window = require("plenary.window.float")
local str = require("go.str")
local M = {}

-- :GoRun
M.run = function(file)
  local win = window.percentage_range_window(tonumber("0.8"), tonumber("0.8"))
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
    on_exit = vim.schedule_wrap(function(self)
      P(self)
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

  -- if nearest then
  --   local line = vim.fn.getline(".")
  -- end
  local win = window.percentage_range_window(tonumber("0.5"), tonumber("0.5"))
  local job_id = vim.api.nvim_open_term(win.bufnr, {})

  Job:new{
    "go",
    "test",
    "-v",
    on_stdout = vim.schedule_wrap(function(_, data)
      -- local items = vim.fn.json_decode(data)
      -- local tests = {}
      -- for _, item in ipairs(items) do
      --   local test_name = item["Test"]
      --   if test_name ~= nil then
      --     if tests[test_name] == nil then
      --       tests[test_name] = {
      --         output = string.format("TEST: %s---------------- \n", test_name),
      --       }
      --     else
      --       if item["Action"] == "output" then
      --         tests[test_name].output = tests[test_name].output .. item["Output"]
      --       end
      --     end
      --   end
      -- end
      -- local out = ""
      vim.api.nvim_chan_send(job_id, data .. "\r\n")
    end),
    on_stderr = vim.schedule_wrap(function(_, data)
      vim.api.nvim_chan_send(job_id, data)
    end),
    on_exit = vim.schedule_wrap(function(self)
      P(self)
    end),
  }:start()
end

-- :GoAlternate
M.alternate = function()
  local function file_exists(path)
    return vim.fn.filereadable(path) == 0 and vim.fn.bufexists(path) == 0
  end

  local afile
  local file = vim.fn.expand("%")
  if file == "" then
    print("buffer is empty or file is not a go file")
    return
  elseif str.endswith(file, "_test.go") then
    local root, _ = string.gsub(file, "_test.go", "")
    afile = string.format("%s.go", root)
    vim.cmd("edit " .. afile)
  else
    local root = vim.fn.expand("%:p:r")
    afile = string.format("%s_test.go", root)
  end

  if file_exists(afile) then
    vim.api.nvim_err_writeln("alternate file not found")
    return
  end
  vim.cmd("edit " .. afile)
end

return M
