Welcome to the GHSploit User Guide.
First of all, we want to thank you for choosing the GHSploit utility. 
We sincerely hope that GHSploit will make some of your penetration testing tasks easier and help you understand some things if you have any doubts or misunderstandings about how they work.

Let's start in order.
GHSploit is a free, open source utility written in bash.
You can use it to automate many tasks related to penetration testing and vulnerability analysis.
GHSploit uses tools such as :
1. Metasploit Framework - for creating payloads
2. nmap - for scanning hosts and sites for vulnerabilities and open ports
3. sqlmap - to scan for sql injections.
4. whois - for general host information gathering
5. hydra - for brute force attack on ssh/ftp services
6. hashcat - for brute force password brute for wifi handshake
7. wpscan - to analyze sites that use Wordpress
8. joomscan - to analyze sites using Joomla
9. nikto - general host analysis for some vulnerabilities
10. dirb - to quickly enumerate directories
11. gobuster - for advanced directory enumeration

In the future, other tools will be added, including our own developments.
Root privileges are required for GHSploit to work correctly. This is needed to install missing components and also for some nmap scans which use so-called "system fingerprints", which cannot be used without root privileges given the best intentions (even using fakeroot).
But since all other utilities do not require root privileges, it would be silly to deprive them because of such a small thing. For this reason, a nonroot mode was created which allows you to run GHSploit even without root access but with somewhat limited functionality.
Examples of running :
./GHSploit.sh : is the standard way to run the utility. Requires root access. It asks a few questions about whether to upgrade the system and install dependencies and shows how they are installed(or not). After that, it goes to the main menu

./GHSploit.sh -f : quick start, requires root access. Does not show messages from normal startup, does not install dependencies. An optimal way to start if all utilities are installed.

./GHSploit.sh -fi :the same quick start, but only with the installation of dependencies. No system update.

./GHSploit.sh --nonroot : Runs the utility without root privileges. No dependency installation, no system upgrade.

./GHSploit.sh -h or --help : Display the help banner.

--------------------------------------
Main requiements
--------------------------------------
1. Linux system with GUI like Kali, Parrot, Backbox, Debian, Ubuntu(not Windows bash terminal emulator, may be a lot of errors!)
2. Bash terminal
3. XTerm terminal
4. APT packet manager
5. Sudo 

The system utility APT is used to install updates and programs, and xterm is used to run the utilities separately, so a Linux GUI is needed for proper operation.
GHSploit has been tested on Ubuntu, Debian, Kali Linux, Parrot OS, BackBox Linux and works fine on those systems, but we would be absolutely grateful if you would let us know if there are any bugs.
As for starting in Termux, you need a graphical desktop emulation. You can read more about this here : https://wiki.termux.com/wiki/Graphical_Environment
The interface of the program is intuitive, the internal control is based on the numbers and letters indicated on the screen as possible input options.
Inside the program there is some documentation on the utilities used and answers to frequently asked questions.
Also, there is a function to show system information (amount of RAM, system name, processor model, etc.), but on some systems may not be displayed accurately. 

Docker version will be created soon..