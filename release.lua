_addon.name = 'release'
_addon.author = 'dtw'
_addon.version = '0.1'
_addon.command = 'release'
_addon.commands = {'show', 'hide', 'update'}

require('tables')
require('logger')

config = require('config')
texts = require ('texts')

local defaults = T{}

settings = config.load(defaults)

window = texts.new('Hello world!', settings)
window:show()

windower.register_event('addon command', function(command, ...)
  command = command and command:lower()
  local args = {...}

  if command == 'show' then
    window:show()
  elseif command == 'hide' then
    window:hide()
  elseif command == 'update' then
    window:text(args[1])
  end
end)
