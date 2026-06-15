# Bash Log Analyzer

A lightweight SOC-style log analysis tool built with Bash for detecting suspicious activity, generating security findings, and creating reports from log files.

In this project i used dummy log files if you want to analyze your own log file than just give your log path along with file so it can easily dectect the file.
## 📌 Project Status

### ✅ Completed Modules

#### Apache Log Analyzer
- Total request counting
- Successful request detection (HTTP 200)
- 404 error counting
- Admin panel scan detection
- Sensitive file probe detection
- SQL Injection attempt detection
- Per-IP request statistics
- Risk level classification
- Automated report generation

## 🚧 Pending Modules

* SSH Log Analyzer
* Linux Auth Log Analyzer
* Mixed Event Log Analyzer

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