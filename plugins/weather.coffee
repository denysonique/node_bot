r       = require 'request'
cheerio = require 'cheerio'

r = r.defaults followAllRedirects: true

pogoda = (city, cb)->
  city = city.toString()


  r.post 'http://www.pogodynka.net',form:city:city, (err, res, body)->

    $ = cheerio.load body.toString()
    $el = $('.block-weather').eq(0)

    miasto = $('.header.left > h2').eq(0).text()
    opis   = $el.find('.weather-desc').text()
    cis    = $el.find('li:contains(Ciśnienie: ) span').text()
    wiatr  = $el.find('li:contains(Wiatr: ) span').text()
    temp   = $el.find('.temp').text()

    opis = opis.replace /\.$/, ''

    if miasto
      cb "#{miasto}: #{opis} | #{temp} | #{wiatr} | #{cis}"
    else
      cb "Brak wyników dla '#{city}'"

module.exports = pogoda
#pogoda('Londyn', console.log)





