r       = require 'request'
iconv   = require 'iconv-lite'
cheerio = require 'cheerio'

r = r.defaults followAllRedirects: true

delay = (ms,cb)-> setTimeout cb, ms

execute = (keyword, cb)->
  keyword = keyword.toString()

  r.get encoding: null, url:"http://sjp.pwn.pl/szukaj/#{keyword}", (err, res, body)->
    if err || res.statusCode != 200
      cb 'dupa'
      return

    body = iconv.decode body, 'iso-8859-2'
    body = body.toString('utf-8')
    $ = cheerio.load body
    results = $('#listahasel li div div').slice(0, 3)
    results = results
      .map (ix, div)->
        $(div).text()

    text = results.join '\n'
    cb text


register = (channel)->
  channel.on 'message', (msg, from)->

    match = msg.match /;sjp ([A-z]+)/
    if match
      execute match[1], (res)->
        lines = res.split '\n'
        for line in lines
          channel.send "#{from}: #{line}"



module.exports = register: register, execute: execute
if require.main == module
  execute 'gra', console.log

