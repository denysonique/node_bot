r       = require 'request'
cheerio = require 'cheerio'
qs      = require 'querystring'

r = r.defaults followAllRedirects: true

delay = (ms,cb)-> setTimeout cb, ms
bash = (cb)->
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
      delay 200, -> bash cb



module.exports = bash
