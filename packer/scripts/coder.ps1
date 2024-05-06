$uri="https://github.com/coder/coder/releases/download/v2.9.1/coder_2.9.1_windows_amd64_installer.exe"
Invoke-WebRequest -Uri $uri -OutFile "C:\Windows\Temp\coder_2.9.1_windows_amd64_installer.exe"
$uri="https://github.com/coder/coder/releases/download/v2.9.1/coder_2.9.1_checksums.txt"
Invoke-WebRequest -Uri $uri -OutFile "C:\Windows\Temp\coder_2.9.1_checksums.txt"

$checksum = (Get-Content "C:\Windows\Temp\coder_2.9.1_checksums.txt" | Select-String -Pattern "coder_2.9.1_windows_amd64_installer.exe").ToString().Split()[0]
$checksum_validation = Get-FileHash -Path "C:\Windows\Temp\coder_2.9.1_windows_amd64_installer.exe" -Algorithm SHA256

if ($checksum -eq $checksum_validation.Hash) {
    # Install coder
    Start-Process -FilePath "C:\Windows\Temp\coder_2.9.1_windows_amd64_installer.exe" -ArgumentList "/S" -Wait
} else {
    Write-Host "Checksum validation failed"
    exit 1
}

# create powershell script to start coder
$script = @"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Start-Process -FilePath "C:\Program Files\Coder\bin\coder" -ArgumentList "server" -WindowStyle Hidden 
"@
Set-Content -Path "C:\Program Files\Coder\CoderInit.ps1" -Value $script

# create registry key to run coder on startup for all users
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$regName = "Coder"
$regValue = 'powershell -ExecutionPolicy Bypass -File "C:\Program Files\Coder\CoderInit.ps1"'
New-ItemProperty -Path $regPath -Name $regName -Value $regValue -PropertyType String -Force

