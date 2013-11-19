r = require 'request'

r = r.defaults followAllRedirects: true
cheerio = require 'cheerio'

{format} = require '../util'


execute = (cb)->

  r.get 'https://walutomat.pl', (err, res, body)->
    $ = cheerio.load body
    eur = $('.bg').eq(1).find('.forex').text()
    usd = $('.bg').eq(2).find('.forex').text()
    gbp = $('.bg').eq(3).find('.forex').text()
    chf = $('.bg').eq(4).find('.forex').text()

    cb format("PLN: *EUR* #{eur} | *USD* #{usd} | *GBP* #{gbp} | *CHF* #{chf}")


register = (channel)->
  channel.on 'message', (msg, from)->

    match = msg.match /^;forex/
    if match
      execute (res)->
          channel.send "#{from}: #{res}"




module.exports = register: register, execute: execute
