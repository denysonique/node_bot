r       = require 'request'
cheerio = require 'cheerio'

r = r.defaults followAllRedirects: true

delay = (ms,cb)-> setTimeout cb, ms

java = (cb)->
  r.get "http://java-0day.com", (err, res, body)->
    if err || res.statusCode != 200
      cb 'dupa'
      return

    body = body.toString()




    last0day = body.match(/var lastzeroday = new Date\("(.*)"\);/)
    last0day = new Date last0day
    today = new Date
    since = today.getTime() - last0day.getTime()
    days = Math.round since / 1000 / 60 / 60 / 24


    r.get "http://istherejava0day.com/", (err, res, body)->
      $ = cheerio.load body.toString()
      still_threat = $('#answer').text().trim()
      console.log 'st', still_threat

      switch still_threat
        when 'YES'
          patched = 'No'
        when 'NO'
          patched = 'Yes'
        else
          cb "dupa"
          return

      cb "#{days} days since last known Java 0-day exploit. Patched: #{patched}. — http://java-0day.com"



module.exports = java




