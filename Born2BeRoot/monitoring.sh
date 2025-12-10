#!/bin/bash

# ARCHITECTURE
architecture=$(uname -a)

# PHYSICAL CPU
p_cpu=$(grep "physical id" /proc/cpuinfo | wc -l)

# VIRTUAL CPU (CORES)
v_cpu=$(grep "processor" /proc/cpuinfo | wc -l)

# RAM
ram_total=$(free --mega | awk '$1 == "Mem:" {print $2}')
ram_use=$(free --mega | awk '$1 == "Mem:" {print $3}')
ram_percent=$(free --mega | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

# DISK
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf ("%.1fGb\n"), disk_t/1024}')
disk_use=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} END {print disk_u}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_t+= $2} END {printf("%d"), disk_u/disk_t*100}')

# CPU LOAD
cpu_load=$(vmstat 1 2 | tail -1 | awk '{printf $15}')
cpu_operation=$(expr 100 - $cpu_load)
cpu_final=$(printf "%.1f" $cpu_operation)

# LAST BOOT
last_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# LVM USE
lvm_use=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

# TCP CONNECTIONS
tcp_connect=$(ss -ta | grep ESTAB | wc -l)

# USER LOG
user_log=$(users | wc -w)

# NETWORK
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# SUDO USAGE
cmnd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "	Architecture: $
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