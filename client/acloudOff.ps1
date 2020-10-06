$user = "ADMIN"
$pw = ConvertTo-SecureString -String "ADMIN" -AsPlainText -Force
$cred = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $user, $pw

echo "sending IPMI power-off command"
Get-PcsvDevice -TargetAddress "acloud-ipmi" -ManagementProtocol IPMI -Credential $cred | Stop-PcsvDevice

.\waitUntilUnresponsive "acloud"

pause
