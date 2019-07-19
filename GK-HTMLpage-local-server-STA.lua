station_cfg={}
station_cfg.ssid="NETGEAR81"  -- Enter SSID here
station_cfg.pwd="imaginarypiano1"  -- Enter password here


wifi.setmode(wifi.STATION)  -- set wi-fi mode to station
wifi.sta.config(station_cfg)-- set ssid&pwd to config
wifi.sta.connect(1)         -- connect to router

ip = wifi.sta.getip()       -- IP address of the connected access point 

print(ip)

LEDpin = 2                  -- declare LED pin
gpio.mode(LEDpin, gpio.OUTPUT)
server = net.createServer(net.TCP)-- create TCP server

function SendHTML(sck, led) -- Send LED on/off HTML page
   htmlstring = "<!DOCTYPE html>\r\n"
   htmlstring = htmlstring.."<html>\r\n"
   htmlstring = htmlstring.."<head>\r\n"
   htmlstring = htmlstring.."<title>LED Control</title>\r\n"
   htmlstring = htmlstring.."</head>\r\n"
   htmlstring = htmlstring.."<body>\r\n"
   htmlstring = htmlstring.."<h1>LED</h1>\r\n"
   htmlstring = htmlstring.."<p>Click to switch LED on and off.</p>\r\n"
   htmlstring = htmlstring.."<form method=\"get\">\r\n"
  if (led)  then
   htmlstring = htmlstring.."<input type=\"button\" value=\"LED OFF\" onclick=\"window.location.href='/ledoff'\">\r\n"
  else
   htmlstring = htmlstring.."<input type=\"button\" value=\"LED ON\" onclick=\"window.location.href='/ledon'\">\r\n"
  end
   htmlstring = htmlstring.."</form>\r\n"
   htmlstring = htmlstring.."</body>\r\n"
   htmlstring = htmlstring.."</html>\r\n"
   sck:send(htmlstring)
end

function receiver(sck, data)-- process callback on recive data from client
  if string.find(data, "GET /ledon")  then
   SendHTML(sck, true)
   gpio.write(LEDpin, gpio.HIGH)
  elseif string.find(data, "GET / ") or string.find(data, "GET /ledoff") then
   SendHTML(sck, false)
   gpio.write(LEDpin, gpio.LOW)
  else
   sck:send("<h2>Not found...!!</h2>")
   sck:on("sent", function(conn) conn:close() end)
  end
end

if server then
  server:listen(80, function(conn)-- listen to the port 80
  conn:on("receive", receiver)
  end)
end
count = 0 
while ( count < 10 ) do
    count = count + 1
    tmr.delay(1000000)
    print(ip)
end