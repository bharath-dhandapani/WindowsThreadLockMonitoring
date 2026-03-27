# Windows ThreadLock Monitoring Plugin

A custom Windows monitoring plugin developed using PowerShell to detect thread lock conditions and collect real-time system/process metrics. Designed for seamless integration with Site24x7 dashboards.

---

##  Project Overview

This project was developed during my internship at Zoho Corporation.  
The plugin helps in identifying thread lock situations in Windows systems and provides structured monitoring data for better observability and system reliability.

---

## Features

- Detects thread lock conditions in Windows processes  
- Collects real-time CPU, memory, and process metrics  
- Outputs structured JSON data  
- Lightweight and efficient PowerShell script  
- Easy integration with monitoring tools like Site24x7  

---

##  Technologies Used

- **PowerShell** – Core scripting  
- **Windows APIs** – Process & thread monitoring  
- **JSON** – Data formatting  
- **Site24x7** – Monitoring integration  

---

##  How It Works

1. Scans active processes in the Windows system  
2. Detects blocked or unresponsive threads  
3. Collects system and process metrics  
4. Converts data into JSON format  
5. Sends output to monitoring dashboards  

---

## Versioning Policy

This project follows a simple versioning mechanism.

- The `plugin_version` field in the output JSON represents the current version of the script.
- Whenever any modification is made to the script (bug fix, improvement, or feature addition), the version must be incremented.

### Version Rule:
- `1` → Initial version  
- `2` → After first update  
- `3` → After next update  

> Any change in the script must update the `plugin_version` from the old version to a new version.

---

##  Sample Output

```json
{
  "plugin_version": "1",
  "heartbeat_required": "true",
  "status": 1,
  "msg": "success",
  "units": {
    "Process Thread Count": "threads",
    "System Processor Queue Length": "threads",
    "Dotnet Locks Rate Recognized Threads Per Sec": "threads/sec",
    "Dotnet Locks Current Queue Length Global": "threads",
    "Dotnet Locks Current Logical Threads": "threads",
    "Dotnet Locks Current Physical Threads": "threads",
    "Dotnet Locks Total Contentions": "contentions",
    "Dotnet Locks Queue Length Peak Global": "threads",
    "Cpu Total Usage Percent": "percent",
    "System Context Switches Per Sec": "count/sec",
    "System Threads": "threads",
    "Dotnet Locks Total Contentions Delta": "contentions",
    "Dotnet Locks Queue Length Per Sec Global": "threads/sec",
    "Dotnet Locks Contention Rate Per Sec Global": "contentions/sec"
  },
  "Dotnet Locks Total Contentions": 18,
  "Dotnet Locks Total Contentions Delta": 18,
  "Dotnet Locks Contention Rate Per Sec Global": 0,
  "Dotnet Locks Current Queue Length Global": 0,
  "Dotnet Locks Queue Length Per Sec Global": 0,
  "Dotnet Locks Queue Length Peak Global": 6,
  "Dotnet Locks Current Logical Threads": 69,
  "Dotnet Locks Current Physical Threads": 61,
  "Dotnet Locks Rate Recognized Threads Per Sec": 0,
  "System Processor Queue Length": 0,
  "Cpu Total Usage Percent": 26.49,
  "Process Thread Count": 3635,
  "System Context Switches Per Sec": 10940.63,
  "System Threads": 3624,
  "Top  Processes": [
    {
      "name": "GoogleDriveFS",
      "Thread_Count": 164,
      "CPU_Percentage": 0.02,
      "Memory_MB": 108.21
    },
    {
      "name": "OneDrive",
      "Thread_Count": 42,
      "CPU_Percentage": 0.01,
      "Memory_MB": 176.65
    },
    {
      "name": "chrome",
      "Thread_Count": 23,
      "CPU_Percentage": 0.01,
      "Memory_MB": 290.74
    },
    {
      "name": "explorer",
      "Thread_Count": 115,
      "CPU_Percentage": 0.01,
      "Memory_MB": 365.43
    },
    {
      "name": "chrome",
      "Thread_Count": 46,
      "CPU_Percentage": 0.01,
      "Memory_MB": 252.3
    }
  ]
}
