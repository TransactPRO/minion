# Description:
#   Hubot tells a joke.
#
# Commands:
#   анекдот - Рассказывает анекдот.


module.exports = (robot) ->
  robot.hear /анекдот/i, (msg) ->    
    msg.http("http://rzhunemogu.ru/RandJSON.aspx?CType=1")
      .header('User-Agent', 'Mozilla/5.0')
      .get() (err, res, body) ->
          msg.send JSON.parse(body).content
