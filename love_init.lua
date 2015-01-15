#!/usr/bin/lua


local _CONF = io.popen("echo $HOME"):read() .. "/.love_init.conf"




--- writes a line to the file selected.
-- @param loc location of the file.
-- @param file to write to.
-- @param str to write.
-- @param m optional mode for file to write. Defaults to "a+" if left empty.
local function write_line(loc, file, str, m)
  io.open(loc .. "/" .. file, m or "a+"):write(str):close()
end

--- creates the intialized directory for the love project.
-- @param loc location of the love project path.
-- @param name the name love project path.
-- @param src the source path of the src.
local function build_env(loc, name, src)
  local src  = src or user.src

  assert(os.execute("mkdir " .. loc), "Couldn't make: " .. loc)


  os.execute("cd " .. loc ..
             "; hg init; hg commit -A -m 'initial commit'")


end

--- copys the templates to their destination.
-- @param loc the location of the project directory.
-- @param templates a table containing the name of the template files.
-- @param src optional source location of love project builder.
local function copy_templates(loc, templates, src)
  local src = src or user.src
  local templates = templates or user.templates

  for _, template in ipairs(templates) do
    local ftemplate = io.open(loc .. "/" .. template, "w")
    for line in io.open(src .. "/templates/" .. template):lines() do
      ftemplate:write(line, "\n")
    end
  end
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

--- makes the config file for love_init
-- @param file the configure default location.
-- @param src the source location of love project builder.
local function make_conf(file, src)
  local file = file or _CONF

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
-- @param file the location of the configuration file to make.
-- @param src the location of the love project builder.
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

--- a temporary table for command run.
-- @src see @{src}.
-- @name see @{name}.
-- @path see @{path}.
local tmp = {
  src = false,
  name = false,
  path = false,
}

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
  assert(arg[1] ~= '-d' and arg[1] ~= '-p' and arg[1] ~= '-s', help)
  tmp.name = arg[1]

  if #arg > 1 then
    for i = 2, #arg do
      if arg[i] == '-p' then
        tmp.path = arg[i+1] .. "/" .. tmp.name
      elseif arg[i]  == '-s' then
        tmp.src = arg[i+1]
      end
    end

    print("making environment project: " .. tmp.name)
    build_env(tmp.path, tmp.name, tmp.src, get_user(_CONF, tmp.src))
  else
    print("making environment project: " .. tmp.name)
    build_env(io.popen("pwd"):read() .. "/" .. tmp.name, tmp.name)
  end
end
