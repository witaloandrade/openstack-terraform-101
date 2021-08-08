Start-Transcript -Path "C:\scripts\DomainJoin.log" -NoClobber
$AutoLoginUser = "${NewAdminUser}"
$AutoLoginPassword = "${NewAdminPass}"
$DomainName = "${NewDomainName}"

# Registry path for Autologon configuration
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

# Autologon configuration including: username, password,domain name and times to try autologon
Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String
Set-ItemProperty $RegPath "DefaultUsername" -Value "$AutoLoginUser" -type String
Set-ItemProperty $RegPath "DefaultPassword" -Value "$AutoLoginPassword" -type String
Set-ItemProperty $RegPath "AutoLogonCount" -Value "1" -type DWord

# Configures script to run once on next logon
Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name 'DomainJOin' -Value "c:\windows\system32\cmd.exe /c C:\scripts\03-postcofig.bat"

#Test If domain in UP
$ping = test-connection -comp "$DomainName" -Quiet
$ping
while ( !$ping )
{
$ping = test-connection -comp "$DomainName" -Quiet
Get-Date ; Write-Host "Erro de Ping" ; Clear-DnsClientCache; Sleep -s 60
}

# Execute Domain Join
#$domain = "narnia.local"
$password = "$AutoLoginPassword" | ConvertTo-SecureString -asPlainText -Force
$username = "$DomainName\$AutoLoginUser" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName "$DomainName" -Credential $credential
Sleep -s 30
## Restart Server
Restart-computer -Force
Stop-Transcript