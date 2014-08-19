# Description:
#   Messing around with the YouTube API.
#
# Commands:
#   hubot youtube|ютуб <запрос> - Ищет в Youtube видео по заданному запросу
module.exports = (robot) ->
  robot.respond /(youtube|yt|ютуб) (.*)/i, (msg) ->
    query = msg.match[2]
    robot.http("http://gdata.youtube.com/feeds/api/videos")
      .query({
        orderBy: "relevance"
        'max-results': 15
        alt: 'json'
        q: query
      })
      .get() (err, res, body) ->
        videos = JSON.parse(body)
        videos = videos.feed.entry

        unless videos?
          msg.send "По запросу \"#{query}\" видео не найдено."
          return

        video  = msg.random videos
        video.link.forEach (link) ->
          if link.rel is "alternate" and link.type is "text/html"
            msg.send link.href

