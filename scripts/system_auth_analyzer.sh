#!/bin/bash

echo -e "\e[1m********* SYSTEM AUTH FINDINGS *********\e[0m"
echo -e "Log file : $(realpath "$1")"
grep -ic "sudo:.*COMMAND=" "$1" | awk '{print "sudo usage events : " $1}'
grep -ic "su:" "$1" | awk '{print "su usage events : " $1}'
grep -ic "cron" "$1" | awk '{print "CRON usage events : " $1}'
grep -ic "pam_unix" "$1" | awk '{print "PAM session events : " $1}'
echo "----------- SUDO activities ------------"
grep "sudo:.*COMMAND=" "$1" | awk '{print $6}' | sort | uniq -c | sort -nr | awk '{print $2 " : " $1}'
echo "------------ SU activities -------------"
grep -c "su: pam_unix(su:session): session opened" "$1" | awk '{print "Successfull su sessions : " $1}'
grep "su:.*session opened" "$1" | awk -F'by ' '{print $2}' | awk -F'\\(' '{print $1}' | sort | uniq -c | sort -nr | awk '{print $2 " : " $1}'
echo "-------- *Authentication errors -------- "
grep -c "su: FAILED SU" "$1" | awk '{print "Failed SU attempts : " $1}'
grep -Ec "sudo:.*incorrect password attempts|sudo: pam_unix\(sudo:auth\): authentication failure" "$1" | awk '{print "Failed SUDO attempts : " $1}'
echo "--------- User mgmt activities ---------"
grep -c "new user:" "$1" | awk '{print "[+] User Added : " $1}'
grep -c "userdel\[.*delete user" "$1" | awk '{print "[+] User Deleted : " $1}'
grep -c "passwd\[.*password changed" "$1" | awk '{print "[+] Password changed : " $1}'
echo "----------- CRON activities ------------"
grep "CRON.*CMD" ./logs/auth.log | awk -F '[()]' '{print $2}' | sort | uniq -c | sort -nr | awk '{print $2" : " $1}'
echo -e "\n- Most Authenticated users[SSH/SUDO/SU] -" 
{
    grep -E "Accepted password|Accepted publickey" "$1" |
        awk '{for(i=1;i<=NF;i++) if($i=="for") print $(i+1)}'
    grep "sudo:.*session opened" "$1" |
        awk -F'by ' '{print $2}' | awk -F'\\(' '{print $1}'
    grep "su:.*session opened" "$1" |
        awk -F'by ' '{print $2}' | awk -F'\\(' '{print $1}'
} | sort | uniq -c | sort -nr | awk '{print $2 " : " $1}' | sed 's/^ *//' | tee -a ./reports/system_auth_report.txt

echo "==============================================
Report Generated : $(pwd)/reports/system_auth_report.txt
Report generated on: $(date)
=============================================="
