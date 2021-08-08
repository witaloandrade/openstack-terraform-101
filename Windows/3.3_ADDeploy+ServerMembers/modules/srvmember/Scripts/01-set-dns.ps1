Start-Transcript -Path "C:\scripts\SetDns.log" -NoClobber
$AutoLoginUser = "${NewAdminUser}"
$AutoLoginPassword = "${NewAdminPass}"

# Registry path for Autologon configuration
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

# Autologon configuration including: username, password,domain name and times to try autologon
Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String
Set-ItemProperty $RegPath "DefaultUsername" -Value "$AutoLoginUser" -type String
Set-ItemProperty $RegPath "DefaultPassword" -Value "$AutoLoginPassword" -type String
Set-ItemProperty $RegPath "AutoLogonCount" -Value "1" -type DWord

# Configures script to run once on next logon
Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name 'DomainJOin' -Value "c:\windows\system32\cmd.exe /c C:\scripts\02-domainjoin.bat"


New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters\" -Name "DisabledComponents" -Value 0xFF -PropertyType "DWord"
Sleep -s 3
Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses ("${ipad}")
Sleep -s 3
restart-computer -Force