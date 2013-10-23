net            = require 'net'
{EventEmitter} = require 'events'

class Channel extends EventEmitter
  constructor: (@name, @server)->
    @server.socket.on 'line', (data)=>
      data = data.toString()
      regex = new RegExp ":\(.*\)!.* PRIVMSG #{@name} :\(.*\)"
      match = data.match regex
      if match
        @emit 'message', match[2], match[1]

  send: (msg)=>
    @server.socket.writeln "PRIVMSG #{@name} :#{msg}"


class Server extends EventEmitter

  constructor: (settings)->
    console.log 'settings const', settings
    if settings
      @settings = settings
    else
      console.log 'nosettings'
      process.exit()
      @settings =
        nick: 'ircbot'
        server: 'localhost'

  connect: =>
    console.log 'connecting'
    @socket = new net.Socket
    @socket.setEncoding('utf-8')

    @socket.on 'line', (line)->
      console.log line

    @socket.on 'data', (data)=>
      data.split('\n').forEach (line)=>
        @socket.emit 'line', line

    @socket.writeln = (msg, cb)=> @socket.write("#{msg}\n", cb)

    console.log @settings
    @socket.connect 6667, @settings.server
    @socket.on 'connect', @connected
    @emit 'connect'


  join: (channel_name, cb)=>
    @socket.writeln "JOIN #{channel_name}", =>
      channel = new Channel channel_name, @
      cb(channel) if cb

  connected: =>
    console.log 'connected'
    @socket.writeln "NICK #{@settings.nick}", =>
      @socket.writeln 'USER user foo hax :bar', =>
        @emit 'ready'

module.exports = Server: Server
