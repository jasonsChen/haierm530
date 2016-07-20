--[[
LuCI - Lua Configuration Interface

Copyright 2010 Jo-Philipp Wich <xm@subsignal.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
]]--
require("luci.sys")



m = Map("system_mode", translate("System Mode"), translate("Repeater: Network port as LAN port to use, the router SSID as a front-end router connected to the SSID relay." ..
"<br></br>Ap Client:to be a client connected to a wireless network,at the same time create one ap. "))

m:append(Template("admin_system/system_mode"))


return m
