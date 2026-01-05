#!/bin/bash


# Reading the manual is always better than copying from someone you don't even know and trust, always test everything!!
# Always take everything with a grain of salt, this is just my research and how I applied it
# If you do copy regardless, just make sure you know what is this script about, paste it on chatgpt, read it yourself...
# Just make sure you have a free unguilty conscience and always, always defend your work if you feel like its right!
# (and be thoughtful of the other person of course)


# ~ARCHITECTURE~
architecture=$(uname -a)
# uname (unix name) shows system info! -a or --all print everything about itself (kernel, OS...)

# ~PHYSICAL CPU~
p_cpu=$(grep "physical id" /proc/cpuinfo | wc -l)
	# the grep command finds every thing in the "" 
	# in this case we want to find the "physical id" in /proc/cpuinfo
	# each entry from "physical id" in /proc/cpuinfo is a new cpu (usually just one... unless NASA bought you an alien pc and installed debian on it)
	# wc -l counts "how many lines" it has

# ~VIRTUAL CPU (CORES)~
v_cpu=$(grep "processor" /proc/cpuinfo | wc -l)
	# we do the same for the virtual cpu
	# each entry this time represents how many cores and threads the cpu has

# ~RAM~
ram_total=$(free --mega | awk '$1 == "Mem:" {print $2}')
ram_use=$(free --mega | awk '$1 == "Mem:" {print $3}')
ram_percent=$(free --mega | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
	# the "free" command shows us the memory usage, -m or --mega shows it in MB
	# awk (we will use it quite a lot...) will "grab" the first column it finds of "Mem:" with the $1
	# we do it more times for $3 (used ram) and $2 (total ram)
	# we calculate the percentage of both by dividing both $3/$2 * 100 to get a percentage
	# and then we use printf to limit the output to 2 decimals

# ~DISK~
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf ("%.1fGb\n"), disk_t/1024}')
disk_use=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} END {print disk_u}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_t+= $2} END {printf("%d"), disk_u/disk_t*100}')
	# the "df" command shows us the disk usage, -m or --mega shows it in MB (again)
	# grep "/dev/" shows us only the real disks only and skips the /boot partition by doing grep -v (it excludes things)
	# awk adds all disk sizes together and converts them from MB to GB
	# them we sum the USED disk space across all partitions (in MB)
	# finally we calculate the disk usage %, doing the same "used/total *100" and rounds to a whole number

# ~CPU LOAD~
cpu_load=$(vmstat 1 2 | tail -1 | awk '{printf $15}')
cpu_operation=$(expr 100 - $cpu_load)
cpu_final=$(printf "%.1f" $cpu_operation)
	# the "vmstat" command checks the cpu usage, 1 2 tells to refresh it every second, twice
	# the "tail" command gets always the last result 
	# awk grabs the "idle" percentage on column 15 ($15)
	# then we subtract the idle cpu from 100 to get the actual usage...
	# finally we format the usage to have 1 decimal place in front

# LAST BOOT
last_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')
	# the "who -b" command shows us the last system boot time
	# awk grabs the date and time

# ~LVM USE~
lvm_use=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)
	# //if you do the bonus, this should say "yes"
	# the "lsblk" command shows us "block devices"
	# and we check for lvm volumes by using grep
	# if the count is higher than zero, then lvms are being used!

# ~TCP CONNECTIONS~
tcp_connect=$(ss -ta | grep ESTAB | wc -l)
	# the "ss" command shows us the "socket statistics"
	# and the "-t -a" flags are for TCP and ALL connections
	# we then look for established connections with grep
	# wc -l counts them

# ~USER LOG~
user_log=$(users | wc -w)
	# the "user" command shows us how many users are logged in on the same machine
	# wc -l just counts, again...

# ~NETWORK~
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')
	# the "hostname -I" (-I for IP) prints all assigned IP addresses 
	# the "ip link" command shows us the network interfaces 
	# grep looks for MAC addresses in link/ether
	# awk prints the MAC address

# ~SUDO USAGE~
cmnd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
	# the "journalctl" command reads system logs
	# the "_COMM=sudo" filters sudo commands
	# grep this time keeps only the executed commands of sudo
	# wc -l counts how many times sudo was used

# ~WALL~
wall "	Architecture: $architecture
	Phyiscal CPU: $p_cpu
	Virtual CPU : $v_cpu
	Memory Usage: $ram_use/${ram_total}MB ($ram_percent%)
	Disk Usage  : $disk_use/${disk_total} ($disk_percent%)
	CPU load    : $cpu_final%
	Last boot   : $last_boot
	LVM use     : $lvm_use
	TCP Connect : $tcp_connect ESTABLISHED
	User log    : $user_log
	Network     : IP $ip ($mac)
	Sudo        : $cmnd cmd"
		# the wall is what it should be printed in the end, there's also one in the subject as "followable example"
		# yeah thats about it! go make great things