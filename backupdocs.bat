set unixdir=%~dp0
set unixexe=%unixdir%%~nI0
bash -c -l "$(wslpath -u '%unixexe%')"
pause
