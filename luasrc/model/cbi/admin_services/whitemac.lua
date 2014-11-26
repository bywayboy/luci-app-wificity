local sys = require "luci.sys"
local uci    = require "luci.model.uci"
local _ = luci.i18n.translate
local m


m = Map("wificity", _("MAC white list manage."),
		_("This page allows you to set MAC address white list."))	

-- after save callback 
	m.on_after_commit = function(self)
		--luci.sys.call("/etc/init.d/wificity restart >/dev/null") 
	end
	
s = m:section(TypedSection, "whitemac", translate("White List MAC address"))
s.anonymous = true

val = s:option(DynamicList, "mac", translate("MAC"))
val.datatype = "list(macaddr)"
val.rmempty  = true
val.addremove  = true

sys.net.arptable(function(entry)
	val:value(
		entry["HW address"],
		entry["HW address"] .. " (" .. entry["IP address"] .. ")"
	)
end)


return m
