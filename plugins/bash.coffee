r       = require 'request'
cheerio = require 'cheerio'
qs      = require 'querystring'

r = r.defaults followAllRedirects: true

delay = (ms,cb)-> setTimeout cb, ms
execute = (cb)->
  r.get "http://bash.org.pl/random", (err, res, body)->
    if err || res.statusCode != 200
      cb 'dupa'

    $ = cheerio.load body.toString()

    html =  $('.quote').html().replace(/<br>/gm, '\n')
    html =  $('.quote').html()
    $box = $('<div>')
    $box.append html
    text = $box.text()
    text = $box.text().replace(/^\s+/, '').replace(/\s+$/mg,'')

    if text.split('\n').length <= 3
      cb text
    else
      delay 200, -> execute cb

register = (channel)->
  channel.on 'message', (msg, from)->

    match = msg.match /;bash/
    if match
      execute (res)->
        lines = res.split '\n'
        for line in lines
          channel.send "#{from}: #{line}"

module.exports = register: register, execute: execute
if require.main == module
  execute console.log

