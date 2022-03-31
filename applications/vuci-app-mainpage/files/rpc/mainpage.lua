
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

function Mainpage.SaveShow(props)
    local c = Uci.cursor()
    for index, value in ipairs(props.cards) do
        c:set("vuci-app-mainpage", value.name, "show", value.info.show and 1 or 0)
    end
    c:commit("vuci-app-mainpage")
    return props
end

function Mainpage.SaveOrder(props)
    local c = Uci.cursor()
    for index, value in ipairs(props.cards) do
        c:set("vuci-app-mainpage", value.name, "order", value.info.order)
    end
    c:commit("vuci-app-mainpage")
    return props
end

DB_PATH = "/log/log.db"
ubus = require "ubus"

function Mainpage.logs(props)
    local msg = props.msg
    local sqlite3 = require "lsqlite3"
    local db = sqlite3.open(DB_PATH)
    local log = {}
    local found_table = false
    local event_type = 'SYSTEM'
    local query = ""
    if msg.type and (msg.type == "NETWORK" or msg.type == "SYSTEM" or msg.type == "EVENTS" or msg.type == "CONNECTIONS") then
        event_type = msg.type
    end
    if msg.short and msg.short == true then
        query = "select time, name, text from "..event_type:lower().." order by time desc limit 4"
    else
        query = "select time, name, text from "..event_type:lower()
    end
    if db then
        db:exec(string.format([[select * from sqlite_master where name='%s';]], event_type:upper()), function(...) found_table = true end)
        if found_table then
            for row in db:rows(query) do
                log[#log + 1] = {
                    datetime = os.date('%Y-%m-%d %H:%M:%S', tonumber(row[1])),
                    sender = row[2],
                    event = row[3]						
                }
            end
        end
    end
    db:close()
    props.log = log
    return props
end

function Mainpage.Access(props)
    local lan = {}
    local wan = {}

    local wanrules = GetConfUnamed("firewall", "rule")

    for index, value in ipairs(wanrules) do
        if value.name == "Enable_SSH_WAN" then
            wan.ssh = value.enabled == '1'
        elseif value.name == "Enable_HTTP_WAN" then
            wan.http = value.enabled == '1'
        elseif value.name == "Enable_CLI_WAN" then
            wan.cli = value.enabled == '1'
        end
    end

    local c = Uci.cursor()

    lan.cli = c:get('cli', 'status', 'enable') == '1'
    lan.ssh = GetConfUnamed("dropbear", "dropbear")[1].enable == '1'
    lan.http = c:get('vuci-httpd', 'main', 'enabled') == '1'


    local lanAnswer = ''
    if lan.ssh then lanAnswer = lanAnswer.."ssh, " end
    if lan.http then lanAnswer = lanAnswer.."http, " end
    if lan.cli then lanAnswer = lanAnswer.."cli, " end

    local wanAnswer = ''

    if wan.ssh then wanAnswer = wanAnswer.."ssh, " end
    if wan.http then wanAnswer = wanAnswer.."http, " end
    if wan.cli then wanAnswer = wanAnswer.."cli, " end

    if #lanAnswer > 1 then
        lanAnswer = lanAnswer:sub(1, -3)
    else
        lanAnswer = '-'
    end

    if #wanAnswer > 1 then
        wanAnswer = wanAnswer:sub(1, -3)
    else
        wanAnswer = '-'
    end

    props.lan = lanAnswer
    props.wan = wanAnswer

    return props
end

return Mainpage