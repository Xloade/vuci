#! /usr/bin/env lua

Uci = require 'uci'

Vpn = {}

function Vpn.addVpn (props)
  local form = props.form
  local c = Uci.cursor()
  c:set("openvpn", form.name, "openvpn")
  c:set("openvpn", form.name, "_name", form.name)
  c:set("openvpn", form.name, "type", form.type)
  c:set("openvpn", form.name, "enable", "1")
  c:set("openvpn", form.name, "keepalive", "10 120")
  c:set("openvpn", form.name, "data_chipers", {"BF-CBC"})
  c:set("openvpn", form.name, "persist_key", "1")
  c:set("openvpn", form.name, "port", "1194")
  c:set("openvpn", form.name, "persist_tun", "1")
  local dev = "tun_"..string.sub(form.type, 1, 1).."_"..form.name
  c:set("openvpn", form.name, "dev", dev)
  c:set("openvpn", form.name, "verb", "5")
  c:set("openvpn", form.name, "proto", "udp")
  c:set("openvpn", form.name, "cipher", "BF-CBC")

  if form.type == "client" then
    c:set("openvpn", form.name, "_tls_auth", "none")
    c:set("openvpn", form.name, "status", "/tmp/openvpn-status_"..form.name)
  end

  c:commit("openvpn")
end

function GetConfUnamed(conf, type)
  local res = {}
  local c = Uci.cursor()
  c:foreach(conf, type, function(s)
    res[#res+1] = s
  end)
  return res
end

function Vpn.getVpns(props)
  local vpns = GetConfUnamed("openvpn", "openvpn")
  for index, vpn in ipairs(vpns) do
    vpns[index].status = vpn.enable == "1" and "Enabled" or "Disabled"
  end
  props.vpns = vpns
  return props
end

function Vpn.enable(props)
  local c = Uci.cursor()
  c:set("openvpn", props.name, "enable", "1")
  c:commit("openvpn")
end

function Vpn.disable(props)
  local c = Uci.cursor()
  c:set("openvpn", props.name, "enable", "0")
  c:commit("openvpn")
end

function Vpn.delete(props)
  local c = Uci.cursor()
  c:delete("openvpn", props.name)
  c:commit("openvpn")
end

return Vpn