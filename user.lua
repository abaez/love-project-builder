--- user build configuration.
-- @author Alejandro Baez <alejan.baez@gmail.com>
-- @license MIT (see @{LICENSE})
-- @module user

local M = {}

--- makes the config file for the user.
-- @param file the absolute location of default configuration file.
-- @param src see @{templates.copy| src}.
function M:make(file, src)
  print("making the file: " .. file)
  local finit = io.open(file, "w")
  for line in io.open(src .. "/templates/love_init.conf"):lines() do
    finit:write(line, "\n")
  end
  finit:close()

  print("Please change src correctly in:", file)
  os.exit()
end

--- gets the user configuration file.
-- @param file see @{make| file}.
-- @param src see @{templates.copy| src}.
function M:get(file, src)
  local user = ""
  if not io.open(file) then
    assert(src, "run with [-s <source>] argument")
    make_conf(file, src)
  else
    user = dofile(file, "t")
    assert(user.src, "Edit src: '" .. file .. "' to run")
  end

  return user
end


return M
