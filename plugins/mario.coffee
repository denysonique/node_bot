execute = (cb)->
  cb 'https://chaos.engine.gen2.org/~chaos/FullScreenMario-master/'

register = (channel)->
  channel.on 'message', (msg, from)->

    match = msg.match /;mario/
    if match
      execute (res)->
        channel.send "#{from}: #{res}"

module.exports = register: register, execute: execute
if require.main == module
  execute console.log

