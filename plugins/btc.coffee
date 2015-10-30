r = require 'request'

r = r.defaults followAllRedirects: true


execute = (cb)->

  opts =
    url: 'https://api.exchange.coinbase.com/products/BTC-USD/stats'
    headers:
      'user-agent': 'NodeJS'

  r.get opts, (err, res, body)->
    json = JSON.parse body
    open = json.open
    high = json.high
    low  = json.low
    volume = json.volume
    cb "Coinbase, 1 BTC = *USD* Open: #{open}, High: #{high}, Low: #{low}, Volume: #{volume}"

register = (channel)->
  channel.on 'message', (msg, from)->

    match = msg.match /^;btc/
    if match
      execute (res)->
          channel.send "#{from}: #{res}"




module.exports = register: register, execute: execute
