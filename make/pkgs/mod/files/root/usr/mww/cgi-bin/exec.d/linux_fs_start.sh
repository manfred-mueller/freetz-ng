cgi_begin 'linux_fs_start ...'
echo '<pre>Toggling ...'

[ -r /etc/options.cfg ] && . /etc/options.cfg
FWLAYOUT=''
[ "$FREETZ_AVM_HAS_FWLAYOUT_4" == "y" ] && FWLAYOUT='4'
[ "$FREETZ_AVM_HAS_FWLAYOUT_5" == "y" ] && FWLAYOUT='5'

case "$FWLAYOUT" in
	4)	# UIMG
		. /bin/env.mod.rcconf avm
		LFS_LIVE="$(sed -n 's/^linux_fs_start[ \t]*//p' /proc/sys/urlader/environment)"
		[ -z "$LFS_LIVE" ] && LFS_LIVE=0
		LFS_DEAD="$(( ($LFS_LIVE+1) %2 ))"
		echo "changing $LFS_LIVE -> $LFS_DEAD ... and rebooting"
		/bin/aicmd pumaglued uimg switchandreboot && LFS_TEST="$LFS_DEAD" || LFS_TEST="9"
		;;
	5)	# FIT
		. /bin/env.mod.rcconf avm  # CONFIG_ENVIRONMENT_PATH
		LFS_LIVE="$(bootslotctl get_active)"
		LFS_DEAD="$(bootslotctl get_other)"
		if [ "$LFS_LIVE" == "$LFS_DEAD" ]; then
			echo "unavailable"
			LFS_TEST="9"
		else
			echo "changing $LFS_LIVE -> $LFS_DEAD"
			bootslotctl activate_other
			LFS_TEST="$(bootslotctl get_active)"
		fi
		;;
	*)
		LFS_LIVE="$(sed -n 's/^linux_fs_start[ \t]*//p' /proc/sys/urlader/environment)"
		[ -z "$LFS_LIVE" ] && LFS_LIVE=0
		LFS_DEAD="$(( ($LFS_LIVE+1) %2 ))"
		echo "changing $LFS_LIVE -> $LFS_DEAD"
		echo "linux_fs_start $LFS_DEAD" > /proc/sys/urlader/environment
		LFS_TEST="$(sed -n 's/^linux_fs_start[ \t]*//p' /proc/sys/urlader/environment)"
		;;
esac
[ "$LFS_TEST" != "$LFS_DEAD" ] && echo "failed." || echo "done."

echo '</pre>'
back_button mod system
cgi_end
