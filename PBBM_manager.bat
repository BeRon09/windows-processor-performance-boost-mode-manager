@echo off
setlocal EnableExtensions EnableDelayedExpansion

title Processor Performance Boost Mode Manager


set "SUB_PROCESSOR=54533251-82be-4824-96c1-47b60b740d00"
set "PERFBOOSTMODE=be337238-0d82-4146-a960-4f3749d470c7"

:START
cls
echo =====================================================
echo   Processor Performance Boost Mode ^(PPBM^) Manager
echo =====================================================
echo.

call :ReadPowerPlan
echo Active power plan: !PLAN!
echo.

call :ReadCurrent
call :ModeName !AC_DEC! AC_NAME
call :ModeName !DC_DEC! DC_NAME

echo Current PPBM:
echo   Plugged in ^(AC^): !AC_NAME!  [!AC_DEC!]
echo   Battery    ^(DC^): !DC_NAME!  [!DC_DEC!]
echo.

choice /c YN /m "Change it?"
if errorlevel 2 goto END

:TARGET
cls
echo Choose what you want to change:
echo.
echo   1. Plugged in only ^(AC^)
echo   2. Battery only ^(DC^)
echo   3. Both AC and DC
echo   4. Cancel
echo.
set /p "TARGET=Enter choice: "

if "%TARGET%"=="4" goto START
if not "%TARGET%"=="1" if not "%TARGET%"=="2" if not "%TARGET%"=="3" (
    echo.
    echo Invalid choice.
    pause
    goto TARGET
)

:MODEMENU
cls
echo Choose Processor Performance Boost Mode:
echo.
echo   0. Disabled
echo   1. Enabled
echo   2. Aggressive
echo   3. Efficient Enabled
echo   4. Efficient Aggressive
echo   5. Aggressive at Guaranteed
echo   6. Efficient Aggressive at Guaranteed
echo   7. Cancel
echo.
set /p "MODE=Enter mode number: "

if "%MODE%"=="7" goto START
if "%MODE%"=="" goto MODEBAD

for /f "delims=0123456789" %%A in ("%MODE%") do goto MODEBAD
if %MODE% LSS 0 goto MODEBAD
if %MODE% GTR 6 goto MODEBAD

goto APPLY

:MODEBAD
echo.
echo Invalid mode number.
pause
goto MODEMENU

:APPLY
echo.
echo Applying mode %MODE%...

if "%TARGET%"=="1" (
    powercfg /setacvalueindex SCHEME_CURRENT %SUB_PROCESSOR% %PERFBOOSTMODE% %MODE%
)

if "%TARGET%"=="2" (
    powercfg /setdcvalueindex SCHEME_CURRENT %SUB_PROCESSOR% %PERFBOOSTMODE% %MODE%
)

if "%TARGET%"=="3" (
    powercfg /setacvalueindex SCHEME_CURRENT %SUB_PROCESSOR% %PERFBOOSTMODE% %MODE%
    powercfg /setdcvalueindex SCHEME_CURRENT %SUB_PROCESSOR% %PERFBOOSTMODE% %MODE%
)

powercfg /S SCHEME_CURRENT >nul

echo.
echo Done.
echo.
call :ReadPowerPlan
echo Active power plan: !PLAN!
echo.
call :ReadCurrent
call :ModeName !AC_DEC! AC_NAME
call :ModeName !DC_DEC! DC_NAME
echo New PPBM:
echo   Plugged in ^(AC^): !AC_NAME!  [!AC_DEC!]
echo   Battery    ^(DC^): !DC_NAME!  [!DC_DEC!]
echo.
pause
goto START

:ReadPowerPlan
set "PLAN=Unknown"
for /f "tokens=2 delims=:" %%A in ('powercfg /getactivescheme 2^>nul') do (
    set "PLAN=%%A"
)


for /f "tokens=* delims= " %%A in ("!PLAN!") do set "PLAN=%%A"
exit /b

:ReadCurrent
set "AC_RAW="
set "DC_RAW="

for /f "tokens=2 delims=:" %%A in ('powercfg /query SCHEME_CURRENT %SUB_PROCESSOR% %PERFBOOSTMODE% ^| findstr /C:"Current AC Power Setting Index"') do (
    set "AC_RAW=%%A"
)

for /f "tokens=2 delims=:" %%A in ('powercfg /query SCHEME_CURRENT %SUB_PROCESSOR% %PERFBOOSTMODE% ^| findstr /C:"Current DC Power Setting Index"') do (
    set "DC_RAW=%%A"
)

set "AC_RAW=!AC_RAW: =!"
set "DC_RAW=!DC_RAW: =!"

if not defined AC_RAW set "AC_RAW=0xffffffff"
if not defined DC_RAW set "DC_RAW=0xffffffff"

set /a AC_DEC=!AC_RAW! 2>nul
set /a DC_DEC=!DC_RAW! 2>nul

exit /b

:ModeName
set "VAL=%~1"
set "%~2=Unknown"
if "%VAL%"=="0" set "%~2=Disabled"
if "%VAL%"=="1" set "%~2=Enabled"
if "%VAL%"=="2" set "%~2=Aggressive"
if "%VAL%"=="3" set "%~2=Efficient Enabled"
if "%VAL%"=="4" set "%~2=Efficient Aggressive"
if "%VAL%"=="5" set "%~2=Aggressive at Guaranteed"
if "%VAL%"=="6" set "%~2=Efficient Aggressive at Guaranteed"
exit /b

:END
echo.
echo No changes made.
pause
endlocal
exit /b
