@echo off
color 0a
cd ../../../../
echo BUILDING GAME
haxelib run lime build Project.xml linux -debug
echo.
echo done.
pause
pwd
explorer.exe export\debug\linux\bin