set unixdir=%~dp0
set unixexe=%unixdir%%~n0
bash -c -l "$(wslpath -u '%unixexe%')"
pause
