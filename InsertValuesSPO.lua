function WiserKNX(value) 
  local response_body = {}
  --log(tokenMSgraph)
  log(value)
  
  time = os.date('%Y-%m-%d %H:%M:%S', os.time())
  
  title = 'Tienda CO2'
  url = "https://graph.microsoft.com/v1.0/groups/xxxxxxxxx/sites/root/lists/xxxxxx/items"
  insert = "{ 'fields': {'Title': '".. title .."' ,'value': '"..value.."','tiempo': '"..time.."'}}" 
  
  log(insert) 
    res, code = https.request({
    url = url,
    method = 'POST',
    protocol = 'tlsv12',
    headers = {
      ['authorization'] = 'Bearer ' .. tokenMSgraph,
        ['content-type']  = 'application/json',
           ['content-length'] = #insert,
    };
    source = ltn12.source.string(insert);
    sink = ltn12.sink.table(response_body);
  })

  log(res, code)
end

--read value from KNX  
read = grp.getvalue('x/x/x')
WiserKNX(read)
