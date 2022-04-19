#!/bin/bash

used_memory=$(vmstat -s -SM | grep -h "used memory" | awk '{print $1}')
total_memory=$(vmstat -s -SM | grep -h "total memory" | awk '{print $1}')
mem_usage=$(echo "($(bc <<< "scale=2; ($used_memory*100/$total_memory)")%)")
total_disk=$(df -h --total | grep -h "total" | awk '{print $2}')
used_disk=$(df -h --total | grep -h "total" | awk '{print $3}')
disk_usage=$(df -h --total | grep -h "total" | awk '{print $5}')
ip=$(ip addr show | grep -v "127.0.0.1" | grep -v "inet6" | grep -h "inet" | awk '{print $2}' | awk -F/ '{print $1}')
mac=$(ip addr show | grep -h "link/ether" | awk '{print $2}')

wall -n "	#Architecture: $(uname -a)
			#CPU physical: $(nproc --all)
			#vCPU: $(grep processor /proc/cpuinfo | wc -l)
			#Memory Usage: $(echo $used_memory)/$(echo $total_memory)MB $mem_usage
			#Disk Usage: $(echo $used_disk)b/$(echo $total_disk)b ($(echo $disk_usage))
			#CPU load: $(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')
			#Last boot: $(who -b | awk '{print $3,$4}')
			#LVM use: $(if [[ $(vgs | wc -l) > 1 ]]; then echo "yes"; else echo "no"; fi)
			#Connexions TCP: $(ss -lo | grep -h "ESTAB" | wc -l) ESTABLISHED
			#User log: $(who | wc -l)
			#Network: IP $ip ($mac)
			#Sudo: $(grep "COMMAND" /var/log/sudo/sudo | wc -l) cmd

"
