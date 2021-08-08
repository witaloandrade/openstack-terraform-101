$NewComputerName = "DC01"
$SafeModeAdministratorPassword = ConvertTo-SecureString "Y0urP4$$w0rdH3r3" -AsPlaintext -Force
$AutoLoginUser = "Administrator"
$AutoLoginPassword = "Y0urP4$$w0rdH3r3"

# Registry path for Autologon configuration
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

# Autologon configuration including: username, password,domain name and times to try autologon
Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String
Set-ItemProperty $RegPath "DefaultUsername" -Value "$AutoLoginUser" -type String
Set-ItemProperty $RegPath "DefaultPassword" -Value "$AutoLoginPassword" -type String
Set-ItemProperty $RegPath "AutoLogonCount" -Value "1" -type DWord

# Configures script to run once on next logon
Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name 'AD_Create' -Value "c:\windows\system32\cmd.exe /c C:\scripts\01-ad_init.bat"

# Change Administrator Password
net user Administrator "Y0urP4$$w0rdH3r3"
#Star ScriptS
Rename-Computer -NewName $NewComputerName
Start-Sleep -Seconds 5
Restart-Computer -Force