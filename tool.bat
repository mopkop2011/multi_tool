@echo off
setlocal EnableDelayedExpansion
title IT TOOLKIT

:: Load saved color
if exist color.cfg (
    set /p toolcolor=<color.cfg
    color %toolcolor%
) else (
    set toolcolor=0A
    color 0A
)

:menu
cls
echo(
echo ==== SYSTEM TOOLS (A) ====
echo A1 - Show IP Configuration
echo A2 - Show System Information
echo A3 - Task Manager
echo A4 - Command Prompt
echo A5 - Open Calculator
echo A6 - Open Notepad
echo A7 - System File Checker (sfc /scannow)
echo A8 - Disk Check (chkdsk)
echo A9 - Device Manager
echo A10- Task Scheduler

echo.
echo ==== NETWORK TOOLS (B) ====
echo B1 - Show WiFi Profiles
echo B2 - Show WiFi Password
echo B3 - Ping Google
echo B4 - Show ARP Table
echo B5 - Show Network Connections
echo B6 - Clear DNS Cache
echo B7 - Show Network Adapters

echo.
echo ==== USER TOOLS (C) ====
echo C1 - Show Current User
echo C2 - Rename User
echo C3 - List Local Users
echo C4 - Change Computer Name
echo C5 - List Installed Programs

echo.
echo ==== UTILITIES / OTHER (D) ====
echo D1 - Open Control Panel
echo D2 - Open File Explorer
echo D3 - Change Console Colors
echo D4 - Battery Report
echo D5 - List Running Processes
echo D6 - Show Running Services
echo D7 - Clean Temporary Files

echo.
echo ==== POWER (E) ====
echo E1 - Shutdown
echo E2 - Restart
echo E3 - Log Off
echo E4 - Exit
echo.

set /p choice= 

rem ----------------- SYSTEM -----------------
if /I "%choice%"=="A1" ipconfig & pause & goto menu
if /I "%choice%"=="A2" systeminfo & pause & goto menu
if /I "%choice%"=="A3" start taskmgr & goto menu
if /I "%choice%"=="A4" start cmd & goto menu
if /I "%choice%"=="A5" start calc & goto menu
if /I "%choice%"=="A6" start notepad & goto menu
if /I "%choice%"=="A7" sfc /scannow & goto menu
if /I "%choice%"=="A8" chkdsk & pause & goto menu
if /I "%choice%"=="A9" start devmgmt.msc & goto menu
if /I "%choice%"=="A10" start taskschd.msc & goto menu

rem ----------------- NETWORK -----------------
if /I "%choice%"=="B1" netsh wlan show profiles & pause & goto menu
if /I "%choice%"=="B2" goto wifipass
if /I "%choice%"=="B3" ping google.com & pause & goto menu
if /I "%choice%"=="B4" arp -a & pause & goto menu
if /I "%choice%"=="B5" netstat -ano & pause & goto menu
if /I "%choice%"=="B6" ipconfig /flushdns & pause & goto menu
if /I "%choice%"=="B7" ipconfig /all & pause & goto menu

rem ----------------- USER -----------------
if /I "%choice%"=="C1" whoami & pause & goto menu
if /I "%choice%"=="C2" goto renameuser
if /I "%choice%"=="C3" net user & pause & goto menu
if /I "%choice%"=="C4" goto computername
if /I "%choice%"=="C5" wmic product get name,version & pause & goto menu

rem ----------------- UTILITIES -----------------
if /I "%choice%"=="D1" start control & goto menu
if /I "%choice%"=="D2" start explorer & goto menu
if /I "%choice%"=="D3" goto colors
if /I "%choice%"=="D4" powercfg /batteryreport & pause & goto menu
if /I "%choice%"=="D5" tasklist & pause & goto menu
if /I "%choice%"=="D6" sc query & pause & goto menu
if /I "%choice%"=="D7" goto cleantemp

rem ----------------- POWER -----------------
if /I "%choice%"=="E1" shutdown /s /t 0
if /I "%choice%"=="E2" shutdown /r /t 0
if /I "%choice%"=="E3" shutdown /l
if /I "%choice%"=="E4" exit

goto menu

:wifipass
cls
echo Saved WiFi profiles:
echo.
set count=0
for /f "tokens=2 delims=:" %%A in ('netsh wlan show profiles ^| findstr "All User Profile"') do (
    set /a count+=1
    set name=%%A
    set name=!name:~1!
    set wifi!count!=!name!
    echo !count! - !name!
)
echo.
set /p pick=Select WiFi number:
set ssid=!wifi%pick%!
cls
netsh wlan show profile name="%ssid%" key=clear | findstr "Key Content"
pause
goto menu

:renameuser
cls
echo Existing users:
net user
echo.
set /p olduser=Enter current username:
set /p newuser=Enter new username:
wmic useraccount where name='%olduser%' rename %newuser%
pause
goto menu

:computername
cls
echo Current computer name:
hostname
echo.
set /p newname=Enter new computer name:
wmic computersystem where name="%computername%" call rename name="%newname%"
echo Restart required
pause
goto menu

:cleantemp
cls
echo Cleaning temporary files...
del /q /f /s %temp%\*
del /q /f /s C:\Windows\Temp\*
echo Done
pause
goto menu

:colors
cls
echo ====================
echo    COLOR SETTINGS
echo ====================
echo.
echo 0 = Black
echo 1 = Blue
echo 2 = Green
echo 3 = Aqua
echo 4 = Red
echo 5 = Purple
echo 6 = Yellow
echo 7 = White
echo 8 = Gray
echo 9 = Light Blue
echo A = Light Green
echo B = Light Aqua
echo C = Light Red
echo D = Light Purple
echo E = Light Yellow
echo F = Bright White
echo.
set /p bg=Background color:
set /p fg=Text color:
set toolcolor=%bg%%fg%
color %toolcolor%
echo %toolcolor%>color.cfg
goto menu
