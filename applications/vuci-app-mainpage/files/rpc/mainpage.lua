
Uci = require 'uci'
Mainpage = {}

function GetConfUnamed(conf, type)
    local res = {}
    local c = Uci.cursor()
    c:foreach(conf, type, function(s)
        res[#res+1] = s
    end)
    return res
end

function Mainpage.Get(props)
    props.cards = GetConfUnamed("vuci-app-mainpage", "cards")
    return props
end

function Mainpage.Save(props)
    local c = Uci.cursor()
    for index, value in ipairs(props.cards) do
        
    end
    return props
end

return Mainpage