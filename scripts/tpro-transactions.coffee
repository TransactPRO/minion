# Description:
#  Инициализирует транзакции и осуществляет снятие средств с карты
#
# Configuration:
#  HUBOT_TPRO_API_URL - url API
#  HUBOT_TPRO_GUID - GUID торговца
#  HUBOT_TPRO_PWD - пароль торговца
#  HUBOT_TPRO_RS - строка маршрутизации
#  HUBOT_TPRO_USER_IP - IP пользователя
#
# Commands:
#  hubot charge|сними <сумма в MINOR величине>
#
# Author:
#  Sergey Kibish

sha1 = require('sha1');

apiUrl  = process.env.HUBOT_TPRO_API_URL
guid    = process.env.HUBOT_TPRO_GUID
pwd     = process.env.HUBOT_TPRO_PWD
rs      = process.env.HUBOT_TPRO_RS
user_ip = process.env.HUBOT_TPRO_USER_IP

module.exports = (robot) ->
  robot.respond /(charge|сними) (.*)/i, (msg) ->
    amount = msg.match[2]
    if /\D+$/.test(amount)
      msg.send "Я не могу снять \"#{amount}\"..."
    else
      data = require('querystring').stringify({
        'apiUrl'                  : apiUrl,
        'guid'                    : guid,
        'pwd'                     : sha1(pwd),
        'rs'                      : rs,
        'merchant_transaction_id' : (new Date().getTime()),
        'user_ip'                 : user_ip,
        'description'             : 'Test description',
        'amount'                  : amount,
        'currency'                : 'USD',
        'name_on_card'            : 'Vasyly Pupkin',
        'street'                  : 'Main street 1',
        'zip'                     : 'LV-0000',
        'city'                    : 'Riga',
        'country'                 : 'LV',
        'state'                   : 'NA',
        'email'                   : 'email@example.lv',
        'phone'                   : '+371 11111111',
        'card_bin'                : '511111',
        'bin_name'                : 'BANK',
        'bin_phone'               : '+371 11111111',
        'merchant_site_url'       : 'http://www.example.com'})

      msg.http(apiUrl + "gwprocessor2.php?a=init")
        .header('content-type', 'application/x-www-form-urlencoded')
        .post(data) (err, res, body) ->
          arr = body.split(':')

          chargeData = require('querystring').stringify({
            'f_extended'              : '5',
            'init_transaction_id'     : arr[1],
            'cc'                      : '5413330000000027',
            'cvv'                     : '111',
            'expire'                  : '01/15'})

          msg.http(apiUrl + "gwprocessor2.php?a=charge")
            .header('content-type', 'application/x-www-form-urlencoded')
            .post(chargeData) (err, res, body) ->
              msg.send "С Вашей карты было снято #{amount/100}$"
              msg.send res.statusCode + "\n" + body
