##set up eth0 eth1 ra0
insmod /lib/modules/rt2880_iNIC.ko
ifconfig ra0 0.0.0.0
ifconfig eth0 0.0.0.0
ifconfig eth0 mtu 1400
brctl addbr br0
brctl addif br0 eth0
brctl addif br0 ra0
ifconfig br0 192.168.6.1
ifconfig eth1 192.168.4.3

##route table setup
route add -net default gw 192.168.4.4                                                      
echo 1 > /proc/sys/net/ipv4/ip_forward

## fast_net status  0:off 1:on  3:bridge 17:nat 19:nat+bridge 64:vpn 83:vpn+nat+bridge
echo 83 > /proc/sys/net/ipv4/storlink_fast_net

# echo 1 > /proc/sys/net/ipv4/storlink_hw_vpn

##NAT setup                                          
/sbin/iptables -F -t nat
/sbin/iptables -X -t nat
/sbin/iptables -Z -t nat
/sbin/iptables -t nat -P PREROUTING  ACCEPT
/sbin/iptables -t nat -P POSTROUTING ACCEPT
/sbin/iptables -t nat -P OUTPUT      ACCEPT
/sbin/iptables -t nat -A POSTROUTING -o eth1 -s 192.168.6.0/24 -j MASQUERADE
#ipsec-accelerate
echo 1 > /proc/sys/net/ipv4/storlink_napi 
echo "1 0 3232237056 4294967040 3232237057 3232236800 4294967040 3232236547 3232236548 1 1 3232236800 4294967040 3232236801 3232237056 4294967040 3232236548 3232236547" > /proc/sys/net/vpn/vpn_pair                                      

###racoon2###
/usr/local/racoon2/sbin/spmd -f /usr/local/racoon2/etc/racoon2/racoon2.conf     
/usr/local/racoon2/sbin/iked -f /usr/local/racoon2/etc/racoon2/racoon2.conf

###racoon1###
#chmod 600 /etc/racoon/psk.txt
#/etc/racoon/setkey.sh
#sleep 1
#racoon -f /etc/racoon/racoon.conf -ddd
