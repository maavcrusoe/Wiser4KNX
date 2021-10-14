
-- send an e-mail
function mail(to, subject, message)
  -- make sure these settings are correct
  local settings = {
    -- "from" field, only e-mail must be specified here
    from = 'mail@domain.com',
    -- smtp username
    -- smtp password
    -- smtp server
    server = 'x.x.x.x',
    -- smtp server port
    port = 25,
    -- enable tls, required for gmail smtp
    --secure='sslv23',
  }

  local smtp = require('socket.smtp')

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

-- Get value from object
inundacion = grp.getvalue('x/x/x')

to = 'destination@domain.com'
subjet = 'SUBJECT HERE'

-- wait for 1.5 seconds to obtain correct value from other object
os.sleep(1.5)

if inundacion==true then
	--obtain value from object
  read = grp.getvalue('x/x/x')
  log ('valor:', read)
  msg = read
  --send email right now
  res, err = mail(to,subjet,msg)
  log(res, err) 
end
