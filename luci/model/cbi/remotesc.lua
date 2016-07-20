--[[
LuCI - Lua Configuration Interface

Copyright 2010 Jo-Philipp Wich <xm@subsignal.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
]]--
require("luci.sys")



m = Map("remotesc", translate("Remote Access Control"), translate("Remote Access Control"))

d = m:section(TypedSection,"remotesc","")

d.addremove = false
d.anonymous = true
o = d:option(Flag, "port_map_enable", translate("web Enable"))
o = d:option(Value,"web_port",translate("web port"))
o = d:option(Flag, "snmp_enable", translate("snmp Enable"))
o = d:option(Flag, "tr069_enable", translate("tro69 Enable"))
o = d:option(Flag, "ping_enable", translate("ping Enable"))

local apply = luci.http.formvalue("cbi.apply")
if apply then
	 io.popen("/etc/init.d/remotesc restart")
end


return m
