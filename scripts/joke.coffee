# Description:
#   Hubot tells a joke.
#
# Commands:
#   шутка - Рассказывает шутку.


module.exports = (robot) ->
  robot.hear /шутка/i, (msg) ->
    msg.http("http://developerslife.ru/random?json=true")
      .header('User-Agent', 'Mozilla/5.0')
      .get() (err, res, body) ->
          msg.send JSON.parse(body).description + ' ' + JSON.parse(body).gifURL
