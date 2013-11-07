r = require 'request'
r = r.defaults followRedirect: false, followAllRedirects: false
http = require 'http'
execute = (url, cb)->
  unless url.match /^https?:[/][/]/
    url = "http://#{url}"

  r.get url, (err, res, body)->
    if err
      cb err
      return

    res_array = []
    code_desc = http.STATUS_CODES[res.statusCode] || ''
    res_array.push "*HTTP/#{res.httpVersion} #{res.statusCode} #{code_desc}*"
    for k, v of res.headers
      res_array.push "*#{k.toString().trim()}:* #{v.toString().trim()}"

    res = res_array.join ' | '

    lines = res.match /.{1,400}/g
    cb lines


register = (channel)->
  channel.on 'message', (msg, from)->

    match = msg.match /^;head(?:ers)? (.*)$/

    if match
      execute match[1], (lines)->
        for line in lines
          channel.send "#{from}: #{line}"

module.exports = register: register, execute: execute
if require.main == module
  execute 'http://gentoo.org', console.log

