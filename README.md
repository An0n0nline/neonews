# 📰 NEWS SCANNER v2.0
**Matrix-style news aggregator with configurable scrolling and real-time updates**  
*(Now with default sources and scroll control in all modes!)*  

![Matrix Style](https://img.shields.io/badge/Style-Terminal_Matrix-green) 
![Bash Version](https://img.shields.io/badge/Bash-4.0%2B-blue)

## 🌟 Features
- **Dual search modes**: One-time or persistent auto-refresh
- **Customizable scrolling**: Control text flow speed (even in simple mode)
- **Pre-loaded news sources**: 5 default sites + unlimited custom URLs
- **Matrix-themed UI**: Green/black terminal styling
- **Smart filtering**: Multi-term search with `NULL` skip option

## 🚀 Quick Start
```bash
# Download and run:
wget https://raw.githubusercontent.com/your-repo/neonews4.sh/main/neonews4.sh
chmod +x neonews4.sh
./neonews4.sh

🕹️ Usage Guide
Main Menu Options
Option	Description	Special Features
1	Simple Search	Scroll speed control • One-time results
2	Persistent Search	Auto-refresh • Scroll control • Timer
3	Exit	-

Default News Sources
cnn.com/us
news.google.com
bbc.com/news
reuters.com
reddit.com/r/worldnews
(You can override these with custom URLs)

⚙️ Configuration Prompts
All modes will ask for:
Number of custom sites (or 0 for defaults)
Search terms (type NULL to skip filtering)
Scroll speed (e.g., 0.1 for fast, 0.5 for slow)

Persistent mode adds:
Refresh interval (seconds between updates)

🎨 Customization Tips
# Change colors by editing these variables:
GREEN=$(tput setaf 2)    # Matrix green
WHITE=$(tput setaf 15)   # Bright white

❓ Why This Rocks
No more Ctrl+S madness - Smooth scrolling built-in
Skip the URL-typing marathon - Default sites ready
Readable results - Color-highlighted matches
PV progress bar - Know when next refresh hits

"Like tail -f for the news, but way cooler"
— Probably someone in the Matrix

⚠️ Requirements: w3m, pv, bash 4.0+
💡 Pro Tip: Use 0.01 scroll speed for hacker-mode fast display!
