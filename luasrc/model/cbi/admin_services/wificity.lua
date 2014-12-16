--[[
Author: bywayboy<bywayboy@qq.com>
Date:2014-04-12
]]--


local sys = require "luci.sys"
local datatypes = require "luci."
local uci    = require "luci.model.uci"
local cur = uci.cursor();
local http = require "luci.http";
local m

	m = Map("wificity", translate("Wificity Settings Page"), translate("Here you can configure the online options."))


	m.on_after_commit = function(self)
		luci.sys.call("/etc/init.d/privoxy restart >/dev/null") 
	end
	s = m:section(TypedSection, "remoteserver")
	s.anonymous = true
	s.addremove = false


--	o = s:option(Value, "host", translate("Server address"))
--	o.datatype="host"
	
	o = s:option(Value, "port", translate("Port"))
	o.datatype="integer"
	
	o = s:option(Value, "heart_rate", translate("Heart rate"))
	o.datatype="integer"
	
	o = s:option(Value, "conn_timeout", translate("Connection timeout"))
	o.datatype="integer"

	o = s:option(Value, "state", translate("Running Info"))
	o.datatype="host"
	o.template = "admin_services/wificity_status"
	
	s = m:section(TypedSection, "url")
	s.anonymous = true
	
	o = s:option(Flag , "url_on", translate("Url monitor"))
	
	o = s:option(Value, "save_path", translate("Save path"))
	o.datatype="string"
	o:depends("url_on", "1")
	
	o = s:option(Value, "url_interval", translate("Url File Interval"))
	o.datatype="string"
	o:depends("url_on", "1")
	
	o = s:option(Value, "url_server", translate("Url server host"))
	o.datatype="string"
	o:depends("url_on", "1")

	s = m:section(TypedSection, "ad")
	s.anonymous = true
	
	o = s:option(Flag , "open", translate("AD Settings"))
return m;
