Server    = require './irc/server'

pogoda    = require './plugins/weather'
java      = require './plugins/java'
bash      = require './plugins/bash'
twitter   = require './plugins/twitter'
builtwith = require './plugins/builtwith'
geoip     = require './plugins/geoip'
rofl      = require './plugins/roflcopter.coffee'
youtube   = require './plugins/youtube_title.coffee'
sjp       = require './plugins/sjp'
btc       = require './plugins/btc'
mario     = require './plugins/mario'
headers   = require './plugins/headers'
forex     = require './plugins/forex'
github    = require './plugins/github.coffee'

http      = require 'http'

http.createServer((req, res)-> res.end()).listen process.env.PORT || 5000


#TODO clear register_plugins mess

register_plugins = (channel)->
  youtube.register channel unless channel.name == '#gentoo-pl'
  sjp.register channel
  btc.register channel unless channel.name == '#gentoo-pl'
  rofl.register channel
  bash.register channel
  mario.register channel
  headers.register channel
  forex.register channel
  github.register channel

  channel.on 'message', (msg, from)->

    match = msg.match /;pogoda (.*)/
    if match
      pogoda match[1], (res)->
        channel.send "#{from}: #{res}"

    match = msg.match /^;java/
    if match
      java (res)-> channel.send "#{from}: #{res}"

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
      channel.send "#{from}: https://github.com/denysonique/node_bot"

    match = msg.match /^;source/
    if match
      channel.send "#{from}: https://github.com/denysonique/node_bot"

    match = msg.match /^;windows/
    if match
      channel.send "#{from}: http://support.microsoft.com/kb/314458"

if process.env.NODE_ENV == 'development'
  host = 'localhost'
else
  host = 'holmes.freenode.net'

server = new Server nick: 'node_bot', server: host

server.connect()
server.on 'ready', ->
  server.join '#node.js-pl', register_plugins
  server.join '#gentoo-pl', register_plugins
  server.join '#irctesting', register_plugins

module.exports = server
