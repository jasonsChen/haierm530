--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

module("luci.controller.admin.index", package.seeall)

function index()
	local root = node()
	if not root.target then
		root.target = alias("admin")
		root.index = true
	end

	local page   = node("admin")

	--page.target  = firstchild()
	local uci = luci.model.uci.cursor()
	local wan_mode = uci:get("network","wan","mode") or "dhcp"
	--local wan_mode = dhcp
	--luci.sys.call("echo dhcp %q dhcp > /dev/console"%wan_mode)
	if wan_mode == "dhcp" then
		page.target = template("admin_home/dynamicaddress")
	elseif wan_mode == "static" then
		page.target = template("admin_home/staticaddress")
	elseif wan_mode == "repeater" then
		page.target = template("admin_home/reperter")
	else
		page.target = firstchild()
	end

	page.title   = _("Administration")
	page.order   = 10
	page.sysauth = "admin"
	page.sysauth_authenticator = "htmlauth"
	page.ucidata = true
	page.index = true

	-- Empty services menu to be populated by addons
	entry({"admin", "services"}, firstchild(), _("Services"), 40).index = true

	entry({"admin", "logout"}, call("action_logout"), _("Logout"), 90)
end

function action_logout()
	local dsp = require "luci.dispatcher"
	local sauth = require "luci.sauth"
	if dsp.context.authsession then
		sauth.kill(dsp.context.authsession)
		dsp.context.urltoken.stok = nil
	end

	luci.http.header("Set-Cookie", "sysauth=; path=" .. dsp.build_url())
	luci.http.redirect(luci.dispatcher.build_url())
end
