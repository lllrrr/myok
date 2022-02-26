module("luci.controller.autoupdate",package.seeall)

function index()
	entry({"admin", "system","autoupdate"}).dependent = true
	entry({"admin", "system","autoupdate", "show"}, call("show_menu")).leaf = true
	entry({"admin", "system","autoupdate", "hide"}, call("hide_menu")).leaf = true
	if nixio.fs.access("/etc/config/passwall_show") then
	entry({"admin", "system", "autoupdate"}, alias("admin", "system", "autoupdate", "manual"),_("AutoUpdate"), 99).dependent = true
	end
	--entry({"admin", "system", "autoupdate", "main"}, cbi("autoupdate/main"),_("Scheduled Upgrade"), 10).leaf = true
	entry({"admin", "system", "autoupdate", "manual"}, cbi("autoupdate/manual"),_("Manually Upgrade"), 20).leaf = true
	entry({"admin", "system", "autoupdate", "log"}, form("autoupdate/log"),_("Upgrade Log"), 30).leaf = true

	entry({"admin", "system", "autoupdate", "print_log"}, call("print_log")).leaf = true
end

function print_log()
	luci.http.write(luci.sys.exec("tail -n 100 /tmp/AutoUpdate.log 2> /dev/null"))
end

function show_menu()
	luci.sys.call("touch /etc/config/passwall_show")
	luci.http.redirect(luci.dispatcher.build_url("admin", "system", "autoupdate"))
end

function hide_menu()
	luci.sys.call("rm -rf /etc/config/passwall_show")
	luci.http.redirect(luci.dispatcher.build_url("admin", "status", "overview"))
end