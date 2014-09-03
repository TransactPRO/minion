# Description:
#  Инициализирует транзакции и осуществляет снятие средств с карты
#
# Configuration:
#  HUBOT_TPRO_API_URL - url API
#  HUBOT_TPRO_GUID - GUID торговца
#  HUBOT_TPRO_PWD - пароль торговца
#  HUBOT_TPRO_RS - строка маршрутизации
#  HUBOT_TPRO_USER_IP - IP пользователя
#  HUBOT_TPRO_CC - номер кредитной карты
#  HUBOT_TPRO_CVV - cvv
#  HUBOT_TPRO_EXPIRE - срок годности карты
#
# Commands:
#  hubot charge|сними <сумма в MINOR величине>
#  hubot charge|сними <сумма в MINOR величине> <валюта>
#
# Author:
#  Sergey Kibish

sha1 = require('sha1');

apiUrl = process.env.HUBOT_TPRO_API_URL
guid = process.env.HUBOT_TPRO_GUID
pwd = process.env.HUBOT_TPRO_PWD
rs = process.env.HUBOT_TPRO_RS
user_ip = process.env.HUBOT_TPRO_USER_IP
cc = process.env.HUBOT_TPRO_CC
cvv = process.env.HUBOT_TPRO_CVV
expire = process.env.HUBOT_TPRO_EXPIRE

module.exports = (robot) ->
  robot.respond /(charge|сними) (.*)/i, (msg) ->
    input = msg.match[2].split(" ")
    amount = input[0]
    currency = 'USD'
    if input[1] != undefined
      currency = input[1].toUpperCase()
    if /\D+$/.test(amount)
      msg.send "Я не могу снять \"#{amount}\"..."
    else
      data = require('querystring').stringify({
        'apiUrl' : apiUrl,
        'guid' : guid,
        'pwd' : sha1(pwd),
        'rs' : rs,
        'merchant_transaction_id' : (new Date().getTime()),
        'user_ip' : user_ip,
        'description' : 'Test description',
        'amount' : amount,
        'currency' : currency,
        'name_on_card' : 'Vasyly Pupkin',
        'street' : 'Main street 1',
        'zip' : 'LV-0000',
        'city' : 'Riga',
        'country' : 'LV',
        'state' : 'NA',
        'email' : 'email@example.lv',
        'phone' : '+371 11111111',
        'card_bin' : '511111',
        'bin_name' : 'BANK',
        'bin_phone' : '+371 11111111',
        'merchant_site_url' : 'http://www.example.com'})

      msg.http(apiUrl + "gwprocessor2.php?a=init")
        .header('content-type', 'application/x-www-form-urlencoded')
        .post(data) (err, res, body) ->
          arr = body.split(':')
          message = body

          chargeData = require('querystring').stringify({
            'f_extended' : '5',
            'init_transaction_id' : arr[1],
            'cc' : cc,
            'cvv' : cvv,
            'expire' : expire})

          msg.http(apiUrl + "gwprocessor2.php?a=charge")
            .header('content-type', 'application/x-www-form-urlencoded')
            .post(chargeData) (err, res, body) ->
              if (body.indexOf('ERROR') > -1)
                if (message.indexOf('OK') > -1)
                  msg.send body
                else
                  msg.send message.replace("<pre>","")
              else if (body.indexOf('Redirect') > -1)
                console.log("OKR")
                msg.send "Я 3D или редирект на гейт делать не буду :E]"
              else
                msg.send body
                msg.send "С Вашей карты было снято #{amount/100} #{currency}"

                refundData = require('querystring').stringify({
                  'account_guid': guid,
                  'pwd': sha1(pwd),
                  'init_transaction_id': arr[1],
                  'amount_to_refund': amount})

                msg.http(apiUrl + "gwprocessor2.php?a=refund")
                  .header('content-type', 'application/x-www-form-urlencoded')
                  .post(refundData) (err, res, body) ->
                     msg.send body
