$user = "ADMIN"
$pw = ConvertTo-SecureString -String "ADMIN" -AsPlainText -Force
$cred = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $user, $pw

echo "Querying Value of EnabledState property of acloud-ipmi ..."
$enabledState = (Get-PcsvDevice -TargetAddress "acloud-ipmi" -ManagementProtocol IPMI -Credential $cred).EnabledState
echo "... EnabledState is: $enabledState"
.\waitUntilResponsive "acloud"

pause