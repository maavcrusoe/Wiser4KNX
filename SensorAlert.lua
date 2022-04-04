https = require('ssl.https')

--vars
local token = 'XXXXXXXX' -- your token
local chat_id = 'xxxxxxx' -- chat id BT
--local url = 'https://api.telegram.org/botXXXXXXXXXXXXXX/getUpdates'
to = 'email@domain.com'
subjet = 'SUBJECT'
message = 'MESSAGE BODY.'
local smtp = require('socket.smtp')


-- send an e-mail
function mail(to, subject, message)
  -- make sure these settings are correct
  local settings = {
    -- "from" field, only e-mail must be specified here
    from = 'emailfrom@domain.com',
    -- smtp username
    --user = 
    -- smtp password
    --password = 
    -- smtp server
    server = 'SERVER_IP',
    -- smtp server port
    port = 25,
    -- enable tls, required for gmail smtp
    --secure = 'tlsv1_2',
    --secure = 'starttls',
    --secure='sslv23',
    
  }

-- function send msg
function telegram(message)
  --local telegram_url = 'https://api.telegram.org/bot' .. token .. '/sendMessage?'
  telegram_url = 'https://api.telegram.org/bot'.. tostring(token).. '/sendMessage?chat_id='.. tostring(chat_id).. '&text=' .. tostring(message)
  message=socket.url.escape(message)
  local data_str = 'chat_id=' .. chat_id .. '&text=' .. message..''
  local res, code, headers, status = ssl.https.request({
    url = telegram_url,
    -- USE tlsv12 
  	protocol = 'tlsv12'})

	log(telegram_url, message, data_str, res, code, headers, status, ssl.https.request)
  end
  
  -- send email
  if type(to) ~= 'table' then
    to = { to }
  end

  for index, email in ipairs(to) do
    to[ index ] = '<' .. tostring(email) .. '>'
  end

  -- fixup from field
  local from = '<' .. tostring(settings.from) .. '>'

  -- message headers and body
  settings.source = smtp.message({
    headers = {
      to = table.concat(to, ', '),
      subject = subject,
      ['From'] = from,
      ['Content-type'] = 'text/html; charset=utf-8',
    },
    body = message
  })

  --log (message)
  --log (grp.getvalue('2/7/1'))
  
  settings.from = from
  settings.rcpt = to
  res, err = smtp.send(settings)
  return res,err

 end

sensor = grp.getvalue('2/7/0')


-- wait for 1.5 seconds to read bus
os.sleep(1.5)


if sensor==true then
	read = grp.getvalue('2/7/1')
  log ('valor:', read)
  msg = read
  
  res, err = mail(to,subjet,msg)
  log(res, err) 
  
  msg = '🚨error ' .. tostring(read)
  res, err = telegram(msg)
end

if inundacion==false then
	read = grp.getvalue('2/7/1')
  msg = read
  
  res, err = mail(to,subjet,msg)
  log(res, err) 
  
  msg = '✅all okey' .. tostring(read)
  res, err = telegram(msg)
end




