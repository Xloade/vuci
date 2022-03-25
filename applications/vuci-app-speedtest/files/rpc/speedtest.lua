Curl = require 'cURL'
Json = require 'vuci.json'

Speedtest = {}

function GetJsonFromFile(file)
    local fhandle = assert(io.open(file, "r"))
    local jsonTxt = fhandle:read("*all")
    local json = Json.decode(jsonTxt)
    return json
end

function FileExists(name)
    local f = io.open( name,"r")
    if f ~= nil then
        f:close()
    end
    return f ~= nil
end

function Speedtest.GetServers(prop)
    if not FileExists("/tmp/vuci-app-speedtest-servers.json") then
        os.execute("curl -L -o /tmp/vuci-app-speedtest-servers.json https://drive.google.com/uc?id=16fh7RQLe1kQ617gCJwhKcwH9_L8naoFw")
    end
    prop.servers = GetJsonFromFile("/tmp/vuci-app-speedtest-servers.json")
    return prop
end

function Speedtest.GetLocationInfo(prop)
    local url = "http://ip-api.com/json/"
    local c = Curl.easy{
        url = url,
        timeout = 5
    }
    local jsonTxt = ""
    c:perform({writefunction=function(n)
        jsonTxt = jsonTxt..n
    end})
    c:close()
    prop.info = Json.decode(jsonTxt)
    return prop
end

-- function Speedtest.GetServer(prop)
--     local url = "http://ip-api.com/json/"
--     local c = Curl.easy{
--         url = url,
--         timeout = 5
--     }
--     local jsonTxt = ""
--     c:perform({writefunction=function(n)
--         jsonTxt = jsonTxt..n
--     end})
--     c:close()
--     local results = Json.decode(jsonTxt)
--     local country = results["country"]
    
--     local servers = GetServers()
--     local goodServer = nil
--     for index, value in ipairs(servers["settings"]["servers"]["server"]) do
--         if(value["@country"] == country) then
--             value["@url"] = value["@url"]:match("(.+)/upload.php")
--             print(value["@url"])
--             local result = HelloServer(value["@url"])
--             if(result == 200) then
--                 goodServer = value
--                 break
--             end
--         end
--     end
--     if goodServer == nil then
--         error("No good server")
--     end
--     prop.server = goodServer
--     return prop
-- end

function Speedtest.HelloServer(prop)
    local headers = {
        "User-Agent: OpenWrt",
    }
    local url = prop.server.."/hello"
    local c = Curl.easy{
        url = url,
        httpheader = headers,
        timeout_ms = 1000,
    }
    pcall(c.perform,c,{writefunction=function(str) end })
    prop.response = c:getinfo(Curl.INFO_RESPONSE_CODE)
    c:close()
    return prop
end

function Speedtest.GetPing(props)
    local headers = {
        "User-Agent: OpenWrt",
    }

    local url = props.host.."/download?size=25000"

    local c = Curl.easy{
        url = url,
        httpheader = headers,
    }

    c:perform({
        writefunction=function() end 
    })
    props.result = c:getinfo(Curl.INFO_CONNECT_TIME)*1000
    c:close()
    return props
end

function Speedtest.Download(props)
    local headers = {
        "User-Agent: OpenWrt",
    }

    local url = props.host.."/download?size=25000000"

    local c = Curl.easy{
        url = url,
        httpheader = headers,
    }

    c:perform({
        writefunction=function() end 
    })
    props.result = c:getinfo(Curl.INFO_SPEED_DOWNLOAD)/1000000*8
    c:close()
    return props
end

function Speedtest.Upload(props)
    local bytesLeft = 25000000
    local headers = {
        "User-Agent: OpenWrt",
        "Content-type: application/octet-stream",
        "Content-Length: "..bytesLeft
    }

    local url = props.host.."/upload"

    local file = io.open ("/tmp/random", "r")
    local c = Curl.easy{
        url = url,
        httpheader = headers,
        post = true,
    }

    local datafilename = "/dev/zero"
    local fhandle = assert(io.open(datafilename, "rb"))
    local bytesToRead = 10000
    c:perform({readfunction=function(n)
        if bytesLeft > 0 then
            bytesLeft = bytesLeft - bytesToRead
            return fhandle:read(bytesToRead)
        else
            return nil
        end
    end})
    props.result = c:getinfo(Curl.INFO_SPEED_UPLOAD)/1000000*8
    c:close()
    return props
end
return Speedtest