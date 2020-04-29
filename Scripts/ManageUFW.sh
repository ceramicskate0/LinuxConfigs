#!/bin/bash
#-[Privilege Check Section]-
if [ $(id -u) -ne '0' ]; then
   echo
    echo ' [ERROR]: This Setup Script Requires root privileges!'
   echo '          Please run this setup script again with sudo or run as login as root.'
   exit 1
fi

func_SetupBaselineForFW() {
   if ! command -v ufw > /dev/null 2>&1; then
      apt-get install ufw
	  systemctl enable ufw
   fi
   read -r -p "Setup IP to Allow SSH FROM?[y/n]" response
      case "$response" in
    [yY][eE][sS]|[yY])
       echo "What is your STATIC Public IP for SSH?"
       read publicIP
	   ufw allow from $publicIP to any port 22
       ;;
    *) read -r -p "Setup IP to Allow SSH from ANY/EVERYWHERE/ALL?[y/n]" response
      case "$response" in
      [yY][eE][sS]|[yY])
	   ufw allow in 22/tcp
	  ;;
     esac
	esac
	  ufw default deny incoming
    ufw default deny outgoing
	  ufw default deny forward
    echo "[NOTE] If script hangs hit spacebar"
    ufw enable
    while true
    do
    echo ""
    echo "-------------"
    echo "- Firewall Config Menu -"
    echo "-------------"
    echo ""
    echo "-------------"
    echo "- Firewall Rules -"
    echo "-------------"
    echo ""
    ufw status numbered
    echo ""
    echo ""
    echo "======================================================================"
    echo "[*] Select option to start setup for UFW Firewall on Local host[*]"
    echo "======================================================================"
    echo "Enter 0 Write DEFAULT RULES:"
    echo "Enter 1 Allow INBOUND to Port (incoming):"
    echo "Enter 2 Allow OUTBOUD to Port (outgoing):"
    echo "Enter 3 DROP PING Requests (incoming):"
    echo "Enter 4 Allow IP INBOUND to DEST PORT (incoming):"
    echo "Enter 5 Allow OUTGOING from this machine to an IP (outgoing):"
    echo "Enter 6 Custom UFW (ie ufw + 'your command in bash'):"
    echo "Enter 7 DELETE UFW FW by rule num:"
    echo "Enter 8 Reset UFW (FW):"
  	echo "Enter 9 START/STOP UFW"
    echo "Enter 99 to exit script"
    echo "Please enter your selection: "
    echo ""
    read answer
    case "$answer" in
    0) echo "What is your STATIC Public IP for SSH?"
	   read publicIP
	     ufw allow from $publicIP to any port 22
       ufw allow out 123
       ufw allow out 53
       ufw allow out 80
       ufw allow out 443
	     ufw allow from 127.0.0.1  
       ufw default deny incoming
       ufw default deny outgoing
	     ufw default deny forward
       echo "[*] - COMPLETE!"
      ;;
    1) echo 'Enter port to open from internet:'
      read port
      echo 'Enter udp or tcp for port type:'
      read TranmissionType
      ufw allow proto $TranmissionType from any to any port $port
      #ufw allow $port/$TranmissionType
      echo "[*] - COMPLETE!"
      ;;
    2) echo 'Enter port to open to internet:'
      read port
      echo 'Enter udp or tcp for port type:'
      read TranmissionType
      ufw allow out $port/$TranmissionType
      #ufw allow $port/$TranmissionType
      echo "[*] - COMPLETE!"
      ;;
    3) echo '-A ufw-before-input -p icmp --icmp-type echo-request -j DROP' >> '/etc/ufw/before.rules'
       echo "[*] - COMPLETE!"
       ;;
    4) echo 'Enter IP to open incoming from:'
      read IP
      echo 'Enter port to allow IP inbound to:'
      read port
      ufw allow from $IP to any port $port
      echo "[*] - COMPLETE!"
      ;;
    5) echo 'Enter IP to allow comms to:'
      read IP
      ufw allow to $IP
      echo "[*] - COMPLETE!"
      ;;
    6)  echo 'Enter custom UFW: UFW '
       read cmd
       ufw + ' '+$cmd
       echo "[*] - COMPLETE!"
       ;;
    7)  ufw status numbered 
       echo 'Enter rule number to remove: '
       read cmd
       ufw delete $cmd
       echo "[*] - COMPLETE!"
       ;;
    8) ufw reset
	     echo "What is your STATIC Public IP for SSH?"
	     read publicIP
	     ufw allow from $publicIP to any port 22
       ufw default deny incoming
       ufw default deny outgoing
	     ufw default deny forward
       ufw enable
       echo "[*] - COMPLETE!"
       ;;    
    99) clear
        exit 0
       ;; 
	  9) clear
     read -r -p "Press 'Y' to START UFW or 'N' to STOP, otherwise hit anything else?[y/n]" response
     case "$response" in
     [yY])
	    ufw enable
	    ;;
	   [nN])
	    ufw disable
      ;;
    esac
    esac
  done
}

func_SetupBaselineForFW
