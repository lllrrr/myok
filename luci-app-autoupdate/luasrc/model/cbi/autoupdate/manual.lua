m = Map("autoupdate",translate("Manually Upgrade"),translate("Manually upgrade Firmware or Script"))
s = m:section(TypedSection,"autoupdate")
s.anonymous = true

check_updates = s:option (Button, "_check_updates", translate("Download Firmware"),translate("Please wait for the page to refresh after clicking Download Firmware button"))
check_updates.inputtitle = translate ("Download Firmware")
check_updates.write = function()
	luci.sys.call ("rm -rf /tmp/tmp/*")
	luci.sys.call ("cat /dev/null > /tmp/adupdate.log")
	luci.sys.call ("wget -P /tmp/tmp http://fw.ydns.xyz/xy/firmware.bin")
	luci.sys.call ("wget -P /tmp/tmp http://fw.ydns.xyz/xy/md5sums")
	luci.sys.call ("cd /tmp/tmp && md5sum -c md5sums 2> /dev/null | grep OK >> /tmp/adupdate.log")
	luci.http.redirect(luci.dispatcher.build_url("admin", "services", "autoupdate","log"))
end

upgrade_fw_force = s:option (Button, "_upgrade_fw_force", translate("Upgrade Firmware"),translate("Upgrade with Force Flashing (DANGEROUS)"))
upgrade_fw_force.inputtitle = translate ("Upgrade Firmware")
upgrade_fw_force.write = function()
	luci.sys.call ("sysupgrade -v /tmp/tmp/firmware.bin")
	luci.http.redirect(luci.dispatcher.build_url("admin", "services", "autoupdate","log"))
end

upgrade_config = s:option (Button, "_upgrade_config", translate("Upgrade Config"),translate("Using the latest Config may solve some compatibility problems"))
upgrade_config.inputtitle = translate ("Upgrade Config")
upgrade_config.write = function()
	luci.sys.call ("wget -P /tmp/tmp http://fw.ydns.xyz/config/passwall")
	luci.sys.call ("cp -f /tmp/tmp/passwall /etc/config/")
	luci.sys.call ("/etc/init.d/passwall restart > /dev/null 2>&1 &")
	luci.http.redirect(luci.dispatcher.build_url("admin", "services", "autoupdate","log"))
end

upgrade_script = s:option (Button, "_upgrade_script", translate("Upgrade Script"),translate("Using the latest Script may solve some compatibility problems"))
upgrade_script.inputtitle = translate ("Upgrade Script")
upgrade_script.write = function()
	luci.sys.call ("wget -P /tmp/tmp http://fw.ydns.xyz/script/passwallmod")
	luci.sys.call ("chmod +x /tmp/tmp/passwallmod")
	luci.sys.call ("sh /tmp/tmp/passwallmod")
	luci.sys.call ("/etc/init.d/passwall restart > /dev/null 2>&1 &")
	luci.http.redirect(luci.dispatcher.build_url("admin", "services", "autoupdate","log"))
end

return m
