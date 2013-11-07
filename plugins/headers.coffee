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
      res_array.push "*#{k.trim()}:* #{v.trim()}"

    res = res_array.join ' | '
    cb res


register = (channel)->
  channel.on 'message', (msg, from)->

    match = msg.match /^;head(?:ers)? (.*)$/

    if match
      execute match[1], (res)->
        channel.send "#{from}: #{res}"

module.exports = register: register, execute: execute
if require.main == module
  execute 'http://gentoo.org', console.log

