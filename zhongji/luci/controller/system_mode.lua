module("luci.controller.system_mode", package.seeall)
function index()
        entry({"admin", "system", "system_mode"}, cbi("system_mode"), _("System Mode"), 5)
        end