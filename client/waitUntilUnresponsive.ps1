param (
	[Parameter(Mandatory=$true)][string]$myhost
)
Write-Host "Waiting for host '$myhost' to stop responding to pings..." -NoNewLine
do {$ping = test-connection -comp $myhost -Count 1 -Quiet} until (!$ping)
echo "...host is down."