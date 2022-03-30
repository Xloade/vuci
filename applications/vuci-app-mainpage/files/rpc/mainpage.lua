
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
    props.cards = GetConfUnamed("vuci-app-mainpage", "card")
    return props
end

function Mainpage.Save(props)
    local c = Uci.cursor()
    for index, value in ipairs(props.cards) do
        c:set("vuci-app-mainpage", value.name, "order", value.info.order)
        c:set("vuci-app-mainpage", value.name, "show", value.info.show and 1 or 0)
    end
    c:commit("vuci-app-mainpage")
    return props
end

return Mainpage