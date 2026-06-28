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
    Start-Process -FilePath $Exe.FullName
}
else {
    Write-Host "[-] .exe файл не найден." -ForegroundColor Yellow
}

Write-Host "[+] Готово!" -ForegroundColor Green