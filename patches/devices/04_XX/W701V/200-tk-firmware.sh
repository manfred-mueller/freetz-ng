if [ -z "$FIRMWARE2" ]
then
	echo "ERROR: no tk firmware" 1>&2
	exit 1
fi

echo1 "removing TCOM Webinterface"
rm -rf "${FILESYSTEM_MOD_DIR}/usr/www/tcom"

echo1 "copying AVM Webinterface"
mkdir "${HTML_LANG_MOD_DIR}"
"$TAR_BBA" -c -C "${DIR}/.tk/original/filesystem/usr/www/all" --exclude=html/de/usb . | "$TAR_BBA" -x -C "${HTML_LANG_MOD_DIR}"
ln -sf /usr/www/all "${FILESYSTEM_MOD_DIR}/usr/www/tcom"
ln -sf /usr/www/all "${FILESYSTEM_MOD_DIR}/usr/www/congstar"
ln -sf /usr/www/all "${FILESYSTEM_MOD_DIR}/usr/www/avm"
ln -s /usr/bin/system_status "${FILESYSTEM_MOD_DIR}/usr/www/cgi-bin/system_status"

"$TAR_BBA" -c -C "${DIR}/.tk/original/filesystem/etc/default.Fritz_Box_7141/avm" --exclude=*.cfg . | "$TAR_BBA" -x -C "${FILESYSTEM_MOD_DIR}/etc/default.Fritz_Box_SpeedportW701V/tcom"
ln -sf tcom "${FILESYSTEM_MOD_DIR}/etc/default.Fritz_Box_SpeedportW701V/avm"
ln -sf tcom "${FILESYSTEM_MOD_DIR}/etc/default.Fritz_Box_SpeedportW701V/congstar"

# Activate backup-/restore menu
modsed 's,CONFIG_STOREUSRCFG="n",CONFIG_STOREUSRCFG="y",g' "${FILESYSTEM_MOD_DIR}/etc/init.d/rc.conf"

echo1 "copying mailer"
cp -a "${DIR}/.tk/original/filesystem/sbin/mailer" "${FILESYSTEM_MOD_DIR}/sbin"


