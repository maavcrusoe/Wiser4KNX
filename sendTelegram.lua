https = require('ssl.https')

local token = 'xxxxxxx' -- your token
local chat_id = 'xxxxxx' -- chat id BT
--local url = 'https://api.telegram.org/botxxxxxxxxxx/getUpdates'

function telegram(message)
  telegram_url = 'https://api.telegram.org/bot'.. tostring(token).. '/sendMessage?chat_id='.. tostring(chat_id).. '&text=' .. tostring(message)
  message=socket.url.escape(message)
  local data_str = 'chat_id=' .. chat_id .. '&text=' .. message..''
  local res, code, headers, status = ssl.https.request({
    url = telegram_url,
  	protocol = 'tlsv12'})
	--log(telegram_url, message, data_str, res, code, headers, status, ssl.https.request)
end

--obtain value from object
read = grp.getvalue('0/0/0')

res, err = telegram(read)
