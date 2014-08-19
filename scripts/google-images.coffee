# Description:
#   Способ работы с Google Images API.
#
# Commands:
#   hubot покажи мне <запрос> - Ищет картинки по <запрос> и возвращает случайный лучший результат.
#   hubot анимируй мне <query> - То же самое что и "покажи мне", но возврашает гифку.

module.exports = (robot) ->
  robot.respond /(image|img|покажи)( me| мне)? (.*)/i, (msg) ->
    imageMe msg, msg.match[3], (url) ->
      msg.send url

  robot.respond /(animate|анимируй)( me| мне)? (.*)/i, (msg) ->
    imageMe msg, msg.match[3], true, (url) ->
      msg.send url

imageMe = (msg, query, animated, faces, cb) ->
  cb = animated if typeof animated == 'function'
  cb = faces if typeof faces == 'function'
  q = v: '1.0', rsz: '8', q: query, safe: 'active'
  q.imgtype = 'animated' if typeof animated is 'boolean' and animated is true
  q.imgtype = 'face' if typeof faces is 'boolean' and faces is true
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData?.results
      if images?.length > 0
        image = msg.random images
        cb ensureImageExtension image.unescapedUrl
      else
        msg.send "Прости. Но я не смог найти '#{query}'. :("

ensureImageExtension = (url) ->
  ext = url.split('.').pop()
  if /(png|jpe?g|gif)/i.test(ext)
    url
  else
    "#{url}#.png"
