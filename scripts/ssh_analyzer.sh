#!/bin/bash

total_ssh_events=$(grep -c "sshd" "$1")
failed_pswd_attempts=$(grep -c "Failed password" "$1")
successfull_logins=$(grep -Ec "Accepted password|Accepted publickey" "$1")
invalid_user_attempts=$(grep -c "Invalid user" "$1")
successfull_login_rt=$(grep -Ec "Accepted password for root|Accepted publickey for root" "$1")
failed_login_rt=$(grep -c "Failed password for root" "$1")

echo -e "\e[1m************* SSH FINDINGS **************\e[0m"
echo -e "[+] Log file : $(realpath "$1")"
echo "Total SSH events : $total_ssh_events"
echo "Failed login attempts : $failed_pswd_attempts"
echo "Successfull logins : $successfull_logins"
echo "Invalid user attempts : $invalid_user_attempts"

echo "-------------- TOP TARGETS --------------"
{
	grep "Failed password" "$1" |
		awk '{
for(i=1;i<=NF;i++){
if($i=="for" && $(i+1)=="invalid" && $(i+2)=="user")
print $(i+3)
else if($i=="for" && $(i+1)!="invalid")
print $(i+1)
}}'
	grep "Invalid user" "$1" |
		awk '{
for(i=1;i<=NF;i++)
if($i=="Invalid" && $(i+1)=="user")
print $(i+2)}'
} | sort | uniq -c | sort -nr | awk '{print $2 " : " $1}'

echo "--------- TOP ATTACKER IPS --------------"
echo -e "IP\t\t| ATTEMPTS"
grep -Ei "invalid user|failed password" "$1" | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' | sort | uniq -c | sort -nr | awk '{print $2 "\t:  " $1}'
echo "--------- Root login attempts -----------"
echo "Successfull attempts : $successfull_login_rt"
echo "Failed attempts : $failed_login_rt"
echo "---------- BRUTE FORCE ALERTS ----------- "
echo -e "$(
	grep "Failed password" "$1" |
		awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' |
		sort | uniq -c | sort -nr |
		awk '{ 
    if ($1 >= 10) 
        print "[!] ALERT: " $2 " (" $1 " failed attempts)"; 
    else 
        print "[?] Suspicious: " $2 " (" $1 " failed attempts)" 
}'
)"
echo "==============================================
Report Generated : $(pwd)/reports/ssh_report.txt
Report generated on: $(date)
=============================================="



# Owner
# Github : ByteBandit-100
