#!/bin/bash
echo "This is not a bash script"
exit 1

# All syntax examples

# List
iptables -vnL
iptables -t nat -vnL

# Flush
iptables -F INPUT

# Basic Rules
iptables -t filter -A INPUT -s 192.168.0.20 -p icmp -j DROP
iptables -t filter -A INPUT -p tcp --dport 25 -j DROP
iptables -t filter -A INPUT -p udp --dport 69 -j DROP
iptables -t filter -A OUTPUT -d www.badsite.com -p tcp --dport 80 -j DROP

iptables -A INPUT -s 192.168.1.0/24 -j DROP
iptables -A OUTPUT -d 10.0.0.0/16 -j DROP

iptables -A INPUT -m iprange --src-range 10.0.0.10-10.0.0.33 -p tcp --dport 25 -j DROP
iptables -A INPUT -m addrtype --src-type BROADCAST -j DROP
iptables -A OUTPUT -p tcp -m multiport --dport 80,443 -j ACCEPT

iptables -A INPUT -i wlan0 -j ACCEPT
iptables -A OUTPUT -o enp0s3 -j ACCEPT

iptables -A INPUT -p tcp --dport 80 --syn -j DROP

iptables -A OUTPUT -p udp --dport 53 ! -d 8.8.8.8 -j DROP

# Advanced Rules
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A OUTPUT -m state --state INVALID -j DROP
iptables -A INPUT -p tcp --dport 22 --syn -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -i wlan0 -m mac --mac-source 08:00:27:56:6f:20 -j DROP

iptables -A FORWARD -p tcp --dport 80 -d www.google.com -m time --timestart 18:00 --timestop 8:00 -j ACCEPT # Time is in UTC

iptables -A INPUT -p tcp --dport 25 --syn -m connlimit --connlimit-above 5 -j REJECT --reject-with tcp-rst # match if the number of existing connections is more than 5, reject with reset

iptables -A FORWARD -m limit --limit 1/minute -p tcp --dport 53 -j LOG # default burst 5, after 5 matches (burst)
iptables -A INPUT -p tcp --syn -m limit 1/second --limit-burst 7 -j ACCEPT

iptables -A INPUT -p icmp --icmp-type 8 -m limit --limit 1/second --limit-burst 7 -j ACCEPT # after 7 matches (burst), limit 1 connection per second
iptables -A INPUT -p icmp --icmp-type 8 -j DROP

iptables -A FORWARD -m recent --name badguy --update --seconds 60 -j DROP # keep the badguy for 60 seconds, whenever it hits, refreshes the timer, after 60 sec, remove it from the blacklist
iptables -A FORWARD -p tcp -i eth0 --dport 8080 -m recent --name badguy --set -j DROP # once packet hits tcp 8080 on eth0, add it to a blacklist (badguy)

iptables -A OUTPUT -d 10.0.0.1 -p tcp --dport 80 -m quota --quota 1000000000 -j ACCEPT # max 1GB allow
iptables -A OUTPUT -d 10.0.0.1 -p tcp --dport 80 -j DROP # then drop

iptables -t mangle -A FORWARD -o eth0 -j TTL --ttl-set 1 # avoid loop
iptables -t mangle -A OUTPUT -p tcp -j TOS --set-tos 0x10 # 0x10 : minimize delay, 0x08 : maximize throughput

iptables -A INPUT -m geoip --src-cc IN -j DROP

iptables -I FORWARD -p udp --dport 69 -j REJECT --reject-with icmp-port-unreachable
iptables -A INPUT -p tcp --dport 22 --syn -j LOG --log-prefix="incoming.ssh:" --log-level info

iptables -A FORWARD -i eth0 -o eth1 -p tcp -d 10.0.0.1 -j TEE --gateway 10.0.0.10 # TEE : clone (port mirroring)
iptables -A INPUT -p icmp --icmp-type 8 -j TEE --gateway 192.168.0.20 # icmp-type 8 : echo request, 0 : echo reply

iptables -t nat -A PREROUTING -p tcp --dport 1234 -j REDIRECT --to-ports 22 # transport-proxying
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080

# NAT and Port Forwarding
iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j SNAT --to-source 100.0.0.1 # static public ip
iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE # dynamic public ip

iptables -t nat -A PREROUTING -p tcp --dport 80 -d 100.0.0.1 -j DNAT --to-destination 10.0.0.2
iptables -t nat -A PREROUTING -p tcp --dport 8080 -d 100.0.0.1 -j DNAT --to-destination 10.0.0.2:80

# Default policy
iptables -P INPUT DROP
iptables -P OUTPUT DROP

# Delete the firewall
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

iptables -t filter -F
iptables -t nat -F
iptables -t mangle -F

iptables -X # delete any user defined chains

# Dump & Restore
iptables-save # dump rules to stdout or a file
iptables-restore # load from a file