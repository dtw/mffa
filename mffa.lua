_addon.name = 'MakeFishingFunAgain'
_addon.author = 'dtw'
_addon.version = '0.1'
_addon.command = 'mffa'
_addon.commands = {'start', 'stop', 'cancel', 'recast'}

require('tables')
require('logger')
require('strings')

config = require('config')
texts = require ('texts')
packets = require('packets')

-- default settings

defaults = {}
defaults.random = true
defaults.recast = true
defaults.delay = {}
defaults.delay.release = 2
defaults.delay.cast = 9
defaults.release = {}
defaults.release.item = true
defaults.release.mob = true
defaults.release.big= false
defaults.pos = {}
defaults.pos.x = 886
defaults.pos.y = 240
defaults.showrecast = true

settings = config.load(defaults)

-- start disabled
enabled = false
window = texts.new('MFFA stopped', settings)
window:show()

-- get player
local player = windower.ffxi.get_player()

windower.register_event('addon command', function(command, ...)
  command = command and command:lower()
  local args = {...}

  if command == 'start' then
    window:text('MFFA running')
    enabled = true
  elseif S{'stop','cancel'}:contains(command) then
    window:text('MFFA stopped')
    enabled = false
  elseif S{'recast','showrecast','random'}:contains(command) then
    settings[command] = not settings[command]
    notice(command..' '..tostring(settings[command]))
  end
end)

function check_incoming_text(original, modified, original_mode, modified_mode, blocked)
  if enabled then
    if original:find('You cannot fish here.') then
      enabled = false
      error('See above.')
      window:text('MFFA stopped')
    elseif original:find(player.name..' regretfully releases') then
      settings.recast = not settings.recast
      error('inventory full - auto-recast '..tostring(settings.recast))
    elseif original:find('You didn\'t catch anything.') then
      log('no bites...')
    elseif original:find('Something clamps') then
      log('it\'s a mob!')
      if settings.release.mob then cancel_fishing() end
    elseif original:find('You feel something') then
      log('it\'s probably an item.')
      if settings.release.item then cancel_fishing() end
    elseif original:find('Something caught') then
      if original:find('!!!') then
        log('it\'s a whopper!')
        if settings.release.big then cancel_fishing() end
      end
    elseif original:find(player.name..' caught a') then
      if settings.recast then
        local recastdelay = settings.delay.cast + (settings.random and (math.random() + math.random(0,2)) or 0.0)
        if settings.showrecast then log('recast in %.2f seconds':format(recastdelay)) end
        recast_line(recastdelay)
      end
    end
  end
end

function cancel_fishing()
  local releasedelay = settings.delay.release + (settings.random and math.random() or 0.0)
  windower.send_command('wait %.2f; lua i mffa release_catch':format(releasedelay))
end

function recast_line(delay)
  windower.send_command('wait %.2f; input /fish':format(delay))
end

function release_catch()
  log('releasing catch...')
  packets.inject(packets.new('outgoing', 0x110, {
    ['Player'] = player.id,
    ['Fish HP'] = 200,
    ['Player Index'] = player.index,
    ['Action'] = 3,
  }))
  if settings.recast then
    local recastdelay = settings.delay.cast + (settings.random and (math.random() + math.random(0,2)) or 0.0)
    --log('Recast in '..tostring(recastdelay)..' seconds')
    if settings.showrecast then log('recast in %.2f seconds':format(recastdelay)) end
    recast_line(recastdelay)
  end
end

-- register event callbacks
windower.register_event('incoming text', check_incoming_text)
