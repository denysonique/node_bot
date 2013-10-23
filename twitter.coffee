r       = require 'request'
cheerio = require 'cheerio'
qs      = require 'querystring'

r = r.defaults followAllRedirects: true

twitter = (term, cb)->
  term = term.toString()
  params = qs.stringify q: term

  r.get "https://mobile.twitter.com/search?#{params}", (err, res, body)->
    if err || res.statusCode != 200
      cb 'dupa'

    $ = cheerio.load body.toString()


    $tweets = $('.tweet')

    $tweet = $tweets.eq Math.floor(Math.random() * $tweets.length) + 1

    $tweet.find('a[href]').each (index, item)->
      $item = $(item)
      $item.html $item.data('url')

    tweet_text = $tweet.find('.tweet-text').text()
    username   = $tweet.find('.username').text().trim()
    timestamp  = $tweet.find('.timestamp').text().trim()



    cb "#{tweet_text} — #{username} #{timestamp}"


module.exports = twitter





