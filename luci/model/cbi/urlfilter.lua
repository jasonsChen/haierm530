--[[
LuCI - Lua Configuration Interface

Copyright 2010 Jo-Philipp Wich <xm@subsignal.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
]]--
require("luci.sys")


m = Map("urlfilter", translate("Domain Filter"), translate("Domain Filter Black List"))

d = m:section(TypedSection,"addurl","")

d.addremove = false
d.anonymous = true
o = d:option(Flag, "enable", translate("Enable"))
url = d:option(DynamicList,"urllist", translate("Url"))


local apply = luci.http.formvalue("cbi.apply")
if apply then
	 io.popen("/etc/init.d/urlfilter restart")
end


return m
