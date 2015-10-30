r = require 'request'

r = r.defaults followAllRedirects: true


execute = (cb)->

  opts =
    url: 'http://bitstar.pl/api/ticker/?additional_currency=BTC&base_currency=PLN'
    strictSSL: false
    headers:
      'user-agent': 'NodeJS'

  r.get opts, (err, res, body)->
    console.log 'err', err if err
    console.log 'body', body
    json = JSON.parse body
    open = json.result.open
    high = json.result.max
    low  = json.result.min
    cb "bitstar, 1 BTC = *PLN* Open: #{open}, High: #{high}, Low: #{low}"

register = (channel)->
  channel.on 'message', (msg, from)->

    match = msg.match /^;btcpl/
    if match
      execute (res)->
          channel.send "#{from}: #{res}"




module.exports = register: register, execute: execute
