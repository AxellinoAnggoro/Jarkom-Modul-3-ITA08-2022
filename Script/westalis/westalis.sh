echo nameserver 192.168.122.1 > /etc/resolv.conf

apt-get update -y
apt-get install isc-dhcp-server -y

echo "
# Defaults for isc-dhcp-server initscript
# sourced by /etc/init.d/isc-dhcp-server
# installed at /etc/default/isc-dhcp-server by the maintainer scripts

#
# This is a POSIX shell fragment
#

# Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf).
#DHCPD_CONF=/etc/dhcp/dhcpd.conf

# Path to dhcpd's PID file (default: /var/run/dhcpd.pid).
#DHCPD_PID=/var/run/dhcpd.pid

# Additional options to start dhcpd with.
#       Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
#OPTIONS=""

# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#       Separate multiple interfaces with spaces, e.g. \"eth0 eth1\".
INTERFACES=\"eth0\"

"> /etc/default/isc-dhcp-server

echo "
ddns-update-style none;
 
option domain-name \"example.org\";
option domain-name-servers ns1.example.org, ns2.example.org;
 
default-lease-time 600;
max-lease-time 7200;
    
log-facility local7;
subnet 192.213.2.0 netmask 255.255.255.0 {

}

subnet 192.213.1.0 netmask 255.255.255.0 {
    range 192.213.1.50 192.213.1.88;
	range 192.213.1.120 192.213.1.155;
    option routers 192.213.1.1;
    option broadcast-address 192.213.1.255;
    option domain-name-servers 192.213.2.2;
    default-lease-time 360;
    max-lease-time 7200;
}

subnet 192.213.3.0 netmask 255.255.255.0 {
    range 192.213.3.10 192.213.3.30;
	range 192.213.3.60 192.213.3.85;
    option routers 192.213.3.1;
    option broadcast-address 192.213.3.255;
    option domain-name-servers 192.213.2.2;
    default-lease-time 360;
    max-lease-time 7200;
}

" >> /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart