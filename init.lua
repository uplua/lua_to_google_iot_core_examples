mytimer = tmr.create()
station_cfg={}
station_cfg.ssid="Gaurav"  -- Enter SSID here
station_cfg.pwd="kumar123"  -- Enter password here


wifi.setmode(wifi.STATION)  -- set wi-fi mode to station
wifi.sta.config(station_cfg)-- set ssid&pwd to config
wifi.sta.connect(1)         -- connect to router

ip = wifi.sta.getip()       -- IP address of the connected access point 

print(ip)

    sensorID = "temperature_001"    -- a sensor identifier for this device
    tgtHost = "177.52.222.14" -- target host (broker)
    tgtPort = 1883          -- target port (broker listening on)
    mqttUserID = "unused"     -- account to use to log into the broker
    mqttPass = "unused"     -- broker account password
    mqttTimeOut = 120       -- connection timeout
    dataInt = 1         -- data transmission interval in seconds
    topicQueue = "gsocTopic/temperature"    -- the MQTT topic queue to use


    function pubEvent()
        --rv = adc.read(0)                -- read light sensor
        rv = 999
        pubValue = sensorID .. " " .. rv        -- build buffer
        print("Publishing to " .. topicQueue .. ": " .. pubValue)   -- print a status message
        mqttBroker:publish(topicQueue, pubValue, 0, 0)  -- publish
    end

    function reconn()
        print("Disconnected, reconnecting....")
        conn()
    end

     
    function conn()
        print("Making connection to MQTT broker")
        mqttBroker:connect(tgtHost, tgtPort, 0,0, function(client) print ("connected") end, function(client, reason) print("failed reason: "..reason) end)
    end

       
    function makeConn()
        -- Instantiate a global MQTT client object
        print("Instantiating mqttBroker")
        mqttBroker = mqtt.Client(sensorID, mqttTimeOut, mqttUserID, mqttPass, 1)
     
        -- Set up the event callbacks
        print("Setting up callbacks")
        mqttBroker:on("connect", function(client) print ("connected") end)
        mqttBroker:on("offline", reconn)
     
        -- Connect to the Broker
        conn()
        -- tmr.alarm(1000, tmr.ALARM_AUTO, pubEvent)
        -- Use the watchdog to call our sensor publication routine
        -- every dataInt seconds to send the sensor data to the 
        -- appropriate topic in MQTT.
        mytimer:alarm(1000, tmr.ALARM_AUTO, pubEvent)
    end

    makeConn()
     
     
