{Server} = require './irc'
pogoda = require './weather'
http = require 'http'

http.createServer((req, res)-> res.end()).listen process.env.PORT || 5000


register = (channel)->
  channel.on 'message', (msg)->
    match = msg.match /;pogoda (.*)/
    console.log msg
    if match
      console.log 'matched pogoda', match[1]
      pogoda match[1], (res)->
        channel.send res

server = new Server nick: 'node_bot', server: 'irc.freenode.net'

server.connect()
server.on 'ready', ->
  server.join '#node.js-pl', register
  server.join '#gentoo-pl', register
  server.join '#irctesting', register

module.exports = server
