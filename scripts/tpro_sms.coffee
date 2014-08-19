# Description:
#  Initializes simple sms transaction with charge
#
# Commands:
#  hubot charge me <amount to charge in MINOR units>
#  hubot charge <amount> <routing string> <guid>

misc = require('../misc.js');
config = require('../config.js');

apiUrl  = config.apiUrl
guid    = config.guid
pwd     = config.pwd
rs      = config.rs
user_ip = config.user_ip

module.exports = (robot) ->
  robot.respond /charge me (.*)/i, (msg) ->
    if /\D+$/.test(msg.match[1])
      msg.send "I can't charge #{msg.match[1]}..."
    else
      data = require('querystring').stringify({
        'apiUrl'                  : apiUrl,
        'guid'                    : guid,
        'pwd'                     : misc.sha1(pwd),
        'verifySSL'               : false,
        'rs'                      : rs,
        'merchant_transaction_id' : misc.time(),
        'user_ip'                 : user_ip,
        'description'             : 'Test description',
        'amount'                  : msg.match[1],
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
              msg.send "You are charged for #{msg.match[1]/100}$\nCheck out this transaction #{arr[1]}, yo!"

  robot.respond /charge (.*) (.*) (.*)/i, (msg) ->
    data = require('querystring').stringify({
      'apiUrl'                  : apiUrl,
      'guid'                    : msg.match[3],
      'pwd'                     : misc.sha1(pwd),
      'verifySSL'               : false,
      'rs'                      : msg.match[2],
      'merchant_transaction_id' : misc.time(),
      'user_ip'                 : user_ip,
      'description'             : 'Test description',
      'amount'                  : msg.match[1],
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
            msg.send "You are charged for #{msg.match[1]/100}$\nCheck out this transaction #{arr[1]}, yo!"
