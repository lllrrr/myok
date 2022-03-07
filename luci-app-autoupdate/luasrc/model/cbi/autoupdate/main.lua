m = Map("autoupdate", translate("AutoUpdate"),
translate("AutoUpdate LUCI supports scheduled upgrade & one-click firmware upgrade")
)

s = m:section(TypedSection, "autoupdate")
s.anonymous = true

github = s:option(Value,"github", translate("Server Url"))
github.default = "10.0.0.100"
github.rmempty = true

flag = s:option(Value,"flag", translate("Firmware Name"))
flag.default = "firmware"
flag.rmempty = true

configf = s:option(Value,"configf", translate("Config Name"))
configf.default = "config"
configf.rmempty = true

scriptf = s:option(Value,"scriptf", translate("Script Name"))
scriptf.default = "script"
scriptf.rmempty = true

return m
