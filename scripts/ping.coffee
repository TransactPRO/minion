# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot ping - Отвечает pong
#   hubot echo <text> - Овечает <text>
#   hubot time - Отвечает текущим временем
#   hubot die - Убивает бота :(

module.exports = (robot) ->
  robot.respond /PING$/i, (msg) ->
    msg.send "PONG"

  robot.respond /ADAPTER$/i, (msg) ->
    msg.send robot.adapterName

  robot.respond /ECHO (.*)$/i, (msg) ->
    msg.send msg.match[1]

  robot.respond /TIME$/i, (msg) ->
    msg.send "Время на сервере: #{new Date()}"

  robot.respond /DIE$/i, (msg) ->
    msg.send "Прощай, этот жестокий мир."
    process.exit 0

