#!/bin/sh

. /usr/lib/libmodcgi.sh

sec_begin "$(lang de:"Starttyp" en:"Start type")"
cgi_print_radiogroup_service_starttype "enabled" "$VLMCSD_ENABLED" "" "" 0
sec_end

sec_begin "$(lang de:"Netzwerkeinstellungen" en:"Network settings")"

cat << EOF
<p>$(lang de:"Lausche an IP-Adresse" en:"Listen at IP-Adress"): <input id="ip" type="text" name="ip" value="$(html "$VLMCSD_IP")">
<br />$(lang de:"Port" en:"Port"): <input id="port" type="text" name="port" value="$(html "$VLMCSD_PORT")">
<br />$(lang de:"Aktivierung erneuern nach" en:"Renew activation after"): <input id="renew" type="text" name="renew" value="$(html "$VLMCSD_RENEW")"></p>
<br />$(lang de:"Neuer Versuch nach" en:"Retry after"): <input id="retry" type="text" name="retry" value="$(html "$VLMCSD_RETRY")"></p>
EOF

sec_end
