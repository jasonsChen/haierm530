--[[
LuCI - Lua Configuration Interface

Copyright 2010 Jo-Philipp Wich <xm@subsignal.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
]]--
require("luci.sys")


m = Map("advanced_security_settings", translate("DOS Settings"), translate("Setting    Icmp-Flood , Udp-Flood , Tcp-Syn-Flood"))


d = m:section(TypedSection,"advanced_security_settings","")

d.addremove = false
d.anonymous = true
o = d:option(Flag, "icmp_flood_enable", translate("Defense ICMP-FLOOD enable"))
o = d:option(Value, "icmp_flood_Threshold", translate("ICMP-FLOOD Threshold"))

o = d:option(Flag, "udp_flood_enable", translate("Defense UDP-FLOOD enable"))
o = d:option(Value, "udp_flood_Threshold", translate("UDP-FLOOD Threshold"))

o = d:option(Flag, "tcp_syn_flood_enable", translate("Defense TCP-SYN-FLOOD enable"))
o = d:option(Value, "tcp_syn_flood_Threshold", translate("TCP-SYN-FLOOD Threshold"))


local apply = luci.http.formvalue("cbi.apply")
if apply then
	 io.popen("/etc/init.d/advanced_security_settings restart")
end


return m
