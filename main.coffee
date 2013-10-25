{Server} = require './irc'
pogoda = require './weather'
java = require './java'
bash = require './bash'
twitter = require './twitter'
builtwith = require './builtwith'
geoip = require './geoip'

http = require 'http'

http.createServer((req, res)-> res.end()).listen process.env.PORT || 5000


#TODO clear register_plugins mess

register_plugins = (channel)->
  channel.on 'message', (msg, from)->

    match = msg.match /;pogoda (.*)/
    if match
      pogoda match[1], (res)->
        channel.send "#{from}: #{res}"

    match = msg.match /^;java/
    if match
      java (res)-> channel.send "#{from}: #{res}"

    match = msg.match /^;bash/
    if match
      bash (res)-> channel.send "#{from}: #{res}"

    match = msg.match /^;twitter (.*)/
    if match
      twitter match[1], (res)-> channel.send "#{from}: #{res}"

    match = msg.match /^;builtwith (.*)/
    if match
      builtwith match[1], (res)-> channel.send "#{from}: #{res}"

    match = msg.match /^;geoip (.*)/
    if match
      geoip match[1], channel.server, (res)-> channel.send "#{from}: #{res}"

    match = msg.match /^;whois (.*)/
    if match
      channel.server.whois match[1], (res)->
        console.log res.host
        channel.send "#{from}: #{res.host}"

server = new Server nick: 'node_bot', server: 'irc.freenode.net'

server.connect()
server.on 'ready', ->
  #server.join '#node.js-pl', register_plugins
  #server.join '#gentoo-pl', register_plugins
  server.join '#irctesting', register_plugins
module.exports = server
