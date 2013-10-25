net            = require 'net'
{EventEmitter} = require 'events'

class Channel extends EventEmitter
  constructor: (@name, @server)->
    @server.socket.on 'line', (data)=>
      data = data.toString()

      regex = new RegExp ":\(.*\)!.* PRIVMSG #{@name} :\(.*\)"
      privmsg = data.match regex


      if privmsg
        @emit 'message', privmsg[2], privmsg[1]

    @server.on 'ping', (str)=>
      @server.socket.writeln "PONG #{str}"

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
    @handle_events()

  on_line: (line)=>
    console.log "<< #{line}"
  
    regex = new RegExp "PING \(.*\)"
    ping = line.match regex

    regex = /.* 311 .* (.*) .* (.*) \* .*/
    whois = line.match regex
    if whois
      @emit 'whois', nick: whois[1], host: whois[2]
    if ping
      @emit 'ping', ping[1]


  handle_events: =>
    @on 'ping', (str)->
      @socket.writeln "PONG #{str}"

  connect: =>
    console.log 'connecting'
    @socket = new net.Socket
    @socket.setEncoding('utf-8')

    @socket.on 'line', @on_line

    @socket.on 'data', (data)=>
      data.split('\n').forEach (line)=>
        @socket.emit 'line', line

    @socket.writeln = (msg, cb)=>
      console.log ">> #{msg}"
      @socket.write("#{msg}\n", cb)

    console.log @settings
    @socket.connect 6667, @settings.server
    @socket.on 'connect', @connected
    @emit 'connect'


  join: (channel_name, cb)=>
    @socket.writeln "JOIN #{channel_name}", =>
      channel = new Channel channel_name, @
      cb(channel) if cb

  connected: =>
    @socket.writeln "NICK #{@settings.nick}", =>
      @socket.writeln 'USER user foo hax :bar', =>
        @emit 'ready'

  whois: (nick, cb)=>
    @socket.writeln "WHOIS #{nick}"
    @on 'whois', cback = (res)->
      if res.nick == nick
        cb res
        @removeListener 'whois', cback

module.exports = Server: Server
