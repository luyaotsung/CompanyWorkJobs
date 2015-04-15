#!/bin/bash

Server_IP="192.168.77.1"
Login_ID="root"
Login_PW="Danggie@MiS"
VPNC_CMD_1="vpnc /tmp/etc/vpnc/vpn.conf"
VPNC_CMD_2="iptables -A FORWARD -o tun0 -j ACCEPT"
VPNC_CMD_3="iptables -A FORWARD -i tun0 -j ACCEPT"
VPNC_CMD_4="iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE"
VPNC_Disconnect_CMD="vpnc-disconnect"
Check_Status_CMD="ls /var/run/vpnc"


Start_CN_VPN()
{
	echo ""
	echo "*** Start CN VPN Begin *** "
	echo "*** please waiting *** "
	( echo open ${Server_IP}
	sleep 1
	echo ${Login_ID}
	sleep 1 
	echo ${Login_PW}
	sleep 1
	echo ${VPNC_CMD_1}
	sleep 3 
	echo ${VPNC_CMD_2}
	sleep 1
	echo ${VPNC_CMD_3}
	sleep 1
	echo ${VPNC_CMD_4}
	sleep 1
	echo quit ) | telnet > /tmp/CN_VPN_Start.log 2>&1 
	
	echo ""
	echo "*** Start CN VPN Finish *** "
	echo ""
}


Stop_CN_VPN()
{
	echo ""
	echo "*** Stop CN VPN Begin *** "
	echo "*** Please waiting ***"
	( echo open ${Server_IP}
	sleep 1
	echo ${Login_ID}
	sleep 1 
	echo ${Login_PW}
	sleep 1
	echo ${VPNC_Disconnect_CMD}
	sleep 1
	echo quit ) | telnet > /tmp/CN_VPN_Stop.log 2>&1 
	
	echo ""
	echo "*** Stop CN VPN Finish *** "
	echo ""

}


VPN_Status()
{

	( echo open ${Server_IP}
	sleep 1
	echo ${Login_ID}
	sleep 1 
	echo ${Login_PW}
	sleep 1
	echo ${Check_Status_CMD}
	sleep 1
	echo 
	echo quit ) | telnet > /tmp/CN_VPN_status.log 2>&1 
	
	result=`grep pid /tmp/CN_VPN_status.log | cut -d " " -f 1`
	if [ "$result" == "defaultroute" ]
	then 
		echo "VPN Service is running"
	else 
		echo "VPN Service is not running"
	fi  	

}

help_dump()
{
	echo "VPN_CMD.sh start/stop/restart/status"
}


case $1 in 
	start) 	Start_CN_VPN
		exit
		;;
	stop) 	Stop_CN_VPN
		exit
		;;
	status)	VPN_Status 
		exit
		;;
	restart) Stop_CN_VPN
		Start_CN_VPN
		exit
		;;
	*) help_dump
		exit
		;;
esac
			
