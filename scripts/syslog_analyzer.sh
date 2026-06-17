#!/bin/bash
echo -e "\e[1m************* SYSLOG FINDINGS *************\e[0m"
echo -e "[+] Log file : $(realpath "$1")"
wc -l "$1" | awk '{print "Total Log Entries : " $1}'
echo -n "Unique Services : "
awk '{print $5}' "$1" | awk -F ':' '{print $1}' | awk -F '[' '{print $1}' | grep -v '^$' | sort -u | wc -l

echo "-------------- ERROR ANALYSIS -------------"
grep -c "ERROR" "$1" | awk '{print "Total Errors : " $1}'

echo "Top Error Sources  "

grep "ERROR" "$1" | awk '{print $5}' | awk -F':' '{print $1}' | awk -F'[' '{print $1}' | sort | uniq -c | sort -nr | awk '{print $2 " : " $1}'
echo "-------------- WARNING ANALYSIS -----------"
grep -c "WARNING" "$1" | awk '{print "Total Errors : " $1}'
echo "Top Warning Sources  "
grep "WARNING" "$1" | awk '{print $5}' | awk -F':' '{print $1}' | awk -F'[' '{print $1}' | sort | uniq -c | sort -nr | awk '{print $2 " : " $1}'

echo "--------- Failed Service Analysis ---------"
echo -n "Total Failed Services : "
grep -i "failed to start" "$1" | awk '{print $9}' | sort -u | wc -l
echo "Failed services "
grep -i "failed to start" "$1" | awk '{print " " $9}' | sort -u

echo "--------- System Reboot Events ------------"

grep -c "System reboot initiated" "$1" | awk '{print "Total Reboots : " $1 }'
echo "Recent Reoot events"
grep "System reboot initiated" "$1" |  awk '{print $1 " " $2 " " $3}'

echo "-------------- KERNEL Events --------------"
grep -c "kernel" "$1" |awk '{print "Kernel messages : " $1}'
echo "Critical Kernel Events:"
echo "Out of memory             : $(grep -c 'Out of memory' "$1")"
echo "Disk I/O errors           : $(($(grep -c 'Disk I/O error' "$1") + $(grep -c 'Disk read failure' "$1")))"
echo "CPU warnings              : $(grep -c 'CPU temperature exceeds threshold' "$1")"
echo "High memory usage         : $(grep -c 'High memory usage' "$1")"
echo "Network resets            : $(grep -c 'Network interface eth0 reset' "$1")"
echo "Boot events               : $(grep -c 'Linux version' "$1")"

echo "==============================================
Report Generated : $(pwd)/reports/syslog_report.txt
Report generated on: $(date)
=============================================="