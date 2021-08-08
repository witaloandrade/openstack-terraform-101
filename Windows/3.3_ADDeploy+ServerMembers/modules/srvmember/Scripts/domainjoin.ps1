Start-Transcript -Path "C:\scripts\domainjoin.log" -NoClobber
#Test If domain in UP
$ping = test-connection -comp narnia.local -Quiet
$ping
while ( !$ping )
{
$ping = test-connection -comp narnia.local -Quiet
Get-Date ; Write-Host "Erro de Ping" ; Clear-DnsClientCache; Sleep -s 60
}

# Execute Domain Join
$domain = "narnia.local"
$password = "Y0urP4$$w0rdH3r3" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\Administrator" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential
Sleep -s 30
## Restart Server
Restart-computer -Force