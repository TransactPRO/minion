# Description:
#   Send messages to all chat rooms.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_ANNOUNCE_ROOMS - comma-separated list of rooms
#
# Commands:
#   hubot обьявление "<сообщение>" - Посылает сообщение во все комнаты.
#
# Author:
#   Morgan Delagrange

module.exports = (robot) ->

  if process.env.HUBOT_ANNOUNCE_ROOMS
    allRooms = process.env.HUBOT_ANNOUNCE_ROOMS.split(',')
  else
    allRooms = []

  robot.respond /обьявление "(.*)"/i, (msg) ->
    announcement = msg.match[1]
    for room in allRooms
      robot.messageRoom room, announcement

