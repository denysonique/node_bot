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

module.exports = Channel
