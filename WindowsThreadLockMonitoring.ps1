# ---------------- PLUGIN METADATA ----------------
$PLUGIN_VERSION = "1"

$data = [ordered]@{
    plugin_version     = $PLUGIN_VERSION
    heartbeat_required = "true"
    status             = 1
    msg                = "success"
}

# ---------------- METRIC UNITS ----------------
$data.units = @{
    "Dotnet Locks Total Contentions"               = "contentions"
    "Dotnet Locks Total Contentions Delta"         = "contentions"
    "Dotnet Locks Contention Rate Per Sec Global"  = "contentions/sec"
    "Dotnet Locks Current Queue Length Global"     = "threads"
    "Dotnet Locks Queue Length Per Sec Global"     = "threads/sec"
    "Dotnet Locks Queue Length Peak Global"        = "threads"
    "Dotnet Locks Current Logical Threads"         = "threads"
    "Dotnet Locks Current Physical Threads"        = "threads"
    "Dotnet Locks Rate Recognized Threads Per Sec" = "threads/sec"
    "System Processor Queue Length"                = "threads"
    "Cpu Total Usage Percent"                      = "percent"
    "Process Thread Count"                         = "threads"
    "System Context Switches Per Sec"              = "count/sec"
    "System Threads"                               = "threads"
}

# ---------------- SAFE COUNTER FUNCTION ----------------
function Get-MetricSafe {
    param($Name, $CounterPath)
    try {
        $v = (Get-Counter -Counter $CounterPath -ErrorAction Stop).CounterSamples[0].CookedValue
        if ($null -eq $v -or $v -lt 0) { $v = 0 }
        $data[$Name] = [math]::Round($v, 2)
    } catch {
        $data[$Name] = 0
    }
}

# ==================================================
# .NET LOCK METRICS
# ==================================================
Get-MetricSafe "Dotnet Locks Total Contentions" `
    '\.NET CLR LocksAndThreads(_Global_)\Total # of Contentions'

# ---- DELTA ----
$stateFile = "$PSScriptRoot\locks_state.json"
$prev = 0
if (Test-Path $stateFile) {
    try { $prev = (Get-Content $stateFile | ConvertFrom-Json).total } catch {}
}

$current = $data["Dotnet Locks Total Contentions"]
$data["Dotnet Locks Total Contentions Delta"] = [math]::Max(0, $current - $prev)
@{ total = $current } | ConvertTo-Json | Set-Content $stateFile -Force

Get-MetricSafe "Dotnet Locks Contention Rate Per Sec Global" `
    '\.NET CLR LocksAndThreads(_Global_)\Contention Rate / sec'

Get-MetricSafe "Dotnet Locks Current Queue Length Global" `
    '\.NET CLR LocksAndThreads(_Global_)\Current Queue Length'

Get-MetricSafe "Dotnet Locks Queue Length Per Sec Global" `
    '\.NET CLR LocksAndThreads(_Global_)\Queue Length / sec'

Get-MetricSafe "Dotnet Locks Queue Length Peak Global" `
    '\.NET CLR LocksAndThreads(_Global_)\Queue Length Peak'

Get-MetricSafe "Dotnet Locks Current Logical Threads" `
    '\.NET CLR LocksAndThreads(_Global_)\# of current logical Threads'

Get-MetricSafe "Dotnet Locks Current Physical Threads" `
    '\.NET CLR LocksAndThreads(_Global_)\# of current physical Threads'

Get-MetricSafe "Dotnet Locks Rate Recognized Threads Per Sec" `
    '\.NET CLR LocksAndThreads(_Global_)\Rate of recognized threads / sec'

# ==================================================
# SYSTEM METRICS
# ==================================================
Get-MetricSafe "System Processor Queue Length" '\System\Processor Queue Length'
Get-MetricSafe "Cpu Total Usage Percent" '\Processor(_Total)\% Processor Time'
Get-MetricSafe "Process Thread Count" '\Process(_Total)\Thread Count'
Get-MetricSafe "System Context Switches Per Sec" '\System\Context Switches/sec'
Get-MetricSafe "System Threads" '\System\Threads'

# ==================================================
# TOP PROCESS TABLE (SITE24X7 COMPATIBLE)
# ==================================================

$processTable = @()


$cpuCount = [Environment]::ProcessorCount
$uptime   = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
$uptimeSec = $uptime.TotalSeconds

Get-Process |
Where-Object { $_.CPU -ne $null } |
Sort-Object CPU -Descending |
Select-Object -First 5 |
ForEach-Object {
    $cpuPercent = if ($uptimeSec -gt 0) {
        [math]::Round(($_.CPU / ($uptimeSec * $cpuCount)) * 100, 2)
    } else {
        0
    }

    $processTable += [ordered]@{
        "name"           = $_.ProcessName
        "Thread_Count"   = $_.Threads.Count
        "CPU_Percentage" = $cpuPercent
        "Memory_MB"      = [math]::Round($_.WorkingSet64 / 1MB, 2)
    }
}

if ($processTable.Count -gt 0) {
    $data["Top  Processes"] = $processTable
}

# ---------------- FINAL OUTPUT ----------------
$data | ConvertTo-Json -Depth 5 -Compress
