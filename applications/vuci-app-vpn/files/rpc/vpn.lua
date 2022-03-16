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
    c:set("openvpn", form.name, "status", "/tmp/openvpn-status_"..form.name..".log")
    c:set("openvpn", form.name, "nobind", "1")
    c:set("openvpn", form.name, "resolv_retry", "infinite")
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

function Vpn.getVpn(props)
  local c = Uci.cursor()
  local vpn = c:get_all("openvpn", props.name)

  vpn.enable = vpn.enable == "1"

  vpn.ca = vpn.ca and vpn.ca:match(".+%/cbid.openvpn."..props.name..".(.+)") or ""
  vpn.cert = vpn.cert and vpn.cert:match(".+%/cbid.openvpn."..props.name..".(.+)") or ""
  vpn.key = vpn.key and vpn.key:match(".+%/cbid.openvpn."..props.name..".(.+)") or ""

  if(vpn.type == "server") then
    vpn.dh = vpn.dh and vpn.dh:match(".+%/cbid.openvpn."..props.name..".(.+)") or ""
  end
  if(vpn.type == "client") then
  end

  if(vpn._auth == "skey") then
    vpn.secret = vpn.secret and vpn.secret:match(".+%/cbid.openvpn."..props.name..".(.+)") or ""
  elseif(vpn._auth == "tls") then
    
  end
  
  

  props.vpn = vpn
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

function Vpn.edit(props)
  local form = props.form
  local c = Uci.cursor()
  local type = c:get("openvpn", form.name, "type")

  c:set("openvpn", form.name, "enable", form.isEnabled and '1' or '0')
  c:set("openvpn", form.name, "_auth", form.auth)
  if(not (form.auth == "tls" and type == "server")) then
    c:set("openvpn", form.name, "network_ip", form.network.ip)
    c:set("openvpn", form.name, "network_mask", form.network.mask)
    -- idk if skey client needs it
    c:set("openvpn", form.name, "_tls_auth", "none")
    c:set("openvpn", form.name, "upload_files", "0")
  end
  if(form.auth == "skey") then
    c:set("openvpn", form.name, "secret", "/etc/vuci-uploads/cbid.openvpn."..form.name..".secretstatic.key")
    c:set("openvpn", form.name, "local_ip", form.localIp)
    c:set("openvpn", form.name, "remote_ip", form.remoteIp)
  elseif(form.auth == "tls") then
    c:set("openvpn", form.name, "_tls_auth", "none")
    c:set("openvpn", form.name, "_tls_cipher", "all")
    c:set("openvpn", form.name, "auth", "sha1")
    c:set("openvpn", form.name, "upload_files", "0")
    c:set("openvpn", form.name, "ca", "/etc/vuci-uploads/cbid.openvpn."..form.name..".ca.cert.pem")
    c:set("openvpn", form.name, "cert", "/etc/vuci-uploads/cbid.openvpn."..form.name.."."..form.type..".cert.pem")
    c:set("openvpn", form.name, "key", "/etc/vuci-uploads/cbid.openvpn."..form.name.."."..form.type..".key.pem")
  end

  if(type == "client") then
    c:set("openvpn", form.name, "remote", form.remote)
    if(form.auth == "skey") then
      
    elseif(form.auth == "tls") then
      c:set("openvpn", form.name, "tls_client", 1)
      c:set("openvpn", form.name, "client", 1)
    end
  elseif(type == "server") then
    if(form.auth == "skey") then

    elseif(form.auth == "tls") then
      c:set("openvpn", form.name, "dh", "/etc/vuci-uploads/cbid.openvpn."..form.name..".dh.pem")
      c:set("openvpn", form.name, "server_ip", form.server.ip)
      c:set("openvpn", form.name, "server_netmask", form.server.mask)
      c:set("openvpn", form.name, "tls_server", "1")
      c:set("openvpn", form.name, "client_config_dir", "/etc/openvpn/cdd")
      c:set("openvpn", form.name, "push", {"route 192.168.145.0 255.255.255.0"})
    end
  end
  c:commit("openvpn")
end

return Vpn