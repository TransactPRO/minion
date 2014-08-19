# Description:
#   Генерирует подсказки для бота.
#
# Commands:
#   hubot помощь - Показывает все команды о которрых боту известно.
#   hubot помощь <query> - Показывает все команды которые попадает под <query>
#
# Notes:
#   These commands are grabbed from comment blocks at the top of each file.

module.exports = (robot) ->
  robot.respond /(help|помощь)\s*(.*)?$/i, (msg) ->
    cmds = robot.helpCommands()
    filter = msg.match[2]

    if filter
      cmds = cmds.filter (cmd) ->
        cmd.match new RegExp(filter, 'i')
      if cmds.length == 0
        msg.send "По запросу '#{filter}' ничего не найдено."
        return

    prefix = robot.alias or robot.name
    cmds = cmds.map (cmd) ->
      cmd = cmd.replace /hubot/ig, robot.name
      cmd.replace new RegExp("^#{robot.name}"), prefix

    emit = cmds.join "\n"

    msg.send emit
