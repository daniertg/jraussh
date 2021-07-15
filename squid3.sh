acl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl SSL_ports port 443
acl Safe_ports port 10
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx
acl SSH dst 202.152.240.50
acl SSH dst 10.8.3.8
acl SSH dst 10.4.0.10
acl SSH dst 10.19.19.19
acl SSH dst 10.1.89.130
acl SSH dst 10.17.27.250
acl SSH dst 103.152.118.164
http_access allow SSH
http_access allow manager localhost
http_access allow manager
http_access allow localhost
http_access allow all
http_port 8888
http_port 3128
coredump_dir /var/spool/squid3
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
