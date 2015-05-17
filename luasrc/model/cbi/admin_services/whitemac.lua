local sys = require "luci.sys"
local uci    = require "luci.model.uci"
local _ = luci.i18n.translate
local m


m = Map("wbmac", _("MAC white list manage."),
		_("This page allows you to set MAC address white list."))	

-- after save callback 
	m.on_after_commit = function(self)
		--luci.sys.call("/etc/init.d/wificity restart >/dev/null") 
	end
	
s = m:section(TypedSection, "macitem", translate("White List MAC address"))
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true
s.sortable  = false

val = s:option(Value,"memo", translate("Description"))
val.rmempty = true

mac = s:option(Value, "mac", translate("MAC"))
mac.rmempty    = false

sys.net.arptable(function(entry)
	mac:value(
		entry["HW address"],
		entry["HW address"] .. " (" .. entry["IP address"] .. ")"
	)
end)

mac.datatype = "macaddr"

local ml={}

function mac_exist(m)
	for k,v in pairs(ml) do
		if string.upper(m) == string.upper(v) then return false end
	end
	return true
end

function mac.validate(self, value, section)
	local m = mac:formvalue(section) or ""
	if not mac_exist(m) then
		return  nil, "Mac already existed."..m
	end

	if #m == 17 then
		ml[#ml+1]=m
	end
	return Value.validate(self, value, section)
end

val = s:option(ListValue, "white", translate("white"))
val:value(1,"white")
val:value(0,"black")
return m
