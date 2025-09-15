param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$ScriptPath
)

# 检查文件是否存在
if (-not (Test-Path $ScriptPath)) {
    Write-Host "Error: File '$ScriptPath' not found." -ForegroundColor Red
    exit 1
}

# 运行 AHK 脚本并获取进程对象
$ahkProcess = Start-Process -FilePath "AutoHotkey64.exe" -ArgumentList $ScriptPath -PassThru
$ScriptPid = $ahkProcess.Id
Write-Host "Started AutoHotkey64.exe with PID $ScriptPid" -ForegroundColor Cyan

# 进入只接受 Ctrl+C 的等待模式
Write-Host "`nPress Ctrl+C to exit. Other keys will be ignored and not shown." -ForegroundColor Yellow
try {
    while ($true) {
        [System.Console]::ReadKey($true) | Out-Null
    }
} catch {
    Write-Host "`nExiting on Ctrl+C. Stopping AutoHotkey process..." -ForegroundColor Green
    try {
        if ($ahkProcess -and !$ahkProcess.HasExited) {
            $ahkProcess.Kill()
            Write-Host "AutoHotkey process (PID $ScriptPid) stopped." -ForegroundColor Green
        }
    } catch {
        Write-Host "Failed to stop AutoHotkey process." -ForegroundColor Red
    }
}
