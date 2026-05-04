# ============================================================
# Behringer DCX-Remote 串口启动工具 (默认 9600 版)
# ============================================================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# --- 1. ASCII Logo ---
Clear-Host
$asciiLogo = @"
  ____   ______  __  __   ____   _____  __  __   ___   _____  _____ 
 |  _ \ / ___| \ \ \/ /  |  _ \ | ____| |  \/  | / _ \ |_   _|| ____|
 | | | | |      \ \  /   | |_) ||  _|   | |\/| || | | |  | |  |  _|  
 | |_| | |___   / /  \   |  _ < | |___  | |  | || |_| |  | |  | |___ 
 |____/ \____| /_/ /\_\  |_| \_\|_____| |_|  |_| \___/   |_|  |_____|
"@
Write-Host $asciiLogo -ForegroundColor Cyan
Write-Host "`n --- STABLE LAUNCHER (Default: 9600) ---" -ForegroundColor Gray

# --- 2. 获取并选择串口 ---
$availablePorts = [System.IO.Ports.SerialPort]::GetPortNames()
if ($availablePorts.Count -eq 0) {
    Write-Host " [!] 未发现串口！请检查 USB 线是否连接。" -ForegroundColor Red
    Pause; exit
}

$idx = 0 # 预声明变量防止 [ref] 报错
Write-Host "`n[步骤 1] 请选择串口 / Select COM Port:" -ForegroundColor Yellow
for ($i = 0; $i -lt $availablePorts.Count; $i++) {
    Write-Host "  $($i + 1). $($availablePorts[$i])"
}
$choiceIdx = Read-Host "请输入序号 [1-$($availablePorts.Count)]"
if (-not [int]::TryParse($choiceIdx, [ref]$idx) -or $idx -le 0 -or $idx -gt $availablePorts.Count) {
    Write-Host " 输入无效，程序退出。" ; Start-Sleep -Seconds 2 ; exit
}
$selectedPort = $availablePorts[$idx - 1]

# --- 3. 选择波特率 (默认 9600) ---
$baudRates = @(9600, 19200, 38400, 57600, 115200)
$selectedBaud = 9600 # 默认值设为 9600
$bIdx = 0            # 预声明变量

Write-Host "`n[步骤 2] 请选择波特率 / Select Baud Rate:" -ForegroundColor Yellow
for ($i = 0; $i -lt $baudRates.Count; $i++) {
    Write-Host "  $($i + 1). $($baudRates[$i])"
}
$baudChoice = Read-Host "请输入序号 [1-5] (直接回车默认 9600)"

if (-not [string]::IsNullOrWhiteSpace($baudChoice)) {
    if ([int]::TryParse($baudChoice, [ref]$bIdx) -and $bIdx -gt 0 -and $bIdx -le $baudRates.Count) {
        $selectedBaud = $baudRates[$bIdx - 1]
    }
}
Write-Host " 已选择波特率: $selectedBaud" -ForegroundColor Green

# --- 4. 激活过程 (静默/非阻塞模式) ---
Write-Host "`n正在初始化 $selectedPort..." -ForegroundColor Cyan
try {
    # 尝试 CMD mode 命令强制激活物理层
    cmd /c "mode $($selectedPort): baud=$($selectedBaud) data=8 stop=1 parity=n" > $null 2>&1
    
    # 尝试 .NET SerialPort 握手
    $port = New-Object System.IO.Ports.SerialPort($selectedPort, $selectedBaud)
    $port.Open()
    if ($port.IsOpen) {
        $port.DtrEnable = $true
        $port.RtsEnable = $true
        Start-Sleep -Milliseconds 300
        $port.Close()
        Write-Host " [+] 串口预激活成功。" -ForegroundColor Green
    }
} catch {
    # 即使由于没接东西或驱动限制报错，也不中断程序
    Write-Host " [!] 预激活跳过 (硬件未就绪或被占用)，准备直接启动软件。" -ForegroundColor Gray
}

# --- 5. 启动软件 (彻底修复路径绑定问题) ---
# 解决 PowerShell 会话中 $PSScriptRoot 可能为空的问题
$baseDir = $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($baseDir)) { $baseDir = Get-Location }

$softwareName = "DCX-Remote.exe"
$fullPath = Join-Path $baseDir $softwareName

if (Test-Path $fullPath) {
    Write-Host "`n [+] 正在启动 $softwareName..." -ForegroundColor Yellow
    # 转换为绝对路径并显式指定工作目录
    $absPath = (Resolve-Path $fullPath).Path
    $absDir = (Resolve-Path $baseDir).Path
    Start-Process -FilePath "$absPath" -WorkingDirectory "$absDir"
} else {
    Write-Host "`n [!] 未在目录 $baseDir 中找到 $softwareName" -ForegroundColor Red
    $manual = Read-Host " 请手动输入 EXE 的完整路径"
    if (-not [string]::IsNullOrWhiteSpace($manual) -and (Test-Path $manual)) {
        $manualDir = Split-Path -Parent $manual
        Start-Process -FilePath "$manual" -WorkingDirectory "$manualDir"
    }
}

Write-Host "`n任务完成。窗口将在 3 秒后关闭。" -ForegroundColor Gray
Start-Sleep -Seconds 3