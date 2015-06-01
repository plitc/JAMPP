#!/bin/sh

### LICENSE - (BSD 2-Clause) // ###
#
# Copyright (c) 2015, Daniel Plominski (Plominski IT Consulting)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice, this
# list of conditions and the following disclaimer in the documentation and/or
# other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
### // LICENSE - (BSD 2-Clause) ###

### ### ### PLITC // ### ### ###

### stage0 // ###
OSVERSION=$(uname)
JAILED=$(sysctl -a | grep -c "security.jail.jailed: 1")
MYNAME=$(whoami)
#
PRG="$0"
##/ need this for relative symlinks
while [ -h "$PRG" ] ;
do
   PRG=$(readlink "$PRG")
done
DIR=$(dirname "$PRG")
#
ADIR="$PWD"
#
#/ spinner
spinner()
{
   local pid=$1
   local delay=0.01
   local spinstr='|/-\'
   while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
         local temp=${spinstr#?}
         printf " [%c]  " "$spinstr"
         local spinstr=$temp${spinstr%"$temp"}
         sleep $delay
         printf "\b\b\b\b\b\b"
   done
   printf "    \b\b\b\b"
}
#
#/ function cleanup tmp
cleanup(){
   rm -rf /etc/jampp/tmp/*
}
### // stage0 ###

case "$1" in
'install')
### stage1 // ###
case $OSVERSION in
FreeBSD)
### stage2 // ###
#
### // stage2 ###

### stage3 // ###
if [ "$MYNAME" = "root" ]; then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] You must be root to run this script"
   exit 1
fi
if [ "$JAILED" = "1" ]; then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] Run this script inside an FreeBSD JAIL"
   exit 1
fi
### stage4 // ###
#
### ### ### ### ### ### ### ### ###

#/ PKG
echo "---> PKG: update"
   (pkg update) & spinner $!
echo "---> PKG: upgrade"
   (pkg upgrade -y) & spinner $!

#/ Curl
CHECKPKGCURL=$(pkg info | grep -c "curl")
if [ "$CHECKPKGCURL" = "0" ]; then
   echo "---> PKG: add ftp/curl"
   (pkg install -y ftp/curl) & spinner $!
fi

#/ Apache
CHECKPKGAPACHE=$(pkg info | grep -c "apache24")
if [ "$CHECKPKGAPACHE" = "0" ]; then
   echo "---> PKG: add www/apache24"
   (pkg install -y www/apache24) & spinner $!
fi
CHECKAPACHE=$(grep -c "apache24_enable" /etc/rc.conf)
if [ "$CHECKAPACHE" = "0" ]; then
   #/DEPRECATED echo 'apache24_enable="YES"' >> /etc/rc.conf
   sysrc apache24_enable=YES
fi

#/ PHP
CHECKPKGPHP=$(pkg info | grep -c "php56")
if [ "$CHECKPKGPHP" = "0" ]; then
   echo "---> PKG: add lang/php56"
   (pkg install -y lang/php56) & spinner $!
fi
CHECKPKGPHPEXTENSIONS=$(pkg info | grep -c "php56-extensions")
if [ "$CHECKPKGPHPEXTENSIONS" = "0" ]; then
   echo "---> PKG: add lang/php56-extensions"
   (pkg install -y lang/php56-extensions) & spinner $!
fi

#/ PHP-GD
CHECKPKGPHPGD=$(pkg info | grep -c "php56-gd")
if [ "$CHECKPKGPHPGD" = "0" ]; then
   echo "---> PKG: add graphics/php56-gd"
   (pkg install -y graphics/php56-gd) & spinner $!
fi

#/ PHP-MYSQLI
CHECKPKGPHPMYSQLI=$(pkg info | grep -c "php56-mysqli")
if [ "$CHECKPKGPHPGD" = "0" ]; then
   echo "---> PKG: add databases/php56-mysqli"
   (pkg install -y databases/php56-mysqli) & spinner $!
fi

#/ PHP Modules
CHECKPKGMODPHP=$(pkg info | grep -c "mod_php56")
if [ "$CHECKPKGMODPHP" = "0" ]; then
   echo "---> PKG: add www/mod_php56"
   (pkg install -y www/mod_php56) & spinner $!
#/ fi
#/ CHECKPHP=$(grep -c "libexec/apache24/libphp5.so" /usr/local/etc/apache24/httpd.conf)
#/ if [ "$CHECKPHP" = "0" ]; then
   echo "" >> /usr/local/etc/apache24/httpd.conf
   echo '### JAMPP // ###' >> /usr/local/etc/apache24/httpd.conf
#/   echo "" >> /usr/local/etc/apache24/httpd.conf
#/   echo 'LoadModule php5_module        libexec/apache24/libphp5.so' >> /usr/local/etc/apache24/httpd.conf
   echo "" >> /usr/local/etc/apache24/httpd.conf
cat <<"PHP1">> /usr/local/etc/apache24/httpd.conf
#

# <IfModule php5_module>
#    DirectoryIndex index.php index.php5 index.html
#    AddType application/x-httpd-php .php
#    AddType application/x-httpd-php-source .phps
# </IfModule>

# <FilesMatch "\.php$">
#    SetHandler application/x-httpd-php
# </FilesMatch>
# <FilesMatch "\.phps$">
#    SetHandler application/x-httpd-php-source
# </FilesMatch>

# AddType application/x-httpd-php .php
# AddType application/x-httpd-php-source .phps

# <IfModule php5_module>
#    <FilesMatch "\.(php|phps|php5|phtml)$">
#       SetHandler php5-script
#    </FilesMatch>
#    #/ DirectoryIndex index.php
#    DirectoryIndex index.php index.html index.htm
# </IfModule>

# <IfModule mime_module>
#    AddType application/x-httpd-php-source .phps
#    AddType application/x-httpd-php        .php
# </IfModule>

# <IfModule mod_php5.c>  
#    DirectoryIndex index.php index.php3 index.html  
#    AddType application/x-httpd-php .php  
#    AddType application/x-httpd-php-source .phps  
# </IfModule>

#
### // JAMPP ###
PHP1
   cp -f /usr/local/etc/php.ini-production /usr/local/etc/php.ini
   sed 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/g' /usr/local/etc/apache24/httpd.conf > /usr/local/etc/apache24/httpd.conf_MOD
   cp -f /usr/local/etc/apache24/httpd.conf_MOD /usr/local/etc/apache24/httpd.conf
   rm -f /usr/local/etc/apache24/httpd.conf_MOD
cat <<"PHP2"> /usr/local/etc/apache24/modules.d/001_mod_php.conf
<FilesMatch "\.php$">
   SetHandler application/x-httpd-php
</FilesMatch>
<FilesMatch "\.phps$">
   SetHandler application/x-httpd-php-source
</FilesMatch>
PHP2
fi

#/ Apache CHECK
(service apache24 configtest) & spinner $!
if [ "$?" != "0" ]; then
   echo "" # dummy
   echo "[ERROR] unknown config error"
   exit 1
fi

#/ start Apache
STARTAPACHE=$(service apache24 status | grep -c "not running")
if [ "$STARTAPACHE" = "1" ]; then
   (service apache24 restart) & spinner $!
fi

#/ MySQL Server
CHECKPKGMYSQL=$(pkg info | grep -c "mysql56-server")
if [ "$CHECKPKGMYSQL" = "0" ]; then
   echo "---> PKG: add databases/mysql56-server"
   (pkg install -y databases/mysql56-server) & spinner $!
fi

#/ PHP MySQL Server
CHECKPKGPHPMYSQL=$(pkg info | grep -c "php56-mysql")
if [ "$CHECKPKGPHPMYSQL" = "0" ]; then
   echo "---> PKG: add databases/php56-mysql"
   (pkg install -y databases/php56-mysql) & spinner $!
fi

CHECKMYSQL=$(grep -c "mysql_enable" /etc/rc.conf)
if [ "$CHECKMYSQL" = "0" ]; then
   #/DEPRECATED echo 'mysql_enable="YES"' >> /etc/rc.conf
   sysrc mysql_enable=YES
   cp -f /usr/local/share/mysql/my-default.cnf /etc/my.cnf
   (service mysql-server start) & spinner $!
   #/ rehash
   /bin/csh -c "rehash"
   hash
   mysqladmin -uroot password 'jampp'
   sync
fi

#/ MySQL CHECK
CHECKMYSQLD=$(service mysql-server status | grep -c "is running")
if [ "$CHECKMYSQLD" = "1" ]; then
   : # dummy
else
   echo "[ERROR] mysql is not running."
   exit 1
fi

#/ PHP FUNCTION CHECK
CHECKAPACHEPHP=$(service apache24 status | grep -c "is running")
if [ "$CHECKAPACHEPHP" = "1" ]; then
   (service apache24 restart) & spinner $!
   mkdir -p /usr/local/www/apache24/data/phptest
cat <<"APACHEPHP"> /usr/local/www/apache24/data/phptest/index.php
<?php
    phpinfo();
?>
APACHEPHP
   CHECKPHPTEST=$(curl -s http://localhost/phptest/index.php | grep -c "FreeBSD")
   if [ "$CHECKPHPTEST" = "0" ]; then
      echo "" # dummy
      echo "[ERROR] PHP TEST failed"
      echo "" # dummy
      exit 1
   fi
   if [ "$CHECKPHPTEST" -gt 0 ]; then
      echo "" # dummy
      echo "PHP TEST passed"
      echo "" # dummy
   fi
   rm -rf /usr/local/www/apache24/data/phptest
fi

#/ PHPMYADMIN
CHECKPKGPHPMYADMIN=$(pkg info | grep -c "phpMyAdmin")
if [ "$CHECKPKGPHPMYADMIN" = "0" ]; then
   echo "---> PKG: add databases/phpmyadmin"
   (pkg install -y databases/phpmyadmin) & spinner $!
cat <<"PHP3">> /usr/local/etc/apache24/httpd.conf
### JAMPP // ###
#
#/ PHPMyAdmin
Alias /phpmyadmin/ "/usr/local/www/phpMyAdmin/"

<Directory "/usr/local/www/phpMyAdmin/">
   Options None
   AllowOverride Limit

   # higher security
   #/ Require local
   #/ Require host .example.com

   # lower security
   Require all granted
</Directory>
#
### // JAMPP ###
PHP3
   (service apache24 restart) & spinner $!
fi

#/ Apache Perl
CHECKPKGMODPERL2=$(pkg info | grep -c "mod_perl2")
if [ "$CHECKPKGMODPERL2" = "0" ]; then
   echo "---> PKG: add www/mod_perl2"
   (pkg install -y www/mod_perl2) & spinner $!
cat <<"PHP4">> /usr/local/etc/apache24/httpd.conf
### JAMPP // ###
#
#/ MOD Perl2
LoadModule perl_module libexec/apache24/mod_perl.so
#
### // JAMPP ###
PHP4
   (service apache24 restart) & spinner $!
fi

#/ Webalizer
CHECKPKGWEBALIZER=$(pkg info | grep -c "webalizer")
if [ "$CHECKPKGWEBALIZER" = "0" ]; then
   echo "---> PKG: add www/webalizer"
   (pkg install -y www/webalizer) & spinner $!
   mkdir -p /usr/local/www/stats
   webalizer -o /usr/local/www/stats /var/log/httpd-access.log
cat <<"CRONTAB1">> /etc/crontab
### JAMPP // ###
#
0 * * * * /usr/local/bin/webalizer -o /usr/local/www/stats /var/log/httpd-access.log > /var/log/webalizer-hourly
#
### // JAMPP ###
CRONTAB1
   (service cron restart) & spinner $!
fi







### ### ### ### ### ### ### ### ###
# INFO
JAILHOSTNAME=$(hostname -f)
JAILIPS=$(ifconfig | egrep "inet |inet6" | awk '{print $2}' | tr '\n' ' ')
echo ""
echo "MySQL Server Name:       $JAILHOSTNAME"
echo "MySQL Server IPs:        $JAILIPS"
echo "MySQL Server Username:   root"
echo "MySQL Server Password:   jampp"
echo ""
### ### ### ### ### ### ### ### ###
#/ cleanup
### ### ### ### ### ### ### ### ###
echo "" # printf
printf "\033[1;31mjampp installation finished.\033[0m\n"
### ### ### ### ### ### ### ### ###
#
### // stage4 ###
#
### // stage3 ###
#
### // stage2 ###
   ;;
*)
   # error 1
   : # dummy
   : # dummy
   echo "[ERROR] Plattform = unknown"
   exit 1
   ;;
esac
#
### // stage1 ###
;;
'start')
### stage1 // ###
case $OSVERSION in
FreeBSD)
### stage2 // ###
#
### // stage2 ###

### stage3 // ###
if [ "$MYNAME" = "root" ]; then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] You must be root to run this script"
   exit 1
fi
if [ "$JAILED" = "1" ]; then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] Run this script inside an FreeBSD JAIL"
   exit 1
fi
### stage4 // ###
#
### ### ### ### ### ### ### ### ###



### ### ### ### ### ### ### ### ###
#/ cleanup
### ### ### ### ### ### ### ### ###
echo "" # printf
printf "\033[1;31mjampp start finished.\033[0m\n"
### ### ### ### ### ### ### ### ###
#
### // stage4 ###
#
### // stage3 ###
#
### // stage2 ###
   ;;
*)
   # error 1
   : # dummy
   : # dummy
   echo "[ERROR] Plattform = unknown"
   exit 1
   ;;
esac
#
### // stage1 ###
;;
'stop')
### stage1 // ###
case $OSVERSION in
FreeBSD)
### stage2 // ###
#
### // stage2 ###

### stage3 // ###
if [ "$MYNAME" = "root" ]; then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] You must be root to run this script"
   exit 1
fi
if [ "$JAILED" = "1" ]; then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] Run this script inside an FreeBSD JAIL"
   exit 1
fi
### stage4 // ###
#
### ### ### ### ### ### ### ### ###



### ### ### ### ### ### ### ### ###
#/ cleanup
### ### ### ### ### ### ### ### ###
echo "" # printf
printf "\033[1;31mjampp stop finished.\033[0m\n"
### ### ### ### ### ### ### ### ###
#
### // stage4 ###
#
### // stage3 ###
#
### // stage2 ###
   ;;
*)
   # error 1
   : # dummy
   : # dummy
   echo "[ERROR] Plattform = unknown"
   exit 1
   ;;
esac
#
### // stage1 ###
;;
'uninstall')
### stage1 // ###
case $OSVERSION in
FreeBSD)
### stage2 // ###
#
### // stage2 ###

### stage3 // ###
if [ "$MYNAME" = "root" ]; then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] You must be root to run this script"
   exit 1
fi
if [ "$JAILED" = "1" ]; then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] Run this script inside an FreeBSD JAIL"
   exit 1
fi
### stage4 // ###
#
### ### ### ### ### ### ### ### ###



### ### ### ### ### ### ### ### ###
#/ cleanup
### ### ### ### ### ### ### ### ###
echo "" # printf
printf "\033[1;31mjampp uninstallation finished.\033[0m\n"
### ### ### ### ### ### ### ### ###
#
### // stage4 ###
#
### // stage3 ###
#
### // stage2 ###
   ;;
*)
   # error 1
   : # dummy
   : # dummy
   echo "[ERROR] Plattform = unknown"
   exit 1
   ;;
esac
#
### // stage1 ###
;;
*)
printf "\033[1;31mWARNING: jampp is experimental and its not ready for production. Do it at your own risk.\033[0m\n"
echo "" # usage
echo "usage: $0 { install | start | stop | uninstall }"
;;
esac
exit 0
### ### ### PLITC ### ### ###
# EOF
