r       = require 'request'
cheerio = require 'cheerio'

r = r.defaults followAllRedirects: true

delay = (ms,cb)-> setTimeout cb, ms
random = -> Math.floor(Math.random() * 14) + 1
rofl = (cb)->
  r.get "http://roflcopter.pl/top/#{random()}", (err, res, body)->
    if err || res.statusCode != 200
      cb 'dupa'

    $ = cheerio.load body.toString()

    i = 0
    get_rofl = (cb)->
      i++
      $rofl = $('.rofl').eq random() - 1
      html = $rofl.html().replace /<br>/gm, '\n'
      $box = $('<div>')
      $box.append html
      text = $box.text()
      text = $box.text().replace(/^\s+/, '').replace(/\s+$/mg,'')

      if text.split('\n').length <= 3
        cb text
      else
        if i >= 50
          delay 200, -> rofl cb
        else
          get_rofl cb

    get_rofl cb

module.exports = rofl
if require.main == module
  rofl console.log

