# !/bin/bash
# Script auto create trial user SSH
# yg akan expired setelah 1 hari

IP=`curl icanhazip.com`

Login=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
hari="1"
Pass=`</dev/urandom tr -dc a-f0-9 | head -c9`

useradd -e `date -d "$hari days" +"%Y-%m-%d"` -s /bin/false -M $Login
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "====Trial SSH Account===="
echo -e "Host              : $IP" 
echo -e "Port OpenSSH      : 22,143"
echo -e "Port Dropbear     : 456,109"
echo -e "Port SSL/TLS      : 443"
echo -e "Port Squid        : 80,3128,8080"
echo -e "OpenVPN (TCP 1194): http://$IP:81/client-tcp-1194.ovpn"
echo -e "Username          : $Login"
echo -e "Password          : $Pass\n"
echo -e "========================="
echo -e "Febrian Dani Ritonga"
echo -e ""
