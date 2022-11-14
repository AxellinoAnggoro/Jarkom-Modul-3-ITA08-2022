echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install squid -y

echo "
include /etc/squid/acl-time.conf
include /etc/squid/acl-bandwidth.conf
include /etc/squid/acl-port.conf

http_port 8080
dns_nameservers 192.213.2.2
 
acl WORK_HOUR_SITES dstdomain \"/etc/squid/working-hour-sites.acl\"
 
http_access allow WORK_HOUR_SITES WORK_HOUR
http_access deny !HTTPS_PORT
http_access deny CONNECT !HTTPS_PORT
http_access allow !WORK_HOUR
http_access deny all
 
visible_hostname Berlint
"> /etc/squid/squid.conf

echo "
acl WORK_HOUR time MTWHF 08:00-16:59
acl WEEK_END time SA 00:00-23:59
"> /etc/squid/acl-time.conf

echo "
loid-work.com
franky-work.com
"> /etc/squid/working-hour-sites.acl

echo "
delay_pools 1
delay_class 1 1
delay_access 1 allow WEEK_END
delay_parameters 1 16000/16000
"> /etc/squid/acl-bandwidth.conf

echo "
acl HTTPS_PORT port 443
acl CONNECT method CONNECT
"> /etc/squid/acl-port.conf

service squid restart
