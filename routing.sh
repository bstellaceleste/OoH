iptables --flush
iptables -t nat --flush
iptables -A FORWARD -o $1 -i xenbr0 -s 10.0.0.0/8 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A POSTROUTING -o $1 -j MASQUERADE
echo 1 > /proc/sys/net/ipv4/ip_forward
