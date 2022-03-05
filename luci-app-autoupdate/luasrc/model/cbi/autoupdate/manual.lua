m = Map("autoupdate",translate("Manually Upgrade"),translate("Manually upgrade Firmware or Script"))
s = m:section(TypedSection,"autoupdate")
s.anonymous = true

check_updates = s:option (Button, "_check_updates", translate("Download Firmware"),translate("Please wait for the page to refresh after clicking Download Firmware button"))
check_updates.inputtitle = translate ("Download Firmware")
check_updates.write = function()
	luci.sys.call ("rm -rf /tmp/tmp/*")
	luci.sys.call ("cat /dev/null > /tmp/autoupdate.log")
	luci.sys.call ("wget -P /tmp/tmp http://$(uci -q get autoupdate.@autoupdate[0].github)/fw/$(uci -q get autoupdate.@autoupdate[0].flag).bin")
	luci.sys.call ("wget -P /tmp/tmp http://$(uci -q get autoupdate.@autoupdate[0].github)/fw/$(uci -q get autoupdate.@autoupdate[0].flag)")
	luci.sys.call ("cd /tmp/tmp && md5sum -c $(uci -q get autoupdate.@autoupdate[0].flag) 2> /dev/null | grep OK >> /tmp/autoupdate.log")
	luci.http.redirect(luci.dispatcher.build_url("admin", "services", "autoupdate","log"))
end

upgrade_fw = s:option (Button, "_upgrade_fw", translate("Upgrade Firmware"),translate("Upgrade with Flashing (DANGEROUS)"))
upgrade_fw.inputtitle = translate ("Upgrade Firmware")
upgrade_fw.write = function()
	luci.sys.call ("sysupgrade -n -q /tmp/tmp/$(uci -q get autoupdate.@autoupdate[0].flag).bin")
	luci.http.redirect(luci.dispatcher.build_url("admin", "services", "autoupdate","log"))
end

upgrade_config = s:option (Button, "_upgrade_config", translate("Upgrade Config"),translate("Using the Config"))
upgrade_config.inputtitle = translate ("Upgrade Config")
upgrade_config.write = function()
	luci.sys.call ("wget -P /tmp/tmp http://$(uci -q get autoupdate.@autoupdate[0].github)/config/$(uci -q get autoupdate.@autoupdate[0].configf)")
	luci.sys.call ("cp -f /tmp/tmp/$(uci -q get autoupdate.@autoupdate[0].configf) /etc/config/")
	luci.sys.call ("/etc/init.d/passwall restart > /dev/null 2>&1 &")
	luci.sys.call ("echo 'Update config success' >> /tmp/autoupdate.log")
	luci.http.redirect(luci.dispatcher.build_url("admin", "services", "autoupdate","log"))
end

upgrade_script = s:option (Button, "_upgrade_script", translate("Upgrade Script"),translate("Using the Script"))
upgrade_script.inputtitle = translate ("Upgrade Script")
upgrade_script.write = function()
	luci.sys.call ("wget -P /tmp/tmp http://$(uci -q get autoupdate.@autoupdate[0].github)/script/$(uci -q get autoupdate.@autoupdate[0].scriptf)")
	luci.sys.call ("chmod +x /tmp/tmp/$(uci -q get autoupdate.@autoupdate[0].scriptf)")
	luci.sys.call ("sh /tmp/tmp/$(uci -q get autoupdate.@autoupdate[0].scriptf)")
	luci.sys.call ("/etc/init.d/passwall restart > /dev/null 2>&1 &")
	luci.sys.call ("echo 'Update Script success' >> /tmp/autoupdate.log")
	luci.http.redirect(luci.dispatcher.build_url("admin", "services", "autoupdate","log"))
end

return m
