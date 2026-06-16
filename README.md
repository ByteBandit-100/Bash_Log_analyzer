# Bash Log Analyzer

A lightweight SOC-style log analysis tool built with Bash for detecting suspicious activity, generating security findings, and creating reports from log files.

In this project i used dummy log files if you want to analyze your own log file than just give your log path along with file so it can easily dectect the file.
## 📌 Project Status

### ✅ Completed Modules

### SSH Log Analysis
 - Total SSH events
 - Successful login detection
 - Failed login detection
 - Invalid user detection
Top targeted usernames
 - Top attacker IP addresses
 - Root login activity
 - Brute force attack detection
### System Authentication Analysis
 - Sudo usage monitoring
 - SU activity monitoring
 - Authentication failure detection
 - User account management tracking
 - Password change detection
 - Group modification detection
 - Cron job activity analysis
 - Most authenticated users identification
### Apache Log Analysis
 - Total requests
 - Unique visitors
 - Top client IP addresses
 - HTTP status code analysis
 - Most requested resources
 - Error request detection
### Report Generation
 - Generate reports for all logs supported with seperate files

## 🚧 Pending Modules

* System Log Analyzer

## Technologies Used
 - Bash Shell Scripting
 - grep
 - awk
 - sort
 - uniq
 - wc
 - tee etc.
### Future Enhancements
- Export reports as CSV, JSON
- Severity-based alerting
- IP reputation scoring
- Dashboard-style summaries


## 🚀 Usage

```bash
git clone https://github.com/ByteBandit-100/Bash_Log_analyzer.git
cd Bash_Log_analyzer
chmod +x run.sh
chmod +x scripts/apache_log_analyzer.sh

./run.sh logs/apache_attack.log
```

## 🎯 Goal

Build a SOC-oriented Bash-based log analysis toolkit capable of analyzing web server, SSH, and Linux authentication logs while generating actionable security reports.

---

Github : ByteBandit-100