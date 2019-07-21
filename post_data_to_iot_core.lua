
  local http = require"socket.http"
  local ltn12 = require"ltn12"

  local reqbody = "Hello"
  local respbody = {} -- for the response body

  local result, respcode, respheaders, respstatus = http.request {
      method = "POST",
      url = "https://cloudiotdevice.googleapis.com/v1/projects/luabigquery/locations/us-central1/registries/registry1/devices/esp32:publishEvent",
      source = ltn12.source.string(reqbody),
      headers = {
          ["content-type"] = "aplication/json",
          -- The authorization Bearer jwt token needs to be regenerated after every 60 minutes. 
          ["authorization"] = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpYXQiOjE1NjM3MjcwNjksImV4cCI6MTU2MzczMDY2OSwiYXVkIjoibHVhYmlncXVlcnkifQ.nCZzwpG5ZzU4HtcEWaZVDoY7hdKfCP0abAqPNFQwScxYpDL2lf3ZzwWNI9Z50Pd73ilfoWgH8xWF5BRQ1v_InQ",
          ["cache-control"] = "no-cache"  
      },
      sink = ltn12.sink.table(respbody)
  }
  -- get body as string by concatenating table filled by sink
  respbody = table.concat(respbody)
