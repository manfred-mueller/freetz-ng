#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int main()
{
char name[6] = "vlmcsd";
char cmd1[100];
char cmd2[150];
char cmd3[100];
char cmd4[100];
char cmd5[150];
scanf(cmd1, "for file in \
/etc/default.%s/%s.cfg; do \
if [ -f $file ]; then cp $file /mod$file; fi; done", &name);
scanf(cmd2, "for file in \
/etc/default.%s \
/usr/lib/cgi-bin/%s.cgi \
/etc/%s.kmd \
/etc/init.d/rc.%s; do \
if [ -f $file -o -d $file ]; then ln -s $file /mod$file; fi; done", &name);

scanf(cmd3, "modreg daemon %s", &name);
scanf(cmd4, "modreg cgi %s \"Microsoft KMS-Server\"", &name);
scanf(cmd5, "if [ $(grep ENABLED /var/mod/etc/conf/%s.cfg | cut -d'\"' -f2) = \"yes\" ]; then /var/mod/etc/init.d/rc.%s start; fi", &name);
system(cmd1);
system(cmd2);
system(cmd3);
system(cmd4);
system(cmd5);
return 0;
}