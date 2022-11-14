echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install lynx -y
apt install speedtest-cli -y


# export PYTHONHTTPSVERIFY=0
# export http_proxy="http://192.213.2.3:8080"
# env | grep -i proxy