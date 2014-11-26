local wa = require "luci.tools.webadmin"
local fs = require "nixio.fs"

m = Map("ap", translate("AP Manager"),
	translate("This page allows you to manage AP router below, please do not modify the MAC, model. Configuration effect within 2 minutes."))
		
s = m:section(TypedSection, "ap", translate("AP List"))
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true
s.sortable  = false

t = s:option(Value, "nick", translate("Name"))


t = s:option(Value, "macaddr", translate("MAC"))
t.template = "cbi/displayvalue"
t.datatype = "macaddr"

t = s:option(Value, "model", translate("Model"))
t.template = "cbi/displayvalue"

t = s:option(ListValue, "channel", translate("Channel"))
t:value("auto")
for v=1,13 do
	t:value(v)
end

t = s:option(ListValue, "maxassoc", translate("Assoc"))
for v=8,64,8 do
	t:value(v)
end
t:value("nolimit")

t = s:option(ListValue, "power", translate("Power"))
for v=10,100,10 do
	t:value(v)
end

t = s:option(Value, "ssid", translate("SSID"))

return m