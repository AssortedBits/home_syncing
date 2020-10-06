pushd %~dp0

powershell .\acloudOn.ps1

rem give server time to start SSH daemon
timeout 5

bash -c "~/family/scripts/pushdocs"

bash -c -l "~/family/scripts/acloudPushAwsThenHalt.sh"

popd

pause
