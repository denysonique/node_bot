cheerio = require 'cheerio'
r       = require 'request'
_       = require 'underscore'

r = r.defaults followAllRedirects: true


execute = (args, cb)->
  args = args.trim().split()
  args = null if args && args.length == 1 && args[0] == ''

  url = 'http://www.cdc.gov/vhf/ebola/outbreaks/2014-west-africa/case-counts.html'

  r.get url, (err, res, body)->
    $ = cheerio.load body.toString()

    
    cases = 
      by_country: {}
      by_type:
        widespread:
          cases:  parseInt $('#cases-widespread').find('tr').last().find('td').eq(1).text()
          deaths: parseInt $('#cases-widespread').find('tr').last().find('td').eq(3).text()
        travel_associated:
          cases:  parseInt $('#cases-travel-associated').find('tr').last().find('td').eq(1).text()
          deaths: parseInt $('#cases-travel-associated').find('tr').last().find('td').eq(3).text()
        localized_transmission:
          cases:  parseInt $('#cases-localized-transmission').find('tr').last().find('td').eq(1).text()
          deaths: parseInt $('#cases-localized-transmission').find('tr').last().find('td').eq(3).text()



    by_type = cases['by_type']
    _(cases).extend
      total: by_type['widespread']['cases'] + by_type['travel_associated']['cases'] + by_type['localized_transmission']['cases']
      deaths: by_type['widespread']['deaths'] + by_type['travel_associated']['deaths'] + by_type['localized_transmission']['deaths']

    case_selectors = []

    case_selectors.push '#cases-widespread tbody tr'
    case_selectors.push '#cases-travel-associated tbody tr'
    case_selectors.push '#cases-localized-transmission tbody tr'

    case_selectors.forEach (selector)->
      _($(selector)).pop().each (index, item)->

        country = $(item).find('td').first().text()
        cases['by_country'][country] =
          cases: $(item).find('td').eq(1).text()
          deaths: $(item).find('td').eq(3).text()


    if args

      if args[0] == 'listall'
        out = "Ebola by country ⇛ "

        _(cases.by_country).each (values, country)->
          out += "#{country} ❱❱ ☣ #{values.cases} ☠ #{values.deaths} |"
        cb out

    else
      cb "Ebola cases worldwide ⇛ Total: ☣ #{cases['total']}, Deaths: ☠ #{cases['deaths']}"




register = (channel)->
  channel.on 'message', (msg, from)->
    

    regex = /^;ebola(.*)$/
    match = msg.match regex
    console.log 'ebola match ', match
    if match
      execute match[1], (res)->
        channel.send "#{res}"




module.exports = register: register, execute: execute
if require.main == module
  execute '', console.log

