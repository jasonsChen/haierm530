module("luci.controller.urlfilter", package.seeall)
function index()
		if not nixio.fs.access("/etc/config/repeater_web") then
        entry({"admin", "network", "urlfilter"}, cbi("urlfilter"), _("Url Filter"), 100)
        end
end