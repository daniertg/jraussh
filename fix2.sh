#!/bin/bash
#

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0'`;
MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# set time GMT +7 jakarta
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
/etc/init.d/ssh restart

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

echo "=================  install neofetch  ===================="
echo "========================================================="
# install neofetch
apt-get update -y
apt-get -y install gcc
apt-get -y install make
apt-get -y install cmake
apt-get -y install git
apt-get -y install screen
apt-get -y install unzip
apt-get -y install curl
git clone https://github.com/dylanaraps/neofetch
cd neofetch
make install
make PREFIX=/usr/local install
make PREFIX=/boot/home/config/non-packaged install
make -i install
apt-get -y install neofetch
cd
echo "clear" >> .bashrc
echo "neofetch" >> .bashrc

# instal php5.6 ubuntu 16.04 64bit
apt-get -y update

# set repo webmin
#sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
#wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add -

# setting port ssh
cd
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
/etc/init.d/ssh restart

echo "================  install Dropbear ======================"
echo "========================================================="

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/ssh restart
/etc/init.d/dropbear restart

echo "=================  install Squid3  ======================"
echo "========================================================="

# setting dan install vnstat debian 9 64bit
apt-get -y install vnstat
systemctl start vnstat
systemctl enable vnstat
chkconfig vnstat on
chown -R vnstat:vnstat /var/lib/vnstat

# install squid3
cd
apt-get -y install squid3
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/daniertg/jraussh/main/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf;
service squid restart

echo "=================  saya matikan install Webmin  ======================"
echo "========================================================="

# install webmin
cd
#wget http://prdownloads.sourceforge.net/webadmin/webmin_1.910_all.deb
#dpkg --install webmin_1.910_all.deb;
#apt-get -y -f install;
#sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
#rm -f webmin_1.910_all.deb
#/etc/init.d/webmin restart

echo "=================  install stunnel  ====================="
echo "========================================================="

# install stunnel
apt-get install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 222
connect = 127.0.0.1:143

[dropbear]
accept = 777
connect = 127.0.0.1:109
END

echo "=================  membuat Sertifikat OpenSSL ======================"
echo "========================================================="
#membuat sertifikat
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

# common password debian 
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/daniertg/jraussh/master/password"
chmod +x /etc/pam.d/common-password


echo "=================  Install badVPn (VC and Game) ======================"
echo "========================================================="

# buat directory badvpn

echo "================= Disable badVPN V 1  ======================"
#cd /usr/bin
#mkdir build
#cd /usr/bin/build
#wget https://github.com/idtunnel/sshtunnel/raw/master/debian9/badvpn/badvpn-update.zip
#unzip badvpn-update
#cmake -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_TUN2SOCKS=1 -DBUILD_UDPGW=1
#make install
#make -i install

# aut start badvpn
#sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 > /dev/null &' /etc/rc.local
#screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 > /dev/null &
cd
#cd /usr/bin/build

#sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 > /dev/null &' /etc/rc.local#
#screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 > /dev/null &
#auto badvpn

# set permition rc.local badvpn
#chmod +x /usr/local/bin/badvpn-udpgw
#chmod +x /usr/local/share/man/man7/badvpn.7
#chmod +x /usr/local/bin/badvpn-tun2socks
#chmod +x /usr/local/share/man/man8/badvpn-tun2socks.8
#chmod +x /etc/rc.local
#chmod +x /usr/bin/build


echo "================= Auto Installer Disable badVPN V 2  ======================"
#wget https://raw.githubusercontent.com/daniertg/jraussh/master/badvpn2.sh
#chmod +x badvpn2.sh
#bash badvpn2.sh

echo "================= Auto Installer Disable badVPN V 3  ======================"
# buat directory badvpn
cd /usr/bin
mkdir build
cd build
wget https://github.com/ambrop72/badvpn/archive/1.999.130.tar.gz
tar xvzf 1.999.130.tar.gz
cd badvpn-1.999.130
cmake -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_TUN2SOCKS=1 -DBUILD_UDPGW=1
make install
make -i install

# auto start badvpn single port
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 > /dev/null &' /etc/rc.local
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 > /dev/null &
cd

# auto start badvpn second port
cd /usr/bin/build/badvpn-1.999.130
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 > /dev/null &' /etc/rc.local
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 > /dev/null &
cd

# auto start badvpn second port
cd /usr/bin/build/badvpn-1.999.130
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 > /dev/null &' /etc/rc.local
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 > /dev/null &
cd

# permition
chmod +x /usr/local/bin/badvpn-udpgw
chmod +x /usr/local/share/man/man7/badvpn.7
chmod +x /usr/local/bin/badvpn-tun2socks
chmod +x /usr/local/share/man/man8/badvpn-tun2socks.8
chmod +x /usr/bin/build
chmod +x /etc/rc.local

echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
echo "DROPBEAR_BANNER="/etc/issue.net"" >> /etc/default/dropbear

# install fail2ban
apt-get -y install fail2ban
service fail2ban restart

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# download script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/daniertg/jraussh/master/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/daniertg/jraussh/master/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/daniertg/jraussh/master/trial.sh"
wget -O hapus "https://raw.githubusercontent.com/daniertg/jraussh/master/hapus.sh"
wget -O cek "https://raw.githubusercontent.com/daniertg/jraussh/master/cek.sh"
wget -O member "https://raw.githubusercontent.com/daniertg/jraussh/master/member.sh"
wget -O restart "https://raw.githubusercontent.com/daniertg/jraussh/master/restart.sh"
wget -O speedtest "https://raw.githubusercontent.com/daniertg/jraussh/master/speedtest.sh"
wget -O delete "https://raw.githubusercontent.com/daniertg/jraussh/master/delete.sh"

echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x hapus
chmod +x cek
chmod +x member
chmod +x restart
chmod +x speedtest
chmod +x info
chmod +x delete
cd
# finishing
chown -R www-data:www-data /home/vps/public_html

rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# info
clear
echo "=================================-Autoscript Premium-===========================" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "--------------------------------------------------------------------------------" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - OpenVPN                 : TCP 1194, UDP 2200, SSL 442"  | tee -a log-install.txt
echo "   - Stunnel4                : 443, 777"  | tee -a log-install.txt
echo "   - Dropbear                : 109, 143"  | tee -a log-install.txt
echo "   - Squid Proxy             : 3128, 8080 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Badvpn                  : 7100, 7200, 7300"  | tee -a log-install.txt
echo "   - Nginx                   : 81"  | tee -a log-install.txt
echo "   - Wireguard               : 7070"  | tee -a log-install.txt
echo "   - L2TP/IPSEC VPN          : 1701"  | tee -a log-install.txt
echo "   - PPTP VPN                : 1732"  | tee -a log-install.txt
echo "   - SSTP VPN                : 444"  | tee -a log-install.txt
echo "   - Shadowsocks-R           : 1443-1543"  | tee -a log-install.txt
echo "   - SS-OBFS TLS             : 2443-2543"  | tee -a log-install.txt
echo "   - SS-OBFS HTTP            : 3443-3543"  | tee -a log-install.txt
echo "   - V2RAY Vmess TLS         : 8443"  | tee -a log-install.txt
echo "   - V2RAY Vmess None TLS    : 80"  | tee -a log-install.txt
echo "   - V2RAY Vless TLS         : 2083"  | tee -a log-install.txt
echo "   - V2RAY Vless None TLS    : 8880"  | tee -a log-install.txt
echo "   - Trojan                  : 2087"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
echo "   - Autoreboot On 05.00 GMT +7" | tee -a log-install.txt
echo "   - Autobackup Data" | tee -a log-install.txt
echo "   - Restore Data" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo "   - White Label" | tee -a log-install.txt
echo "   - Installation Log --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "------------------Script Created By Febrian Dani Ritonga-----------------" | tee -a log-install.txt
echo ""
cd

rm -f /root/openssh.sh



echo "================  install OPENVPN  saya disable======================"
echo "========================================================="
# install openvpn debian 9 ( openvpn port 1194 dan 443 )
wget https://raw.githubusercontent.com/daniertg/jraussh/master/openvpn.sh && chmod +x openvpn.sh && bash openvpn.sh

echo "==================== Restart Service ===================="
echo "========================================================="
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/stunnel4 restart
/etc/init.d/squid restart
/etc/init.d/nginx restart
/etc/init.d/php5.6-fpm restart
/etc/init.d/openvpn restart

# Delete script
rm -f /root/fix2.sh
