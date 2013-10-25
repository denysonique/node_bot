Server    = require './irc/server'

pogoda    = require './plugins/weather'
java      = require './plugins/java'
bash      = require './plugins/bash'
twitter   = require './plugins/twitter'
builtwith = require './plugins/builtwith'
geoip     = require './plugins/geoip'

http      = require 'http'

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

    match = msg.match /^;locate (.*)/
    if match
      geoip match[1], channel.server, (res)-> channel.send "#{from}: #{res}"

    match = msg.match /^;version/
    if match
      channel.send "#{from} https://github.com/denysonique/node_bot"

    match = msg.match /^;source/
    if match
      channel.send "#{from} https://github.com/denysonique/node_bot"

if process.env.NODE_ENV == 'development'
  host = 'localhost'
else
  host = 'irc.freenode.net'

server = new Server nick: 'node_bot', server: host

server.connect()
server.on 'ready', ->
  server.join '#node.js-pl', register_plugins
  server.join '#gentoo-pl', register_plugins
  server.join '#irctesting', register_plugins

module.exports = server
