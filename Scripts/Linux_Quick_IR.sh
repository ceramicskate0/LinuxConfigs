#!/bin/bash
#-[Privilege Check Section]-
if [ $(id -u) -ne '0' ]; then
   echo
    echo ' [ERROR]: This Setup Script Requires root privileges!'
   echo '          Please run this setup script again with sudo or run as login as root.'
   exit 1
fi
func_Status_Menu_verbose(){
	clear
	echo "======================================================================"
	echo "[*] Connected Sessions [*]"
	echo "======================================================================"
	netstat -natu | grep 'ESTABLISHED' 
	echo "======================================================================"
    echo "[*] FW Rules [*]"
	echo "======================================================================"
    ufw status numbered
	echo "======================================================================"
	echo "[*] BASH HISTORY (root)[*]"
	echo "======================================================================"
	history 10
    tail -n 10 /root/.bash_history
	echo "======================================================================"
	echo "[*] Apache Access Log (10 most recent logs)[*]"
	echo "======================================================================"
    tail -n 10 /var/log/apache2/access.log
	echo "======================================================================"
	echo "[*] Fail2Ban BANNED Logs (10 most recent)[*]"
	echo "======================================================================"
	tail -n 10 /var/log/fail2ban.log | grep Ban
	echo "======================================================================"
	echo "[*] UFW BLOCKED Logs (10 most recent)[*]"
	echo "======================================================================"
	tail -n 10 /var/log/ufw.log | grep BLOCK
	echo "======================================================================"
	echo "[*] Auth Logs (10 most recent)(/var/log/auth.log)[*]"
	echo "======================================================================"
	tail -n 10 /var/log/auth.log 
	echo "======================================================================"
	func_Main
}

func_Status_Menu_verbose
