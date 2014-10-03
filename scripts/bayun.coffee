# Description:
#   Hubot tells a joke.
#
# Commands:
#   анекдот - Рассказывает анекдот.


module.exports = (robot) ->
  robot.hear /анекдот/i, (msg) ->    
    msg.http("http://rzhunemogu.ru/Rand.aspx?CType=1")
      .header('User-Agent', 'Mozilla/5.0')
      .get() (err, res, body) ->
          data = body.replace('<?xml version="1.0" encoding="utf-8"?><root><content>', '').replace('</content></root>', '')
          
          msg.send "#{data}"
