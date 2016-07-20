--[[
LuCI - Lua Configuration Interface

Copyright 2009 Jo-Philipp Wich <xm@subsignal.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id: wifi_add.lua 8889 2012-07-24 11:37:38Z jow $
]]--

local fs   = require "nixio.fs"
local nw   = require "luci.model.network"
local fw   = require "luci.model.firewall"
local uci  = require "luci.model.uci".cursor()
local http = require "luci.http"

local iw = luci.sys.wifi.getiwinfo(http.formvalue("device"))

local has_firewall = fs.access("/etc/config/firewall")
local repeater = fs.access("/tmp/repeater")



m = SimpleForm("network", translate("Join Network: Settings"))
m.cancel = translate("Back to scan results")
m.reset = false

function m.on_cancel()
	http.redirect(luci.dispatcher.build_url(
		"admin/system/ap_join?device=mt7628"
	))
end

nw.init(uci)
fw.init(uci)


m.hidden = {
	device      = http.formvalue("device"),
	join        = http.formvalue("join"),
	channel     = http.formvalue("channel"),
	mode        = http.formvalue("mode"),
	bssid       = http.formvalue("bssid"),
	wep         = http.formvalue("wep"),
	wpa_suites	= http.formvalue("wpa_suites"),
	wpa_version = http.formvalue("wpa_version")
}
scan = m:field(Value, "Scan", translate("Scan"))
scan.template = "admin_system/ap_scan"

join = m:field(Value, "Join", translate("SSID"))
join.value = m.hidden.join

bssid = m:field(Value, "bssid", translate("Mac"))
bssid.value= m.hidden.bssid

if m.hidden.channel then
	channel = m:field(Value, "channel", translate("Channel"))
	channel.value=m.hidden.channel
else
	channel = m:field(ListValue, "channel", translate("Channel"))

	channel:value(1,translate("%i (%.3f GHz)") %{ 1,2.412 }) 
	channel:value(2,translate("%i (%.3f GHz)") %{ 2,2.417 }) 
	channel:value(3,translate("%i (%.3f GHz)") %{ 3,2.422 }) 
	channel:value(4,translate("%i (%.3f GHz)") %{ 4,2.427 }) 
	channel:value(5,translate("%i (%.3f GHz)") %{ 5,2.432 }) 
	channel:value(6,translate("%i (%.3f GHz)") %{ 6,2.437 }) 
	channel:value(7,translate("%i (%.3f GHz)") %{ 7,2.442 }) 
	channel:value(8,translate("%i (%.3f GHz)") %{ 8,2.447 }) 
	channel:value(9,translate("%i (%.3f GHz)") %{ 9,2.452 }) 
	channel:value(10,translate("%i (%.3f GHz)") %{ 10,2.457 }) 
	channel:value(11,translate("%i (%.3f GHz)") %{ 11,2.462 }) 
	channel:value(12,translate("%i (%.3f GHz)") %{ 12,2.467 }) 
	channel:value(13,translate("%i (%.3f GHz)") %{ 13,2.472 }) 
end

if http.formvalue("wep") == "1" then
	key = m:field(Value, "key", translate("WEP passphrase"),
		translate("Specify the secret encryption key here."))

	key.password = true
	key.datatype = "wepkey"
	
elseif (tonumber(m.hidden.wpa_version) or 0) > 0 and
	(m.hidden.wpa_suites == "PSK" or m.hidden.wpa_suites == "PSK2")
then
	key = m:field(Value, "key", translate("WPA passphrase"),
		translate("Specify the secret encryption key here."))

	key.password = true
	key.datatype = "wpakey"
	--m.hidden.wpa_suite = (tonumber(http.formvalue("wpa_version")) or 0) >= 2 and "psk2" or "psk"

else
	key = m:field(Value, "keyType", translate("Encryption"),
		translate("Choose encryption mode here."))

	key:value("wep-open", translate("Wep"))
	key:value("psk", translate("Wpa"))
	key:value("psk2", translate("Wpa2"))
	
	wpakey = m:field(Value, "Wpakey", translate("WPA passphrase"),
		translate("Specify the secret encryption key here."))

	wpakey.password = true
	wpakey.datatype = "wpakey"
	wpakey:depends({keyType="psk"})
	wpakey:depends({keyType="psk2"})
	
	wepkey = m:field(Value, "Wepkey", translate("WEP passphrase"),
		translate("Specify the secret encryption key here."))
	
	wepkey.password = true
	wepkey.datatype = "wepkey"
	wepkey:depends({keyType="wep-open"})
	
end







function key.parse(self, section)
	local net
	-- luci.sys.exec("echo device %q" % m.hidden.device)
	if not m.hidden.device then
		m.hidden.device = tostring("mt7628")
	end 
	local wdev = nw:get_wifidev(m.hidden.device)

	wdev:set("disabled", false)
	-- luci.sys.exec("sed -i '/wifi-iface/,$d' /etc/config/wireless;")

	local wconf = {
--		device  = m.hidden.device,
--		ssid    = m.hidden.join,
--		mode    ="ap"
	}

	if m.hidden.wep == "1" then
		-- wconf.encryption = "wep-open"
		-- wconf.key        = "1"
		wdev:set("ApCliAuthMode", tostring("OPEN"))
		wdev:set("ApCliEncrypType", tostring("WEP"))
		wdev:set("ApCliDefaultKeyID", tostring("1"))
		wdev:set("ApCliKey1Str", key and key:formvalue(section) or "")
	--	wconf.ApCliAuthMode = tostring("OPEN")
	--	wconf.ApCliEncrypType = tostring("WEP")
	--	wconf.ApCliDefaultKeyID = tostring("1")
	--	wconf.ApCliKey1 = key and key:formvalue(section) or ""
		-- wconf.key1       = key and key:formvalue(section) or ""
	elseif (tonumber(m.hidden.wpa_version) or 0) > 0 then
	    wconf.encryption = (tonumber(m.hidden.wpa_version) or 0) >= 2 and "psk2" or "psk"
		-- wconf.key        = key and key:formvalue(section) or ""
		if wconf.encryption and wconf.encryption == "psk" then
		--	wconf.ApCliEncrypType = tostring("TKIP")
			wdev:set("ApCliEncrypType", tostring("TKIP"))
			wdev:set("ApCliAuthMode", tostring("WPAPSK"))
		elseif wconf.encryption and wconf.encryption == "psk2" then
	--		wconf.ApCliEncrypType = tostring("AES")
			wdev:set("ApCliEncrypType", tostring("AES"))
			wdev:set("ApCliAuthMode", tostring("WPA2PSK"))
		end
		
		wdev:set("ApCliWPAPSK", key and key:formvalue(section) or "")
	--	wconf.ApCliAuthMode = tostring("WPAPSK")
	--	wconf.ApCliWPAPSK = key and key:formvalue(section) or ""
	else
		local keytype = key and key:formvalue(section) or ""
		if  keytype and keytype == "wep-open" then
		--	wconf.encryption = "wep-open"
		--	wconf.key        = "1"
			wdev:set("ApCliAuthMode", tostring("OPEN"))
			wdev:set("ApCliEncrypType", tostring("WEP"))
			wdev:set("ApCliWPAPSK", wepkey and wepkey:formvalue(section) or "")
			wdev:set("ApCliDefaultKeyID", tostring("1"))
			wdev:set("ApCliKey1Str", wepkey and wepkey:formvalue(section) or "")
		--	wconf.ApCliDefaultKeyID = tostring("1")
		--	wconf.ApCliAuthMode = tostring("OPEN")
		--	wconf.ApCliEncrypType = tostring("WEP")
		--	wconf.ApCliWPAPSK = wepkey and wepkey:formvalue(section) or ""
		--	wconf.key1       = wepkey and wepkey:formvalue(section) or ""
		elseif  keytype and keytype == "psk" then
		--	wconf.encryption = "psk"
			wdev:set("ApCliAuthMode", tostring("WPAPSK"))
			wdev:set("ApCliEncrypType", tostring("TKIP"))
			wdev:set("ApCliWPAPSK", wpakey and wpakey:formvalue(section) or "")
		--	wconf.ApCliAuthMode = tostring("WPAPSK")
		--	wconf.ApCliEncrypType = tostring("TKIP")
		--	wconf.ApCliWPAPSK = wepkey and wepkey:formvalue(section) or ""
		--	wconf.key        = wpakey and wpakey:formvalue(section) or ""
		elseif  keytype and keytype == "psk2" then
		-- wconf.encryption = "psk2"
			wdev:set("ApCliAuthMode", tostring("WPA2PSK"))
			wdev:set("ApCliEncrypType", tostring("AES"))
			wdev:set("ApCliWPAPSK", wpakey and wpakey:formvalue(section) or "")
			
		--	wconf.ApCliAuthMode = tostring("WPAPSK")
		--	wconf.ApCliEncrypType = tostring("AES")
		--	wconf.ApCliWPAPSK = wepkey and wepkey:formvalue(section) or ""
		--	wconf.key        = wpakey and wpakey:formvalue(section) or ""
		else
		--wconf.encryption = "none"
		-- wconf.ApCliAuthMode = tostring("OPEN")
		-- wconf.ApCliEncrypType = tostring("NONE")
		wdev:set("ApCliAuthMode", tostring("OPEN"))
		wdev:set("ApCliEncrypType", tostring("NONE"))
		end
	end

	if wconf.mode == "adhoc" or wconf.mode == "sta" then
		wconf.bssid = m.hidden.bssid
	end

	local value = self:formvalue(section)
	
    m.hidden.join = join and join:formvalue(section) or ""
--	m.hidden.channel = channel and channel:formvalue(section) or ""
	m.hidden.bssid = bssid and bssid:formvalue(section) or ""
	wdev:set("channel", channel and channel:formvalue(section) or "0")
	wdev:set("ApCliBssid", bssid and bssid:formvalue(section) or "0")
	
	
	if not value or value then
		-- wconf.network = tostring("wwan")
		wdev:set("ApCliSsid", m.hidden.join)
		wdev:set("ApCliEnable",tostring("1"))
	--	wconf.ApCliSsid = tostring(m.hidden.join)
	--	local wnet = wdev:add_wifinet(wconf)
		if wnet or not wnet then
			
			-- luci.sys.exec("uci set wireless.@wifi-iface[0].ssid=%q" % m.hidden.join)
			-- luci.sys.exec("uci set wireless.@wifi-iface[0].bssid=%q" % m.hidden.bssid)
			uci:commit("wireless")
			
			if not repeater then
				luci.sys.exec("/etc/init.d/system_mode restart ap_client")
				luci.http.redirect("system_mode?result=ap_client")
			else
				luci.sys.exec("/etc/init.d/system_mode restart repeater")
				luci.http.redirect("system_mode?result=repeater")
			end
		end
	end
end



return m
