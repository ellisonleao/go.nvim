-- string utils
local M = {}

-- endswith simulates a similar python str.endswith behaviour
M.endswith = function(str, val)
  return val == "" or string.sub(str, -#val) == val
end

-- startswith simulates a similar python str.startswith behaviour
M.startswith = function(str, val)
  return val == "" or string.sub(str, 1, string.len(val)) == val
end

-- split splits a string by a sep, having space as default separator
M.split = function(str, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for i in string.gmatch(str, "([^" .. sep .. "]+)") do
    table.insert(t, i)
  end

  return t
end

-- find a TestXXX name based on the content of the line
M.get_test_name = function(line)
  local match = "Test%w+"
  local test_name = string.match(line, match)
  if test_name == nil then
    return ""
  end
  return test_name
end

M.get_test_output = function(input)
  local splitted = vim.fn.split(input, "\n")
  local tests = {}
  local suite = {status = "", elapsed = ""}

  for _, i in ipairs(splitted) do
    local d = vim.fn.json_decode(i)
    local test_name = d["Test"]
    local action = d["Action"]

    if test_name == nil then
      if action ~= "output" then
        suite.status = d["Action"]
        suite.elapsed = d["Elapsed"]
      end
    else
      if action == "run" then
        tests[test_name] = {output = "", status = "", package = d["Package"]}
      elseif action == "output" then
        if M.startswith(d["Output"], "---") then
          -- removing extra output from test result
          local out = string.gsub(d["Output"], "--- ", "")
          out = string.gsub(out, ": .*", "")
          tests[test_name].status = out
        elseif not M.startswith(d["Output"], "===") then
          tests[test_name].output = tests[test_name].output .. d["Output"]
        end
      end
    end
  end
  local output = ""

  for test_name, test in pairs(tests) do
    output = output .. " ------- " .. test_name .. " -------\n"
    output = output .. "|  package: " .. test.package .. "\n"
    output = output .. "|  status:  " .. test.status .. "\n"
    output = output .. " ----------------------------------\n"
  end
  output = output .. "elapsed: " .. suite.elapsed .. "\n"
  output = output .. "result: " .. suite.status .. "\n"
  return output
end

return M
