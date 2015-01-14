#!/usr/bin/lua

if not io.open("~/.love_project.lua") then
  print("making ~/.config file")
  io.open(".config", "w"):write('return {\n\tlpb = ""\n}')

  print("Please change string for ~/.love_project.lua")
  os.exit()
end

local conf = require(".love_project.lua")


--- writes a line to the file selected.
-- @function write_line
-- @param loc location of the file.
-- @param file to write to.
-- @param str to write.
-- @param m optional mode for file to write. Defaults to "a+" if left empty.
function write_line(loc, file, str, m)
  io.open(loc .. "/" .. file, m or "a+"):write(str):close()
end

--- checks love_init for new updates.
-- @function has_update
function has_update()
  for line in io.popen("cd  " .. conf.lpb .. "; hg incoming"):lines() do
    if line:match("no changes found") then
      return false
    end
  end
    return true
end

--- creates the intialized directory for the love project.
-- @function build_env
-- @param loc location of the love project path.
-- @param template the mercurial repository to use as a project template.
function build_env(loc, template)
  local template = template or conf.lpb
  write_line(loc, "config.ld", string.format("project = %q", arg[1]))
  os.execute("rm -rf " .. loc .. "/.hg")
  os.execute("cd " .. loc ..
             "; hg init; hg commit -A -m 'initial commit'")
end

local help = [=[
  love_init v0.1
  usage: love_init <name> [-p <path>] [-d <path>]

  Available actions:
  <name>      name of the lapis project
  -p <path>   the location of the installation for the project.
  -h          prints this text
]=]

if #arg == 0 or arg[1] == '-h' then
  print(help)
else
  if #arg > 1 then
    for i = 2, #arg do
      if arg[i] == '-p' then
        print("making project:", arg[i+1])
        build_env(arg[i+1] .. "/" .. arg[1])
      end
    end
  end
end
