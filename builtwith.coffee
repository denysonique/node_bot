r = require 'request'
$ = require 'jquery'

r = r.defaults followAllRedirects: true

delay = (ms,cb)-> setTimeout cb, ms

builtwith = (site_url, cb)->
  site_url = site_url.toString()

  r.get "http://builtwith.com/#{site_url}", (err, res, body)->
    if err || res.statusCode != 200
      console.log err, res.statusCode
      cb 'dupa'
      return

    $('body').html(body.toString())

    items =
      Server    : "Server Information"
      Frameworks: "Frameworks"
      CMS       : "Content Management Systems"
      JS        : "JavaScript Libraries"
      Hosting   : "Hosting Providers"


    reply = []
    for k, v of items
      content = $(".titleBox:contains(#{v})")
                .nextUntil('.titleBox').find('h3')
                .map (ix, i)->
                  $(i).text().trim()
      content = content.toArray().join ', '
      reply.push "*#{k}*: #{content}" if content


    cb reply.join('; ')

module.exports = builtwith
