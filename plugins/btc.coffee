r = require 'request'

r = r.defaults followAllRedirects: true


execute = (cb)->

  opts =
    url: 'https://bitstar.pl/api/ticker/?additional_currency=BTC&base_currency=PLN'
    headers:
      'user-agent': 'NodeJS'

  r.get opts, (err, res, body)->
    json = JSON.parse body
    open = json.open
    high = json.min
    low  = json.max
    cb "bitstar, 1 BTC = *USD* Open: #{open}, High: #{high}, Low: #{low}"

register = (channel)->
  channel.on 'message', (msg, from)->

    match = msg.match /^;btc/
    if match
      execute (res)->
          channel.send "#{from}: #{res}"




module.exports = register: register, execute: execute
