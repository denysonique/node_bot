r = require 'request'

r = r.defaults followAllRedirects: true


execute = (cb)->

  r.get 'https://data.mtgox.com/api/1/BTCPLN/ticker', (err, res, body)->
    json = JSON.parse body
    last = json.return.last.value
    high = json.return.high.value
    low  = json.return.low.value
    cb "MTGox, 1 BTC = *PLN* Last: #{last}, High: #{high}, Low: #{low}"

    r.get 'https://data.mtgox.com/api/1/BTCGBP/ticker', (err, res, body)->
      json = JSON.parse body
      last = json.return.last.value
      high = json.return.high.value
      low  = json.return.low.value
      cb "MTGox, 1 BTC = *GBP* Last: #{last}, High: #{high}, Low: #{low}"


      r.get 'https://data.mtgox.com/api/1/BTCUSD/ticker', (err, res, body)->
        json = JSON.parse body
        last = json.return.last.value
        high = json.return.high.value
        low  = json.return.low.value
        cb "MTGox, 1 BTC = *USD* Last: #{last}, High: #{high}, Low: #{low}"

register = (channel)->
  channel.on 'message', (msg, from)->

    match = msg.match /^;btc/
    if match
      execute (res)->
          channel.send "#{from}: #{res}"




module.exports = register: register, execute: execute
