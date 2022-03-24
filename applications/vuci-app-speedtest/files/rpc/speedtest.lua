Curl = require 'cURL'
Json = require 'vuci.json'

Servers = nil
Speedtest = {}

function GetJsonFromFile(file)
    local fhandle = assert(io.open(file, "r"))
    local jsonTxt = fhandle:read("*all")
    local json = Json.decode(jsonTxt)
    return json
end

function GetServers()
    if Servers == nil then
        Servers = GetJsonFromFile("/etc/vuci-app-speedtest/servers.json")
    end
    return Servers
end

function Speedtest.GetServer(prop)
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
    local results = Json.decode(jsonTxt)
    local country = results["country"]
    
    local servers = GetServers()
    local goodServer = nil
    for index, value in ipairs(servers["Servers"]) do
        if(value["Country"] == country) then
            local result = HelloServer(value["Host"])
            if(result == 200) then
                goodServer = value
                break
            end
        end
    end
    if goodServer == nil then
        error("No good server")
    end
    prop.server = goodServer
    return prop
end

function HelloServer(server)
    local headers = {
        "User-Agent: OpenWrt",
    }

    local url = server.."/hello"
    local c = Curl.easy{
        url = url,
        httpheader = headers,
        timeout = 2
    }
    pcall(c.perform,c,{writefunction=function(str)
        return ""
    end })
    local response = c:getinfo(Curl.INFO_RESPONSE_CODE)
    c:close()
    return response
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
        writefunction=function(str)
            return ""
        end 
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
        writefunction=function(str)
            return ""
        end 
    })
    props.result = c:getinfo(Curl.INFO_SPEED_DOWNLOAD)/1000000*8
    c:close()
    return props
end

function Speedtest.Upload(props)
    local headers = {
        "User-Agent: OpenWrt",
        "Content-type: application/octet-stream",
        "Content-Length: 25000000"
    }

    os.execute("dd if=/dev/urandom of=/tmp/random bs=1MB count=25")

    local url = props.host.."/upload"

    local file = io.open ("/tmp/random", "r")
    local c = Curl.easy{
        url = url,
        httpheader = headers,
        post = true,
    }

    local datafilename = "/tmp/random"
    local fhandle = assert(io.open(datafilename, "rb"))
    c:perform({readfunction=function(n)
        return fhandle:read(10000)
    end})
    props.result = c:getinfo(Curl.INFO_SPEED_UPLOAD)/1000000*8
    c:close()
    return props
end

return Speedtest