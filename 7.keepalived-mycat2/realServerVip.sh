#!/bin/sh

# virtual server ip
VIP=$KEEPALIVED_VIRTUAL_IP
if [ "${VIP}" = "" ]; then
       VIP="172.18.0.211"
fi

# /etc/rc.d/init.d/functions
case "$1" in
start)
       ifconfig lo:0 $VIP broadcast $VIP netmask 255.255.255.255 up
       sleep 3s
       route add -host $VIP dev lo:0
       echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
       echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
       echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
       echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
       sysctl -p >/dev/null 2>&1
       echo "RealServer Start OK"
       ;;
stop)
       ifconfig lo:0 down
       route del $VIP netmask 255.255.255.255 dev lo:0 >/dev/null 2>&1
       echo "0" >/proc/sys/net/ipv4/conf/lo/arp_ignore
       echo "0" >/proc/sys/net/ipv4/conf/lo/arp_announce
       echo "0" >/proc/sys/net/ipv4/conf/all/arp_ignore
       echo "0" >/proc/sys/net/ipv4/conf/all/arp_announce
       echo "RealServer Stoped"
       ;;
restart)
       route del -net $SNS_VIP netmask 255.255.255.255 dev ens160:0:0
       route add ${SNS_VIP}/32 dev ens160:0:0
;;
*)
       echo "Usage: $0 {start|stop|restart}"
       exit 1
esac
exit 0
