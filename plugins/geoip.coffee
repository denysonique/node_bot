r = require 'request'

r = r.defaults followAllRedirects: true

delay = (ms,cb)-> setTimeout cb, ms

geoip = (nick, irc, cb)->
  nick = nick.toString()

  irc.whois nick, (res)->
    console.log 'whois: ', res

    r.get "http://freegeoip.net/json/#{res.host}", (err, res, body)->
      if err || res.statusCode != 200
        console.log err, res.statusCode
        cb 'dupa'
        return

      json = JSON.parse body.toString()

      reply = []
      reply.push json.city if json.city
      reply.push json.country_name if json.country_name

      cb reply.join ', '

module.exports = geoip
