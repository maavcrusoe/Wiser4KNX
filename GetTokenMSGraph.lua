https = require('ssl.https')
json = require('json')
ltn12 = require('ltn12')

--variables
clientID = 'xxxxxxxxx'
tenantName = 'xxxxxx.onmicrosoft.com'
clientSecret = 'xxxxxxxxx'
url_token = "https://login.microsoftonline.com/".. tostring(tenantName) .. "/oauth2/v2.0/token"

--componer peticion token
ReqTokenBody = "client_id=" .. clientID .. "&scope=https%3A%2F%2Fgraph.microsoft.com%2F.default&client_secret=" .. clientSecret .. "&grant_type=client_credentials"


function GetTokenMSGraph()
  local response_body = {}
  local export_data = {}

  res, code = https.request({
    url = url_token,
    method = 'POST',
    protocol = 'tlsv12',
    headers = {
      ['Content-Type'] = 'application/x-www-form-urlencoded';
      ['Content-Length'] = #ReqTokenBody;
      ['Host'] = 'login.microsoftonline.com';    
    };
    source = ltn12.source.string(ReqTokenBody);
    sink = ltn12.sink.table(response_body);
  })
  --log(res, code)
  if code == 200 then
      response_decode = json.decode(table.concat(response_body))
      --log(response_decode)
        token = response_decode["access_token"] 
        --log(token)
      return token 
  end
end
