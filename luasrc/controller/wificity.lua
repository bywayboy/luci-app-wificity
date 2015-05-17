--[[
LuCI - Lua Configuration Interface

Copyright 2014 bywayboy <bywayboy@qq.com>

]]--

module("luci.controller.wificity", package.seeall)

function index()
	
	if nixio.fs.access("/etc/config/wificity") then
		entry({"admin", "services", "wificity_status"}, call("action_wificity_status"))
		entry({"admin", "services", "wificity"}, cbi("admin_services/wificity"), _("Wificity Settings")).dependent = true
		entry({"admin", "services", "whitemac"}, cbi("admin_services/whitemac"),_("White MAC"))
	end
end


function action_wificity_status()
	local cmd = tostring(luci.http.formvalue("cmd"))
	local _ = luci.i18n.translate
	local result = {["conn"]=0,["login"]=0,["cafe_name"]=_("Unknown"), ["group_name"]=_("Unknown"), ["cafe_id"]=_("Unknown")}
	local stat_file = "/var/wificity.stat"
	
	if nil ~= cmd and cmd=="restart" then
		luci.sys.call("/etc/init.d/wificity restart >/dev/null")
	end
	luci.http.prepare_content("application/json")
	if nixio.fs.access(stat_file) then
		luci.http.write( nixio.fs.readfile(stat_file));
	else
		luci.http.write_json(result);
	end
end
