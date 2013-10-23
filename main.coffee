{Server} = require './irc'
pogoda = require './weather'


server = new Server nick: 'node_bot', server: 'irc.freenode.net'

server.connect()
server.on 'ready', ->
  server.join '#irctesting', (channel)->
    channel.on 'message', (msg)->
      match = msg.match /;pogoda (.*)/
      console.log msg
      if match
        console.log 'matched pogoda', match[1]
        pogoda match[1], (res)->
          channel.send res
