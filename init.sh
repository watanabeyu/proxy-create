#!/usr/bin/sh

echo "update yum"
yum -y update
yum -y install squid

echo "update /etc/squid/squid.conf"
curl -H 'Cache-Control: no-cache' -L https://raw.githubusercontent.com/watanabeyu/proxy-create/master/squid.conf > /etc/squid/squid.conf

echo "port open"
iptables -A INPUT -p tcp --dport 61088 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 61088 -m state --state ESTABLISHED -j ACCEPT
iptables-save > /etc/sysconfig/iptables

echo "start squid"
systemctl start squid
systemctl enable squid
systemctl status squid.service