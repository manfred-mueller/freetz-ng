#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int main()
{
system("for file in /etc/default.vlmcsd/vlmcsd.cfg; do if [ -f $file ]; then cp $file /mod/etc/conf; fi; done");
system("for file in /etc/default.vlmcsd /usr/lib/cgi-bin/vlmcsd.cgi /etc/init.d/rc.vlmcsd; do if [ -f $file -o -d $file ]; then ln -s $file /mod$file; fi; done");
system("modreg daemon vlmcsd");
system("modreg cgi vlmcsd \"Microsoft KMS-Server\"");
system("if [ $(grep AUTOSTART /var/mod/etc/conf/vlmcsd.cfg | cut -d'\"' -f2) = \"yes\" ]; then /var/mod/etc/init.d/rc.vlmcsd start; fi");
return 0;
}
