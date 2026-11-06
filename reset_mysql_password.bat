@echo off
title MySQL Password Reset Tool
color 0A
echo ============================================================
echo       MediCare MySQL Root Password Reset Utility
echo ============================================================
echo.

:: Check Admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Yeh script run karne ke liye Administrator permission chahiye.
    echo Kripya is file par Right Click karein aur 'Run as administrator' select karein!
    echo.
    pause
    exit /b 1
)

echo 1. Stopping running MySQL Windows service...
net stop MySQL80 >nul 2>&1
net stop mysql >nul 2>&1
taskkill /F /IM mysqld.exe >nul 2>&1

echo 2. Preparing password reset script...
echo ALTER USER 'root'@'localhost' IDENTIFIED BY 'root123'; > "%TEMP%\reset_init.sql"
echo FLUSH PRIVILEGES; >> "%TEMP%\reset_init.sql"

echo 3. Applying new password (root123)...
start "" /B "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqld.exe" --defaults-file="C:\ProgramData\MySQL\MySQL Server 8.0\my.ini" --init-file="%TEMP%\reset_init.sql" --console
timeout /t 5 /nobreak >nul

echo 4. Restarting MySQL service normally...
taskkill /F /IM mysqld.exe >nul 2>&1
timeout /t 2 /nobreak >nul
net start MySQL80 >nul 2>&1
net start mysql >nul 2>&1

del "%TEMP%\reset_init.sql" >nul 2>&1

echo.
echo ============================================================
echo [SUCCESS] MySQL Root Password successfully reset to: root123
echo ============================================================
echo.
echo Ab aap VS Code terminal me yeh run karein:
echo   cd backend
echo   npm run db:init
echo.
pause

