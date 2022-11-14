echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update -y
apt-get install bind9 -y
apt-get install apache2 -y

echo "
zone \"loid-work.com\" {
        type master;
        file \"/etc/bind/wise/loid-work.com\";
};

zone \"franky-work.com\" {
        type master;
        file \"/etc/bind/wise/franky-work.com\";
};
"> /etc/bind/named.conf.local

echo "
options {
    directory \"/var/cache/bind\";
 
    forwarders {
            192.168.122.1;
    };
 
    allow-query { any; };
 
    auth-nxdomain no;    # conform to RFC1035
    listen-on-v6 { any; };
};
"> /etc/bind/named.conf.options

mkdir -p /etc/bind/wise

echo "
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     loid-work.com. root.loid-work.com. (
                        2022102501      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@               IN      NS      loid-work.com.
@               IN      A       192.213.2.2 ;IP Wise

"> /etc/bind/wise/loid-work.com

echo "
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     franky-work.com. root.franky-work.com. (
                        2022102501      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@               IN      NS      franky-work.com.
@               IN      A       192.213.2.2 ;IP Wise

"> /etc/bind/wise/franky-work.com

echo "
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        ServerName loid-work.com
 
        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
"> /etc/apache2/sites-available/loid-work.com.conf

echo "
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        ServerName franky-work.com
 
        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
"> /etc/apache2/sites-available/franky-work.com.conf

service apache2 start
a2ensite loid-work.com.conf
a2ensite franky-work.com.conf
service apache2 restart
service bind9 restart

