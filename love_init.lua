#!/usr/bin/lua


local _CONF = io.popen("echo $HOME"):read() .. "/.love_init.conf"

if not io.open(_CONF) then
  print("making ".. _CONF .. " file")
  local finit = io.open(_CONF, "w")
  for line in io.open("./templates/love_init.conf"):lines() do
    finit:write(line, "\n")
  end
  finit:close()

  local s = string.format("cp %s/%s %s", io.popen("pwd"):read(), _CONF)
  assert(os.execute(s), "Couldn't copy into: ", _CONF)
  print("Please change src correctly in:", _CONF)
  os.exit()
end

local user = dofile(_CONF, "t")
assert(user.src, "Edit your ~/.love_init.conf")

--- writes a line to the file selected.
-- @function write_line
-- @param loc location of the file.
-- @param file to write to.
-- @param str to write.
-- @param m optional mode for file to write. Defaults to "a+" if left empty.
function write_line(loc, file, str, m)
  io.open(loc .. "/" .. file, m or "a+"):write(str):close()
end

--- creates the intialized directory for the love project.
-- @function build_env
-- @param loc location of the love project path.
-- @param name the name love project path.
-- @param src the source path of the src.
function build_env(loc, name, src)
  local src  = src or user.src

  os.execute("cd " .. loc ..
             "; hg init; hg commit -A -m 'initial commit'")
end


--- appends from template with basic settings.
-- @param loc location of the project directory.
-- @param name the name of project.
-- @param user a @{user} table.
local function append_files(loc, name, user)
  write_line(loc, "config.ld", string.format(
    "project = %q\ntitle = %q", name, name .. " docs"))
  write_line(loc, "conf.lua", string.format(
    "t.title  = %q\n  t.author = %q\n  t.url = %q\nend",
    name, user.author, user.url))
  write_line(loc, "main.lua", "--- " .. name, "r+")
end


local help = [=[
  love_init v0.1
  usage: love_init <name> [-s <source>] [-p <path>] [-d <path>]

  Available actions:
  <name>      name of the lapis project
  -p <path>   the location of the installation for the project.
  -s <source> the location for the source of love_init.
  -h          prints this text
]=]

if #arg == 0 or arg[1] == '-h' then
  print(help)
else
  if #arg > 1 then
    for i = 2, #arg do
      if arg[i] == '-p' then
        print("making project:", arg[i+1])
        build_env(arg[i+1] .. "/" .. arg[1], arg[1])
      end
    end
  else
    assert(arg[1] ~= '-d' and arg[1] ~= '-p' and arg[1] ~= '-s', help)
    print("making environment project: " .. arg[1])
    build_env(io.popen("pwd"):read() .. "/" .. arg[1], arg[1])
  end
end
