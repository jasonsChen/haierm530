module("luci.controller.remotesc", package.seeall)
function index()
		if not nixio.fs.access("/etc/config/repeater_web") then
        entry({"admin", "network", "remotesc"}, cbi("remotesc"), _("Remote Access Control"), 100)
        end
end