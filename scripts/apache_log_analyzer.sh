#!/bin/bash

total_requests=$(wc -l <"$1")
success_requests=$(grep -c '" 200' "$1")
error404=$(grep -c '" 404' "$1")
admin_scans=$(grep -cE "/admin|/administrator|/wp-login\.php|/wp-admin" "$1")
sensitive_scans=$(grep -cE "/backup\.zip|/db\.sql|/\.env|/\.git" "$1")
ips=$(awk '{print $1}' "$1" | sort | uniq)

#sql injection detection
sql_matches="union|select|or[[:space:]]|or\+|and[[:space:]]|and\+|database\(\)|version\(\)|information_schema"
sql_inject_counts=$(cat $1 | grep -Ei "$sql_matches" | wc -l)
sql_inject_ips=$(cat $1 | grep -Ei "$sql_matches" | awk '{print $1}' | sort | uniq)
echo "*********** APACHE FINDINGS **********"
echo -e "[+] Log file : $(realpath "$1")"
echo "Total Requests: ${total_requests}"
echo "Successfull Requests: ${success_requests} "
echo "404 error counts: ${error404}"
echo "Admin Scan attempts: ${admin_scans}"
echo "Sensitive data probes: ${sensitive_scans}"
echo "--------------------------------------"

for ip in ${ips}; do
    echo "$(grep -c "^${ip} " "$1") IP : ${ip}"
done | sort -nr | awk '{print $2 " " $3 " " $4 "\tREQUESTS : " $1}'
echo "--------------------------------------"
if [[ ${sql_inject_counts} -ge 1 ]]; then

	if [[ $sql_inject_counts -ge 5 ]]; then
		risk="\e[41mHIGH\e[0m"
	elif [[ $sql_inject_counts -ge 1 ]]; then
		risk="\e[43mMEDIUM\e[0m"
	fi
else
	risk="\e[42mLOW\e[0m"
fi

if [[ ${sql_inject_counts} -ge 1 ]]; then
	echo "*** SQL Injection Attempts Detected!"
	echo "------- SUMMARY ------"
	for si_ip in ${sql_inject_ips}; do
    count=$(grep -Ei "$sql_matches" "$1" | grep "^${si_ip} " | awk '{print $1}' | wc -l)
    echo -e "$count $si_ip"
done | sort -nr | awk '{print "IP : " $2 " \tATTEMPTS : " $1 }'

	echo -e "ATTEMPTS:  ${sql_inject_counts}\nRisk Level: $risk"
fi
echo "==============================================
Report Generated : $(pwd)/reports/apache_report.txt
Report generated on: $(date)
==============================================" 
