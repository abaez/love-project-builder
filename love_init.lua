#!/usr/bin/lua
---  love2d project initializer.
-- @author Alejandro Baez <alejan.baez@gmail.com>
-- @license MIT (see @{LICENSE})
-- @module love_init

local _CONF = io.popen("echo $HOME"):read() .. "/.love_init.conf"

--- writes a line to the file selected.
-- @param loc location of the file.
-- @param file to write to.
-- @param str to write.
-- @param m optional mode for file to write. Defaults to "a+" if left empty.
local function write_line(loc, file, str, m)
  io.open(loc .. "/" .. file, m or "a+"):write(str):close()
end

--- copies the templates to their destination.
-- @param loc see @{loc}.
-- @param templates a table containing the name of the template files.
-- @param src see @{src}.
local function copy_templates(loc, templates, src)
  local templates = templates or user.templates

  for _, template in ipairs(templates) do
    local ftemplate = io.open(loc .. "/" .. template, "w")
    for line in io.open(src .. "/templates/" .. template):lines() do
      ftemplate:write(line, "\n")
    end
    ftemplate:close()
  end
end

--- appends from template with basic settings.
-- @param loc see @{loc}.
-- @param name see @{name}.
-- @param user see @{user}.
local function append_files(loc, name, user)
  write_line(loc, "config.ld", string.format(
    "project = %q\n  title = %q", name, name .. " docs"))
  write_line(loc, "conf.lua", string.format(
    "  t.title  = %q\n  t.author = %q\n  t.url = %q\nend",
    name, user.author, user.url))
--  write_line(loc, "main.lua", "--- " .. name .. "\n", "r+")
end

--- makes the config file for love_init
-- @param file the absolute location of default configuration file.
-- @param src see @{src}.
local function make_conf(file, src)
  print("making the file: " .. file)
  local finit = io.open(file, "w")
  for line in io.open(src .."/templates/love_init.conf"):lines() do
    finit:write(line, "\n")
  end
  finit:close()

  print("Please change src correctly in:", file)
  os.exit()
end

--- gets the user configuration file.
-- @param file see @{file}.
-- @param src see @{src}.
local function get_user(file, src)
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

--- creates the intialized directory for the love project.
-- @param loc location of the project directory.
-- @param name the name love project path.
-- @param src the source path of love project builder.
-- @param user see @{user}.
local function build_env(loc, name, src, user)
  assert(os.execute("mkdir " .. loc), "Couldn't make: " .. loc)
  copy_templates(loc, {"config.ld", "conf.lua", "main.lua"}, src or user.src)
  append_files(loc, name, user)

  os.execute("cd " .. loc .. "; hg init; hg commit -A -m 'initial commit'")
end

--- a temporary table for command run.
-- @src see @{src}.
-- @name see @{name}.
-- @loc see @{loc}.
local tmp = {
  src = false,
  name = false,
  loc = false,
  cwd = io.popen("pwd"):read() .. "/"
}

local help = [=[
  love_init v0.1
  usage: love_init <name> [-s <source>] [-p <path>] [-d <path>]

  Available actions:
  <name>      name of the love project
  -p <path>   the location of the installation for the project.
  -s <source> the location for the source of love_init.
  -h          prints this text
]=]

if #arg == 0 or arg[1] == '-h' then
  print(help)
elseif arg[1] == '-s' then
  get_user(_CONF, arg[2])
else
  assert(arg[1] ~= '-d' and arg[1] ~= '-p', help)
  tmp.name = arg[1]

  if #arg > 1 then
    for i = 2, #arg do
      if arg[i] == '-p' then
        tmp.loc = arg[i+1] .. "/" .. tmp.name
      elseif arg[i]  == '-s' then
        tmp.src = arg[i+1]
      end
    end

    print("making environment project: " .. tmp.name)
    build_env(
      tmp.loc or tmp.cwd .. tmp.name,
      tmp.name,
      tmp.src,
      get_user(_CONF, tmp.src))
  else
    print("making environment project: " .. tmp.name)
    build_env(tmp.cwd .. tmp.name, tmp.name, tmp.src, get_user(_CONF, tmp.src))
  end
end
