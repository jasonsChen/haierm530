module("luci.controller.advanced_security_settings", package.seeall)
function index()
		if not nixio.fs.access("/etc/config/repeater_web") then
        entry({"admin", "network", "advanced_security_settings"}, cbi("advanced_security_settings"), _("DOS"), 100)
        end
end