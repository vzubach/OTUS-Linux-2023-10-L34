#!/bin/sh

apt-get update
apt-get install openvpn easy-rsa selinux-utils -y
setenforce 0
echo "net.ipv4.conf.all.forwarding = 1" >> /etc/sysctl.conf
sysctl -p
cd /etc/openvpn/
/usr/share/easy-rsa/easyrsa init-pki
echo 'rasvpn' | /usr/share/easy-rsa/easyrsa gen-req server nopass
echo 'server' | /usr/share/easy-rsa/easyrsa build-ca nopass
echo 'yes' | /usr/share/easy-rsa/easyrsa sign-req server server
/usr/share/easy-rsa/easyrsa gen-dh
openvpn --genkey secret ca.key
echo 'client' | /usr/share/easy-rsa/easyrsa gen-req client nopass
echo 'yes' | /usr/share/easy-rsa/easyrsa sign-req client client
echo 'iroute 10.10.10.0 255.255.255.0' > /etc/openvpn/client/client
echo 'port 1207 
proto udp 
dev tun 
ca /etc/openvpn/pki/ca.crt 
cert /etc/openvpn/pki/issued/server.crt 
key /etc/openvpn/pki/private/server.key 
dh /etc/openvpn/pki/dh.pem 
server 10.10.10.0 255.255.255.0 
ifconfig-pool-persist ipp.txt 
client-to-client 
client-config-dir /etc/openvpn/client 
keepalive 10 120 
comp-lzo 
persist-key 
persist-tun 
status /var/log/openvpn-status.log 
log /var/log/openvpn.log 
verb 3
' > /etc/openvpn/server.conf
echo '[Unit] 
Description=OpenVPN Tunneling Application On
After=network.target 
[Service] 
Type=notify 
PrivateTmp=true 
ExecStart=/usr/sbin/openvpn --cd /etc/openvpn/ --config server.conf 
[Install] 
WantedBy=multi-user.target
' > /etc/systemd/system/openvpn@.service 
systemctl enable openvpn
systemctl start openvpn
sleep 3
systemctl restart openvpn
ss -lntu
