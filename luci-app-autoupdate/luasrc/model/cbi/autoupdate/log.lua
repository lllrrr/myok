local fs=require "nixio.fs"
local conffile="/tmp/autoupdate.log"

log = SimpleForm("autoupdate")
log.reset = false
log.submit = false
t=log:field(TextValue,"conf")
t.rmempty=true
t.rows=20
function t.cfgvalue()
	return fs.readfile(conffile) or ""
end
t.readonly="readonly"

return log
