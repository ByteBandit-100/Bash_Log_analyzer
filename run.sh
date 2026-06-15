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
	./scripts/apache_log_analyzer.sh "$1" | tee ./reports/apache_report.txt
elif [[ "$1" == *"auth.log"* || "$1" == *"ssh"* || "$1" == *"secure"* || $1 == *"auth"* ]]; then
	./scripts/ssh_auth_analyzer.sh "$1" | tee ./reports/ssh_auth_report.txt
else
	echo "Unsupported log type"
fi
echo -e "\e[1;33m================================================\e[0m"
