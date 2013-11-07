r = require 'request'

register = (channel)->
  channel.on 'message', (msg, from)->
    regex = /http:[/][/](?:www)[.]youtube[.]com[/]watch[?]v=([A-z|0-9|-]*)/

    match = msg.match regex
    if match
      r.get "https://gdata.youtube.com/feeds/api/videos/#{match[1]}?v=2&alt=json", (err, res, body)->
        if res.statusCode != 200
          return

        json = JSON.parse body.toString()
        console.log 'json',json
        title = json.entry.title.$t
        channel.send "YouTube: #{title}"
module.exports =  register: register
