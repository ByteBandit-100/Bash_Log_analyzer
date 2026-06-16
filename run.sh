#!/bin/bash
echo -e "\e[1;33m================================================"
echo -e "\t\tBASH LOG ANALYZER	"
echo "================================================"
echo -en "\e[0m"

if [[ $# -ne 1 ]]; then
	echo "Usage: $0 <logfile> or </path/logfile>"
	echo -e "\e[1;33m================================================\e[0m"
	exit 1
fi

if [[ ! -f "$1" ]]; then
	echo "FILE NOT FOUND :<"
	echo -e "\e[1;33m================================================\e[0m"
	exit 1

fi

if [[ "$1" == *"access.log"* || "$1" == *"apache"* ]]; then
	echo " "
	./scripts/apache_log_analyzer.sh "$1" | tee ./reports/apache_report.txt
	echo " "
elif [[ "$1" == *"auth.log"* || "$1" == *"ssh"* || "$1" == *"secure"* || $1 == *"auth"* ]]; then
	./scripts/ssh_analyzer.sh "$1" | tee ./reports/ssh_report.txt
	echo -ne "\nWant to see system Authentication analysis(yes/no) : "
	read -r ch
	if [[ "${ch,,}" == 'yes' ]]; then
		echo " "
		./scripts/system_auth_analyzer.sh "$1" | tee ./reports/system_auth_report.txt
		echo " "

	else
		echo "-------- Most Authenticated users[SSH/SUDO/SU] --------
	$({
			grep -E "Accepted password|Accepted publickey" "$1" |
				awk '{for(i=1;i<=NF;i++)if($i=="for")print $(i+1)}'
			grep "sudo:.*session opened" "$1" |
				awk -F'by ' '{print $2}' |
				awk -F'\\(' '{print $1}'
			grep "su:.*session opened" "$1" | awk -F'by ' '{print $2}' | awk -F'\\(' '{print $1}'
		} | sort | uniq -c | sort -nr | awk '{print $2 " : " $1}')" | tee -a ./reports/ssh_report.txt
	fi
else
	echo "Unsupported log type"
fi
echo -e "\e[1;33m================================================\e[0m"
