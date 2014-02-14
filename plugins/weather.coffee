r       = require 'request'
cheerio = require 'cheerio'

r = r.defaults followAllRedirects: true

pogoda = (city, cb)->
  city = city.toString()


  url = "http://pogoda.interia.pl/suggest/geo?s=#{city}&limit=11&timestamp=#{Date.now()}"
  r.get url, (err, res, body)->
    res = JSON.parse body.toString()
    id = res.items[0].id
    r.get "http://pogoda.interia.pl/,cId,#{id}", (err, res, body)->

      $ = cheerio.load body.toString()
      opis = $('.weather-currently-icon-description').text().trim()
      temp = $('.weather-currently-temp-strict').text().trim()
      odcz = $('.weather-currently-temp-actual-value').text().trim()
      miasto = $('.weather-currently-city').text().trim()

      if miasto
        cb "#{miasto}: #{opis} #{temp} | Temperatura Odczuwalna: #{odcz}"
      else
        cb "Brak wyników dla '#{city}'"

module.exports = pogoda

if require.main == module
  pogoda 'londyn', console.log





