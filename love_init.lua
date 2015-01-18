#!/usr/bin/lua
---  love2d project initializer.
-- @author Alejandro Baez <alejan.baez@gmail.com>
-- @license MIT (see @{LICENSE})
-- @module love_init

local common = require("common")
local templates = require("templates")

local _CONF = io.popen("echo $HOME"):read() .. "/.love_init.conf"


--- appends from template with basic settings.
-- @param loc see @{loc}.
-- @param name see @{name}.
-- @param user see @{user}.
local function append_files(loc, name, user)
  templates:write_line(loc, "config.ld", string.format(
    "project = %q\n  title = %q", name, name .. " docs"))
  templates:write_line(loc, "conf.lua", string.format(
    "  t.title  = %q\n  t.author = %q\n  t.url = %q\nend",
    name, user.author, user.url))
--  templates:write_line(loc, "main.lua", "--- " .. name .. "\n", "r+")
end

--- creates the intialized directory for the love project.
-- @param loc location of the project directory.
-- @param name the name love project path.
-- @param src the source path of love project builder.
-- @param user see @{user}.
local function build_env(loc, name, src, user, vcs)
  assert(os.execute("mkdir " .. loc), "Couldn't make: " .. loc)
  templates:copy(loc, {"config.ld", "conf.lua", "main.lua"}, src or user.src)
  append_files(loc, name, user)

  os.execute("cd " .. loc .. ";" .. common.vcs_str(vcs))
end

--- a temporary table for command run.
-- @src see @{src}.
-- @name see @{name}.
-- @loc see @{loc}.
-- @vcs see @{vcs}.
local tmp = {
  src = false,
  name = false,
  loc = false,
  vcs = false,
  cwd = io.popen("pwd"):read() .. "/"
}

local help = [=[
  love_init v0.1
  usage: love_init <name> [-s <source>] [-p <path>] [-d <path>]

  Available actions:
  <name>      name of the love project
  -p <path>   the location of the installation for the project.
  -s <source> the location for the source of love_init.
  -g          use 'git' to instead of 'hg'. Automates to 'hg' if not given.
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
      elseif arg[i] == '-g' then
        tmp.vcs = 'git'
      end
    end

    print("making environment project: " .. tmp.name)
    build_env(
      tmp.loc or tmp.cwd .. tmp.name,
      tmp.name,
      tmp.src,
      get_user(_CONF, tmp.src),
      tmp.vcs)
  else
    print("making environment project: " .. tmp.name)
    build_env(tmp.cwd .. tmp.name,
              tmp.name,
              tmp.src,
              get_user(_CONF, tmp.src),
              tmp.vcs)
  end
end
