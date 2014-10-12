cheerio = require 'cheerio'
r       = require 'request'
_       = require 'underscore'

r = r.defaults followAllRedirects: true


execute = (url, cb)->
  url = 'http://' + url unless url.match /^https?:[/][/]/

  r.get url, (err, res, body)->
    $ = cheerio.load body.toString()

    
    title = $('title').text().split(/\s/)[0]
    desc = $('.repository-meta').text().replace(/\s+/g, ' ').trim()
    stars = $('.social-count').eq(0).text().trim()
    forks = $('.social-count').eq(1).text().trim()
    out = "#{title} |★ #{stars}| |⑂ #{forks}| #{desc}"
    cb out if stars

register = (channel)->
  channel.on 'message', (msg, from)->

    regex = /(?:https?:[/][/])?(?:www.)?github[.]com[^\s]*/
    match = msg.match regex
    console.log 'match ', match
    if match
      execute match[0], (res)->
        channel.send "↳ #{res}"




module.exports = register: register, execute: execute
if require.main == module
  execute 'http://github.com/denysonique/node_bot', console.log

