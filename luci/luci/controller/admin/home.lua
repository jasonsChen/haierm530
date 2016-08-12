--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2011 Jo-Philipp Wich <xm@subsignal.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

module("luci.controller.admin.home", package.seeall)

function index()
	entry({"admin", "home"}, alias("admin", "home", "quicksetup"), _("QuickSetup"), 10).index = true
	entry({"admin", "home", "quicksetup"}, template("admin_home/quicksetup"), _("QuickSetup"), 1)
	entry({"admin", "home", "mainpage"}, template("admin_home/mainpage"), _("MainPage"), 2)
	entry({"admin", "home", "wifisetup"}, template("admin_home/wifisetup"), _("WifiSetup"), 3)
	entry({"admin", "home", "staticaddress"}, template("admin_home/staticaddress"), _("StaticAdress"), 4)
	entry({"admin", "home", "dynamicaddress"}, template("admin_home/dynamicaddress"), _("DynamicAdress"), 5)
	entry({"admin", "home", "reperter"}, template("admin_home/reperter"), _("Reperter"), 6)
	entry({"admin", "home", "upgrade"}, template("admin_home/upgrade"), _("Upgrade"), 7)
	entry({"admin", "home", "setpassword"}, template("admin_home/setpassword"), _("SetPassword"), 8)
	entry({"admin", "home", "lanip"}, template("admin_home/lanip"), _("LanIP"), 9)
	entry({"admin", "home", "phoneonline"}, template("admin_home/phoneonline"), _("PhoneOnline"), 11)
	entry({"admin", "home", "dhcpset"}, template("admin_home/dhcpset"), _("DhcpSet"), 12)
	entry({"admin", "home", "staticset"}, template("admin_home/staticset"), _("StaticSet"), 13)
	entry({"admin", "home", "repset"}, template("admin_home/repset"), _("RepeaterSet"), 14)
	entry({"admin", "home", "pppoeset"}, template("admin_home/pppoeset"), _("PPPoESet"), 15)
	--entry({"admin", "status", "iptables"}, call("action_iptables"), _("Firewall"), 2).leaf = true
	--entry({"admin", "status", "routes"}, template("admin_status/routes"), _("Routes"), 3)
	--entry({"admin", "status", "syslog"}, call("action_syslog"), _("System Log"), 4)
	--entry({"admin", "status", "dmesg"}, call("action_dmesg"), _("Kernel Log"), 5)
	--entry({"admin", "status", "processes"}, cbi("admin_status/processes"), _("Processes"), 6)

	--entry({"admin", "status", "realtime"}, alias("admin", "status", "realtime", "load"), _("Realtime Graphs"), 7)

	--entry({"admin", "status", "realtime", "load"}, template("admin_status/load"), _("Load"), 1).leaf = true
	--entry({"admin", "status", "realtime", "load_status"}, call("action_load")).leaf = true

	--entry({"admin", "status", "realtime", "bandwidth"}, template("admin_status/bandwidth"), _("Traffic"), 2).leaf = true
	--entry({"admin", "status", "realtime", "bandwidth_status"}, call("action_bandwidth")).leaf = true

	--entry({"admin", "status", "realtime", "wireless"}, template("admin_status/wireless"), _("Wireless"), 3).leaf = true
	--entry({"admin", "status", "realtime", "wireless_status"}, call("action_wireless")).leaf = true

	--entry({"admin", "status", "realtime", "connections"}, template("admin_status/connections"), _("Connections"), 4).leaf = true
	--entry({"admin", "status", "realtime", "connections_status"}, call("action_connections")).leaf = true

	--entry({"admin", "status", "nameinfo"}, call("action_nameinfo")).leaf = true

	entry({"admin", "home", "Qui_PPP_Set"}, call("action_QuiPPP_Set"), _("Qui_PPP_Set"), 10).query = {redir=redir}
	entry({"admin", "home", "Qui_DHCP_Set"}, call("action_QuiDHCP_Set"), _("Qui_DHCP_Set"), 15).query = {redir=redir}
	entry({"admin", "home", "Qui_STATIC_Set"}, call("action_QuiSTATIC_Set"), _("Qui_STATIC_Set"), 20).query = {redir=redir}
	entry({"admin", "home", "Qui_REP_Set"}, call("action_QuiRep_Set"), _("Qui_REP_Set"), 25).query = {redir=redir}

	entry({"admin", "home", "wifiScan"}, call("action_wifiScan"), _("wifiScan"), 30).query = {redir=redir}
	--entry({"admin", "home", "repSet"}, call("action_repSet"), _("repSet"), 35).query = {redir=redir}
	entry({"admin", "home", "repStatus"}, call("action_repStatus"), _("repStatus"), 40).query = {redir=redir}
	entry({"admin", "home", "wifiSet"}, call("action_wifiSet"), _("wifiSet"), 45).query = {redir=redir}

	entry({"admin", "home", "passwordChange"}, call("action_passwordChange"),_("passwordChange"),50).query = {redir=redir}
	entry({"admin", "home", "Reboot"}, call("action_Reboot"), _("Reboot"), 55).query = {redir=redir}
	entry({"admin", "home", "ResetFactory1"}, call("action_ResetFactory"), _("ResetFactory"), 60).query = {redir=redir}

	entry({"admin", "home", "LanIPSet"}, call("action_LanIPSet"), _("LanIPSet"), 65).query = {redir=redir}

	entry({"admin", "home", "lease"}, call("action_lease_status"), _("Lease_Status"), 70).query = {redir=redir}

	entry({"admin", "home", "Rep_Set"}, call("action_Rep_Set"), _("Rep_Set"), 75).query = {redir=redir}
	entry({"admin", "home", "Pppoe_Set"}, call("action_Pppoe_Set"), _("Pppoe_Set"), 80).query = {redir=redir}
	entry({"admin", "home", "Dhcp_Set"}, call("action_Dhcp_Set"), _("Dhcp_Set"), 85).query = {redir=redir}
	entry({"admin", "home", "Static_Set"}, call("action_Static_Set"), _("Static_Set"), 90).query = {redir=redir}
end


function action_QuiPPP_Set()
	local uci = require("luci.model.uci").cursor()
	local function param(x)
		return luci.http.formvalue(x)
	end

	local account = param("account") or "00000000"
	local password = param("password") or "00000000"

	local ssid = param("ssid_24g") or "HappyHome"
	local key = param("key_24g") or "00000000"

	local pre_mode = uci:get("network","wan","mode")
	if pre_mode == "repeater" then
		uci:delete("wireless","mt7628","ApCliEnable")
		uci:delete("wireless","mt7628","ApCliAuthMode")
		uci:delete("wireless","mt7628","ApCliEncrypType")
		if ApCliEncrypType == "WEP" then
			uci:delete("wireless","mt7628","ApCliDefaultKeyID")
			uci:delete("wireless","mt7628","ApCliKey1")
		else
			uci:delete("wireless","mt7628","ApCliWPAPSK")
		end
		uci:delete("wireless","mt7628","ApCliSsid")
		uci:set("wireless","mt7628","channel",0)
	elseif pre_mode == "static" then
		uci:delete("network","wan","ipaddr", ipaddr)
		uci:delete("network","wan","netmask", netmask)
		uci:delete("network","wan","gateway", gateway)
		uci:delete("network","wan","dns", dns)
	elseif pre_mode == "pppoe" then
		--uci:delete("network","wan","username")
		--uci:delete("network","wan","password")
	else
	end

	uci:set("network","wan","proto","pppoe")
	uci:set("network","wan","username",account)
	uci:set("network","wan","password",password)
	uci:set("network","wan","mode","pppoe")
	uci:commit("network")

	luci.sys.call("uci set wireless.@wifi-iface[0].ssid=%q"%ssid)
	luci.sys.call("uci set wireless.@wifi-iface[0].encryption=psk2+tkip+ccmp")
	luci.sys.call("uci set wireless.@wifi-iface[0].key=%q"%key)
	luci.sys.call("uci set wireless.@wifi-iface[0].disabled=0")
	uci:commit("wireless")

	luci.sys.call("rm -f /etc/config/repeater_web")

	local url = luci.dispatcher.build_url("admin/home/quicksetup") .. "" .. "?action=wanset"
	url = url .. "" ..  "?result=success";
	luci.http.redirect(url)
end

function action_QuiRep_Set()
	local uci = require("luci.model.uci").cursor()
	local nw   = require "luci.model.network"
	local fs = require "luci.fs"
	
	local function param(x)
		return luci.http.formvalue(x)
	end
	nw.init(uci)
	local wdev = nw:get_wifidev("mt7628")
	
	local authMode = param("encryption")
	local ssid = param("wifiName")
	local pass = param("netpassword")
	local crypt = param("groupCiphers")
	local channel = param("channel")

	local ssid = param("ssid_24g") or "HappyHome"
	local key = param("key_24g") or "00000000"
	-- set repeater cmd

	local pre_mode = uci:get("network","wan","mode")
	if pre_mode == "repeater" then
		--[[
		uci:delete("wireless","mt7628","ApCliEnable")
		uci:delete("wireless","mt7628","ApCliAuthMode")
		uci:delete("wireless","mt7628","ApCliEncrypType")
		if ApCliEncrypType == "WEP" then
			uci:delete("wireless","mt7628","ApCliDefaultKeyID")
			uci:delete("wireless","mt7628","ApCliKey1")
		else
			uci:delete("wireless","mt7628","ApCliWPAPSK")
		end
		uci:delete("wireless","mt7628","ApCliSsid")
		uci:set("wireless","mt7628","channel",0)
		]]--
	elseif pre_mode == "static" then
		uci:delete("network","wan","ipaddr", ipaddr)
		uci:delete("network","wan","netmask", netmask)
		uci:delete("network","wan","gateway", gateway)
		uci:delete("network","wan","dns", dns)
	elseif pre_mode == "pppoe" then
		uci:delete("network","wan","username")
		uci:delete("network","wan","password")
	else
	end
	
	uci:set("wireless","mt7628","ApCliEnable","0")
	if string.find(crypt,"CCMP")  and string.find(crypt,"CCMP") >= 1 then
		crypt = "AES"
	end
	uci:set("wireless","mt7628","ApCliAuthMode",authMode)
	uci:set("wireless","mt7628","ApCliEncrypType",crypt)
    --luci.sys.exec("echo crypt= %q >> /tmp/tmp.log" % crypt)
	--luci.sys.call("iwpriv apcli0 set ApCliEnable=0")
	--luci.sys.call("iwpriv apcli0 set ApCliAuthMode=%q"%authMode)
	--luci.sys.call("iwpriv apcli0 set ApCliEncrypType=%q"%crypt)
	if crypt == "WEP" then
		uci:set("wireless","mt7628","ApCliDefaultKeyID",1)
		uci:set("wireless","mt7628","ApCliKey1",pass)
		--luci.sys.call("iwpriv apcli0 set ApCliDefaultKeyID=1")
		--luci.sys.call("iwpriv apcli0 set ApCliKey1=%q"%pass)
	else
		uci:set("wireless","mt7628","ApCliWPAPSK",pass)
		--luci.sys.call("iwpriv apcli0 set ApCliWPAPSK=%q"%pass)
	end
	uci:set("wireless","mt7628","ApCliSsid",ssid)
	uci:set("wireless","mt7628","channel",channel)
	uci:set("wireless","mt7628","ApCliEnable",1)
	

	luci.sys.call("uci set wireless.@wifi-iface[0].ssid=%q"%ssid)
	luci.sys.call("uci set wireless.@wifi-iface[0].encryption=psk2+tkip+ccmp")
	luci.sys.call("uci set wireless.@wifi-iface[0].key=%q"%key)
	luci.sys.call("uci set wireless.@wifi-iface[0].disabled=0")
	uci:commit("wireless")

	uci:set("network","wan","proto","repeater")
	uci:set("network","wan","mode","repeater")
	uci:commit("network")
	
	luci.sys.call("touch /etc/config/repeater_web")
--	luci.sys.call("iwpriv apcli0 set ApCliSsid=%q"%ssid)
--	luci.sys.call("iwpriv apcli0 set channel=%q"%channel)
--	luci.sys.call("iwpriv apcli0 set ApCliEnable=1")
	--luci.sys.exec("/etc/init.d/system_mode restart ap_client")
	--luci .sys.exec("/etc/init.d/network restart")
	--luci.sys.exec("sleep 4;iwpriv apcli0 show connStatus")
	
	local apcli = luci.util.pcdata(fs.readfile("/proc/apcli_info")) or "Disconnect"
	luci.sys.exec("echo apcli= %q >> /tmp/tmp.log" % apcli)
	local result = "error"
	if  string.find(apcli,"Disconnect") then
		result="error"
	else
		result="success"
	end
	
	--local url = luci.dispatcher.build_url("admin/home/reperter") .. "" .. "?action=wanset"
	--url = url .. "" ..  "?result=" .. result;
--	luci.sys.exec("echo url= %q >> /tmp/tmp.log" % url)
	--luci.http.redirect(result)

	luci.http.prepare_content("application/json")
	luci.http.write_json(result)
end

function action_QuiDHCP_Set()
	local uci = require("luci.model.uci").cursor()
	local function param(x)
		return luci.http.formvalue(x)
	end

	local ssid = param("ssid_24g") or "HappyHome"
	local key = param("key_24g") or "00000000"

	local pre_mode = uci:get("network","wan","mode")
	if pre_mode == "repeater" then
		uci:delete("wireless","mt7628","ApCliEnable")
		uci:delete("wireless","mt7628","ApCliAuthMode")
		uci:delete("wireless","mt7628","ApCliEncrypType")
		if ApCliEncrypType == "WEP" then
			uci:delete("wireless","mt7628","ApCliDefaultKeyID")
			uci:delete("wireless","mt7628","ApCliKey1")
		else
			uci:delete("wireless","mt7628","ApCliWPAPSK")
		end
		uci:delete("wireless","mt7628","ApCliSsid")
		uci:set("wireless","mt7628","channel",0)
	elseif pre_mode == "static" then
		uci:delete("network","wan","ipaddr", ipaddr)
		uci:delete("network","wan","netmask", netmask)
		uci:delete("network","wan","gateway", gateway)
		uci:delete("network","wan","dns", dns)
	elseif pre_mode == "pppoe" then
		uci:delete("network","wan","username")
		uci:delete("network","wan","password")
	else
	end

	uci:set("network","wan","proto","dhcp")
	uci:set("network","wan","mode","dhcp")
	uci:delete("network","wan","username")
	uci:delete("network","wan","password")
	uci:commit("network")

	luci.sys.call("uci set wireless.@wifi-iface[0].ssid=%q"%ssid)
	luci.sys.call("uci set wireless.@wifi-iface[0].encryption=psk2+tkip+ccmp")
	luci.sys.call("uci set wireless.@wifi-iface[0].key=%q"%key)
	luci.sys.call("uci set wireless.@wifi-iface[0].disabled=0")
	uci:commit("wireless")

	luci.sys.call("rm -f /etc/config/repeater_web")

	local url = luci.dispatcher.build_url("admin/home/dynamicaddress") .. "" .. "?action=wanset"
	url = url .. "" ..  "?result=success";
	luci.http.redirect(url)
end

function action_QuiSTATIC_Set()
	local uci = require("luci.model.uci").cursor()
	local function param(x)
		return luci.http.formvalue(x)
	end

	local ipaddr = param("ipaddr") or "0.0.0.0"
	local netmask = param("netmask") or "255.255.255.0"
	local gateway = param("gateway") or "0.0.0.0"
	local dns = param("dns") or "0.0.0.0"

	local ssid = param("ssid_24g") or "HappyHome"
	local key = param("key_24g") or "00000000"

	local pre_mode = uci:get("network","wan","mode")
	if pre_mode == "repeater" then
		uci:delete("wireless","mt7628","ApCliEnable")
		uci:delete("wireless","mt7628","ApCliAuthMode")
		uci:delete("wireless","mt7628","ApCliEncrypType")
		if ApCliEncrypType == "WEP" then
			uci:delete("wireless","mt7628","ApCliDefaultKeyID")
			uci:delete("wireless","mt7628","ApCliKey1")
		else
			uci:delete("wireless","mt7628","ApCliWPAPSK")
		end
		uci:delete("wireless","mt7628","ApCliSsid")
		uci:set("wireless","mt7628","channel",0)
	elseif pre_mode == "static" then
		uci:delete("network","wan","ipaddr", ipaddr)
		uci:delete("network","wan","netmask", netmask)
		uci:delete("network","wan","gateway", gateway)
		uci:delete("network","wan","dns", dns)
	elseif pre_mode == "pppoe" then
		uci:delete("network","wan","username")
		uci:delete("network","wan","password")
	else
	end

	uci:set("network","wan","proto","static")
	uci:set("network","wan","mode","static")
	uci:set("network","wan","ipaddr", ipaddr)
	uci:set("network","wan","netmask", netmask)
	uci:set("network","wan","gateway", gateway)
	uci:set("network","wan","dns", dns)
	uci:commit("network")

	luci.sys.call("uci set wireless.@wifi-iface[0].ssid=%q"%ssid)
	luci.sys.call("uci set wireless.@wifi-iface[0].encryption=psk2+tkip+ccmp")
	luci.sys.call("uci set wireless.@wifi-iface[0].key=%q"%key)
	luci.sys.call("uci set wireless.@wifi-iface[0].disabled=0")
	uci:commit("wireless")

	luci.sys.call("rm -f /etc/config/repeater_web")

	local url = luci.dispatcher.build_url("admin/home/staticaddress") .. "" .. "?action=wanset"
	url = url .. "" ..  "?result=success";
	luci.http.redirect(url)
end

function action_wifiScan()
	local sys = require "luci.sys"
	local util = require "luci.util"
	local dev = "mt7628"
	
	local iw = luci.sys.wifi.getiwinfo(dev)
	local wifi   = { }
	
	for k, v in ipairs(iw.scanlist or { }) do
			if v.ssid then
				wifi[#wifi+1] = v		
			end
			
	end
	
	luci.http.prepare_content("application/json")
	luci.http.write_json(wifi)
end

--[[
function action_repSet()
	local uci = require("luci.model.uci").cursor()
	local nw   = require "luci.model.network"
	local fs = require "luci.fs"
	
	local function param(x)
		return luci.http.formvalue(x)
	end
	nw.init(uci)
	local wdev = nw:get_wifidev("mt7628")
	
	local authMode = param("encryption")
	local ssid = param("wifiName")
	local pass = param("netpassword")
	local crypt = param("groupCiphers")
	local channel = param("channel")
	-- set repeater cmd
	
	uci:set("wireless","mt7628","ApCliEnable","0")
	if string.find(crypt,"CCMP")  and string.find(crypt,"CCMP") >= 1 then
		crypt = "AES"
	end
	uci:set("wireless","mt7628","ApCliAuthMode",authMode)
	uci:set("wireless","mt7628","ApCliEncrypType",crypt)
    --luci.sys.exec("echo crypt= %q >> /tmp/tmp.log" % crypt)
	--luci.sys.call("iwpriv apcli0 set ApCliEnable=0")
	--luci.sys.call("iwpriv apcli0 set ApCliAuthMode=%q"%authMode)
	--luci.sys.call("iwpriv apcli0 set ApCliEncrypType=%q"%crypt)
	if crypt == "WEP" then
		uci:set("wireless","mt7628","ApCliDefaultKeyID",1)
		uci:set("wireless","mt7628","ApCliKey1",pass)
		--luci.sys.call("iwpriv apcli0 set ApCliDefaultKeyID=1")
		--luci.sys.call("iwpriv apcli0 set ApCliKey1=%q"%pass)
	else
		uci:set("wireless","mt7628","ApCliWPAPSK",pass)
		--luci.sys.call("iwpriv apcli0 set ApCliWPAPSK=%q"%pass)
	end
	uci:set("wireless","mt7628","ApCliSsid",ssid)
	uci:set("wireless","mt7628","channel",channel)
	uci:set("wireless","mt7628","ApCliEnable",1)
	uci:set("network","wan","mode","repeater")
	uci:commit("network")


	local ssid = param("ssid_24g") or "HappyHome"
	local key = param("key_24g") or "00000000"

	luci.sys.call("uci set wireless.@wifi-iface[0].ssid=%q"%ssid)
	luci.sys.call("uci set wireless.@wifi-iface[0].encryption=psk2+tkip+ccmp")
	luci.sys.call("uci set wireless.@wifi-iface[0].key=%q"%key)
	luci.sys.call("uci set wireless.@wifi-iface[0].disabled=0")
	uci:commit("wireless")
	
	luci.sys.call("touch /etc/config/repeater_web")

--	luci.sys.call("iwpriv apcli0 set ApCliSsid=%q"%ssid)
--	luci.sys.call("iwpriv apcli0 set channel=%q"%channel)
--	luci.sys.call("iwpriv apcli0 set ApCliEnable=1")
	--luci.sys.exec("/etc/init.d/system_mode restart ap_client")
	--luci .sys.exec("/etc/init.d/network restart")
	--luci.sys.exec("sleep 4;iwpriv apcli0 show connStatus")
	
	local apcli = luci.util.pcdata(fs.readfile("/proc/apcli_info")) or "Disconnect"
	luci.sys.exec("echo apcli= %q >> /tmp/tmp.log" % apcli)
	local result = "error"
	if  string.find(apcli,"Disconnect") then
		result="error"
	else
		result="success"
	end
	
	--local url = luci.dispatcher.build_url("admin/home/reperter") .. "" .. "?action=repSet"
	--url = url .. "" ..  "?result=" .. result;
--	luci.sys.exec("echo url= %q >> /tmp/tmp.log" % url)
	--luci.http.redirect(result)

	luci.http.prepare_content("application/json")
	luci.http.write_json(result)
end
]]--

function action_Rep_Set()
	local uci = require("luci.model.uci").cursor()
	local nw   = require "luci.model.network"
	local fs = require "luci.fs"
	
	local function param(x)
		return luci.http.formvalue(x)
	end
	nw.init(uci)
	local wdev = nw:get_wifidev("mt7628")
	
	local authMode = param("encryption")
	local ssid = param("wifiName")
	local pass = param("netpassword")
	local crypt = param("groupCiphers")
	local channel = param("channel")
	-- set repeater cmd

	local pre_mode = uci:get("network","wan","mode")
	if pre_mode == "repeater" then
		--[[
		uci:delete("wireless","mt7628","ApCliEnable")
		uci:delete("wireless","mt7628","ApCliAuthMode")
		uci:delete("wireless","mt7628","ApCliEncrypType")
		if ApCliEncrypType == "WEP" then
			uci:delete("wireless","mt7628","ApCliDefaultKeyID")
			uci:delete("wireless","mt7628","ApCliKey1")
		else
			uci:delete("wireless","mt7628","ApCliWPAPSK")
		end
		uci:delete("wireless","mt7628","ApCliSsid")
		uci:set("wireless","mt7628","channel",0)
		]]--
	elseif pre_mode == "static" then
		uci:delete("network","wan","ipaddr", ipaddr)
		uci:delete("network","wan","netmask", netmask)
		uci:delete("network","wan","gateway", gateway)
		uci:delete("network","wan","dns", dns)
	elseif pre_mode == "pppoe" then
		uci:delete("network","wan","username")
		uci:delete("network","wan","password")
	else
	end
	
	uci:set("wireless","mt7628","ApCliEnable","0")
	if string.find(crypt,"CCMP")  and string.find(crypt,"CCMP") >= 1 then
		crypt = "AES"
	end
	uci:set("wireless","mt7628","ApCliAuthMode",authMode)
	uci:set("wireless","mt7628","ApCliEncrypType",crypt)
    --luci.sys.exec("echo crypt= %q >> /tmp/tmp.log" % crypt)
	--luci.sys.call("iwpriv apcli0 set ApCliEnable=0")
	--luci.sys.call("iwpriv apcli0 set ApCliAuthMode=%q"%authMode)
	--luci.sys.call("iwpriv apcli0 set ApCliEncrypType=%q"%crypt)
	if crypt == "WEP" then
		uci:set("wireless","mt7628","ApCliDefaultKeyID",1)
		uci:set("wireless","mt7628","ApCliKey1",pass)
		--luci.sys.call("iwpriv apcli0 set ApCliDefaultKeyID=1")
		--luci.sys.call("iwpriv apcli0 set ApCliKey1=%q"%pass)
	else
		uci:set("wireless","mt7628","ApCliWPAPSK",pass)
		--luci.sys.call("iwpriv apcli0 set ApCliWPAPSK=%q"%pass)
	end
	uci:set("wireless","mt7628","ApCliSsid",ssid)
	uci:set("wireless","mt7628","channel",channel)
	uci:set("wireless","mt7628","ApCliEnable",1)
	uci:set("network","wan","mode","repeater")
	uci:commit("network")
	uci:commit("wireless")
	
	luci.sys.call("touch /etc/config/repeater_web")

--	luci.sys.call("iwpriv apcli0 set ApCliSsid=%q"%ssid)
--	luci.sys.call("iwpriv apcli0 set channel=%q"%channel)
--	luci.sys.call("iwpriv apcli0 set ApCliEnable=1")
	--luci.sys.exec("/etc/init.d/system_mode restart ap_client")
	--luci .sys.exec("/etc/init.d/network restart")
	--luci.sys.exec("sleep 4;iwpriv apcli0 show connStatus")
	
	local apcli = luci.util.pcdata(fs.readfile("/proc/apcli_info")) or "Disconnect"
	luci.sys.exec("echo apcli= %q >> /tmp/tmp.log" % apcli)
	local result = "error"
	if  string.find(apcli,"Disconnect") then
		result="error"
	else
		result="success"
	end
	
	--local url = luci.dispatcher.build_url("admin/home/reperter") .. "" .. "?action=repSet"
	--url = url .. "" ..  "?result=" .. result;
--	luci.sys.exec("echo url= %q >> /tmp/tmp.log" % url)
	--luci.http.redirect(result)

	luci.http.prepare_content("application/json")
	luci.http.write_json(result)
end

function action_Ppppoe_Set()
	local uci = require("luci.model.uci").cursor()
	local function param(x)
		return luci.http.formvalue(x)
	end
	local account = param("account") or "00000000"
	local password = param("password") or "00000000"

	local pre_mode = uci:get("network","wan","mode")
	if pre_mode == "repeater" then
		uci:delete("wireless","mt7628","ApCliEnable")
		uci:delete("wireless","mt7628","ApCliAuthMode")
		uci:delete("wireless","mt7628","ApCliEncrypType")
		if ApCliEncrypType == "WEP" then
			uci:delete("wireless","mt7628","ApCliDefaultKeyID")
			uci:delete("wireless","mt7628","ApCliKey1")
		else
			uci:delete("wireless","mt7628","ApCliWPAPSK")
		end
		uci:delete("wireless","mt7628","ApCliSsid")
		uci:set("wireless","mt7628","channel",0)
	elseif pre_mode == "static" then
		uci:delete("network","wan","ipaddr", ipaddr)
		uci:delete("network","wan","netmask", netmask)
		uci:delete("network","wan","gateway", gateway)
		uci:delete("network","wan","dns", dns)
	elseif pre_mode == "pppoe" then
		--uci:delete("network","wan","username")
		--uci:delete("network","wan","password")
	else
	end

	uci:set("network","wan","proto","pppoe")
	uci:set("network","wan","username",account)
	uci:set("network","wan","password",password)
	uci:set("network","wan","mode","pppoe")
	uci:commit("network")

	luci.sys.call("rm -f /etc/config/repeater_web")

	local url = luci.dispatcher.build_url("admin/home/pppoeset") .. "" .. "?action=pppoeset"
	url = url .. "" ..  "?result=success";
	luci.http.redirect(url)
end

function action_Dhcp_Set()
	local uci = require("luci.model.uci").cursor()
	local function param(x)
		return luci.http.formvalue(x)
	end

	local pre_mode = uci:get("network","wan","mode")
	if pre_mode == "repeater" then
		uci:delete("wireless","mt7628","ApCliEnable")
		uci:delete("wireless","mt7628","ApCliAuthMode")
		uci:delete("wireless","mt7628","ApCliEncrypType")
		if ApCliEncrypType == "WEP" then
			uci:delete("wireless","mt7628","ApCliDefaultKeyID")
			uci:delete("wireless","mt7628","ApCliKey1")
		else
			uci:delete("wireless","mt7628","ApCliWPAPSK")
		end
		uci:delete("wireless","mt7628","ApCliSsid")
		uci:set("wireless","mt7628","channel",0)
	elseif pre_mode == "static" then
		uci:delete("network","wan","ipaddr", ipaddr)
		uci:delete("network","wan","netmask", netmask)
		uci:delete("network","wan","gateway", gateway)
		uci:delete("network","wan","dns", dns)
	elseif pre_mode == "pppoe" then
		uci:delete("network","wan","username")
		uci:delete("network","wan","password")
	else
	end

	uci:set("network","wan","proto","dhcp")
	uci:set("network","wan","mode","dhcp")
	uci:delete("network","wan","username")
	uci:delete("network","wan","password")
	uci:commit("network")

	luci.sys.call("rm -f /etc/config/repeater_web")

	local url = luci.dispatcher.build_url("admin/home/dhcpset") .. "" .. "?action=dhcpset"
	url = url .. "" ..  "?result=success";
	luci.http.redirect(url)
end

function action_Static_Set()
	local uci = require("luci.model.uci").cursor()
	local function param(x)
		return luci.http.formvalue(x)
	end

	local account = param("ipaddr") or "0.0.0.0"
	local password = param("netmask") or "255.255.255.0"
	local gateway = param("gateway") or "0.0.0.0"
	local dns = param("dns") or "0.0.0.0"

	local pre_mode = uci:get("network","wan","mode")
	if pre_mode == "repeater" then
		uci:delete("wireless","mt7628","ApCliEnable")
		uci:delete("wireless","mt7628","ApCliAuthMode")
		uci:delete("wireless","mt7628","ApCliEncrypType")
		if ApCliEncrypType == "WEP" then
			uci:delete("wireless","mt7628","ApCliDefaultKeyID")
			uci:delete("wireless","mt7628","ApCliKey1")
		else
			uci:delete("wireless","mt7628","ApCliWPAPSK")
		end
		uci:delete("wireless","mt7628","ApCliSsid")
		uci:set("wireless","mt7628","channel",0)
	elseif pre_mode == "static" then
		uci:delete("network","wan","ipaddr", ipaddr)
		uci:delete("network","wan","netmask", netmask)
		uci:delete("network","wan","gateway", gateway)
		uci:delete("network","wan","dns", dns)
	elseif pre_mode == "pppoe" then
		--uci:delete("network","wan","username")
		--uci:delete("network","wan","password")
	else
	end
	
	uci:set("network","wan","proto","static")
	uci:set("network","wan","mode","static")
	uci:set("network","wan","ipaddr", ipaddr)
	uci:set("network","wan","netmask", netmask)
	uci:commit("network")

	luci.sys.call("rm -f /etc/config/repeater_web")

	local url = luci.dispatcher.build_url("admin/home/dhcpset") .. "" .. "?action=dhcpset"
	url = url .. "" ..  "?result=success";
	luci.http.redirect(url)
end

function action_repStatus()
	local uci = require("luci.model.uci").cursor()
	local fs = require "luci.fs"
	local fwd = { }
	local function param(x)
		return luci.http.formvalue(x)
	end
	luci.sys.exec("iwpriv apcli0 show connStatus")
	local apcli = luci.util.pcdata(fs.readfile("/proc/apcli_info")) or "Disconnect"
	local mode =uci:get("network","wan","mode")
	if  string.find(apcli,"Disconnect") and string.find(apcli,"Disconnect") >= 1 then
		if mode == "repeater" then

			fwd[#fwd+1] = {
				msg = "2"
				}
		else

			fwd[#fwd+1] = {
				msg = "0"
			}
		end
	else

		fwd[#fwd+1] = {
			msg = "1"
		}
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json(fwd)
end


function action_wifiSet()
	local uci = require("luci.model.uci").cursor()
	local function param(x)
		return luci.http.formvalue(x)
	end

	local ssid = param("ssid_24g") or "HappyHome"
	local key = param("key_24g") or "00000000"

	luci.sys.call("uci set wireless.@wifi-iface[0].ssid=%q"%ssid)
	luci.sys.call("uci set wireless.@wifi-iface[0].encryption=psk2+tkip+ccmp")
	luci.sys.call("uci set wireless.@wifi-iface[0].key=%q"%key)
	luci.sys.call("uci set wireless.@wifi-iface[0].disabled=0")
	uci:commit("wireless")

	local url = luci.dispatcher.build_url("admin/home/mainpage") .. "" .. "?action=wifiset"
	url = url .. "" ..  "?result=success";
	luci.http.redirect(url)
end


function action_passwordChange()
	local function param(x)
	        return luci.http.formvalue(x)
	end
	function sleep(n)
		if n > 0 then 
			os.execute("ping -w " .. tonumber(n + 1) .. " localhost > NUL") 
		end
    end

	local pwd1=param("newPassword")
	local pwd2=param("newPassword1")
	--luci.sys.call("echo password=%q>>/tmp/tmp.log"%pwd)
	
    if luci.sys.user.setpasswd("admin",pwd1) ~= 0 then 
    	luci.sys.call("echo password=%q > /tmp/pwd.log"%pwd1)
    end

    local url = luci.dispatcher.build_url("admin/home/mainpage") .. "" .. "?action=pwdset"
	luci.http.redirect(url)
end


function action_Reboot()
	local url = luci.dispatcher.build_url("admin/home") 
	luci.sys.exec("echo reboot ...>> /tmp/tmp.log")
	--luci.http.redirect(url)
	luci.sys.reboot()
end

function action_ResetFactory()
	function sleep(n)
		if n > 0 then 
			os.execute("ping -w " .. tonumber(n + 1) .. " localhost > NUL") 
		end
    end

	--local url = luci.dispatcher.build_url("admin/home/reset") 
	luci.sys.exec("echo reboot ...>> /tmp/tmp.log")
	luci.sys.exec("mtd erase rootfs_data")
	sleep(1)

	luci.sys.reboot()
	--luci.http.redirect(url)	
end

function action_LanIPSet()

	local uci = require("luci.model.uci").cursor()
--	local url = luci.dispatcher.build_url("admin/homePage/lanIp") 
	local function param(x)
		return luci.http.formvalue(x)
	end
	local lanip = param("ip") or "192.168.11.1"
	uci:set("network","lan","ipaddr",lanip)
	uci:commit("network")

    local ip =uci:get("network","lan","ipaddr")
	luci.sys.exec("echo lanip =%q > /tmp/lanip.log"%ip)
	local url = luci.dispatcher.build_url("admin/home/mainpage") .. "" .. "?action=lanipset"
	luci.http.redirect(url)
	--luci.sys.exec("reboot")
end

function action_lease_status()
	local s = require "luci.tools.status"

	luci.http.prepare_content("application/json")
	luci.http.write_json(s.dhcp_leases())
end

--[[
function action_syslog()
	local syslog = luci.sys.syslog()
	luci.template.render("admin_status/syslog", {syslog=syslog})
end

function action_dmesg()
	local dmesg = luci.sys.dmesg()
	luci.template.render("admin_status/dmesg", {dmesg=dmesg})
end

function action_iptables()
	if luci.http.formvalue("zero") then
		if luci.http.formvalue("zero") == "6" then
			luci.util.exec("ip6tables -Z")
		else
			luci.util.exec("iptables -Z")
		end
		luci.http.redirect(
			luci.dispatcher.build_url("admin", "status", "iptables")
		)
	elseif luci.http.formvalue("restart") == "1" then
		luci.util.exec("/etc/init.d/firewall reload")
		luci.http.redirect(
			luci.dispatcher.build_url("admin", "status", "iptables")
		)
	else
		luci.template.render("admin_status/iptables")
	end
end

function action_bandwidth(iface)
	luci.http.prepare_content("application/json")

	local bwc = io.popen("luci-bwc -i %q 2>/dev/null" % iface)
	if bwc then
		luci.http.write("[")

		while true do
			local ln = bwc:read("*l")
			if not ln then break end
			luci.http.write(ln)
		end

		luci.http.write("]")
		bwc:close()
	end
end

function action_wireless(iface)
	luci.http.prepare_content("application/json")

	local bwc = io.popen("luci-bwc -r %q 2>/dev/null" % iface)
	if bwc then
		luci.http.write("[")

		while true do
			local ln = bwc:read("*l")
			if not ln then break end
			luci.http.write(ln)
		end

		luci.http.write("]")
		bwc:close()
	end
end

function action_load()
	luci.http.prepare_content("application/json")

	local bwc = io.popen("luci-bwc -l 2>/dev/null")
	if bwc then
		luci.http.write("[")

		while true do
			local ln = bwc:read("*l")
			if not ln then break end
			luci.http.write(ln)
		end

		luci.http.write("]")
		bwc:close()
	end
end

function action_connections()
	local sys = require "luci.sys"

	luci.http.prepare_content("application/json")

	luci.http.write("{ connections: ")
	luci.http.write_json(sys.net.conntrack())

	local bwc = io.popen("luci-bwc -c 2>/dev/null")
	if bwc then
		luci.http.write(", statistics: [")

		while true do
			local ln = bwc:read("*l")
			if not ln then break end
			luci.http.write(ln)
		end

		luci.http.write("]")
		bwc:close()
	end

	luci.http.write(" }")
end

function action_nameinfo(...)
	local i
	local rv = { }
	for i = 1, select('#', ...) do
		local addr = select(i, ...)
		local fqdn = nixio.getnameinfo(addr)
		rv[addr] = fqdn or (addr:match(":") and "[%s]" % addr or addr)
	end

	luci.http.prepare_content("application/json")
	luci.http.write_json(rv)
end
]]--
