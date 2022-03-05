m = Map("autoupdate", translate("AutoUpdate"),
translate("AutoUpdate LUCI supports scheduled upgrade & one-click firmware upgrade")
)

s = m:section(TypedSection, "autoupdate")
s.anonymous = true

local default_url = luci.sys.exec("uci -q get autoupdate.@autoupdate[0].github")
local default_flag = luci.sys.exec("uci -q get autoupdate.@autoupdate[0].flag")
local default_configf = luci.sys.exec("uci -q get autoupdate.@autoupdate[0].configf")
local default_scriptf = luci.sys.exec("uci -q get autoupdate.@autoupdate[0].scriptf")
luci.sys.call ("cat /dev/null > /tmp/autoupdate.log")

github = s:option(Value,"github", translate("Server Url"))
github.default = default_url
github.rmempty = false

flag = s:option(Value,"flag", translate("Firmware Name"))
flag.default = default_flag
flag.rmempty = false

configf = s:option(Value,"configf", translate("Config Name"))
configf.default = default_configf
configf.rmempty = false

scriptf = s:option(Value,"scriptf", translate("Script Name"))
scriptf.default = default_scriptf
scriptf.rmempty = false

return m
