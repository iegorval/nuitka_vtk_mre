@echo off
setlocal enabledelayedexpansion

echo Starting Nuitka build...
set "STARTTIME=%TIME%"

pip freeze

python -m nuitka ^
    --standalone ^
    --enable-plugin=tk-inter ^
    --nofollow-import-to=tkinter ^
    --output-dir=build ^
    --remove-output ^
    main.py

set "ENDTIME=%TIME%"

rem --- Parse time (remove leading spaces and handle both . and , separators) ---
for /f "tokens=1-4 delims=:., " %%a in ("%STARTTIME%") do (
    set "h=%%a"
    set "m=%%b"
    set "s=%%c"
    set "cs=%%d"
)
for /f "tokens=1-4 delims=:., " %%a in ("%ENDTIME%") do (
    set "h2=%%a"
    set "m2=%%b"
    set "s2=%%c"
    set "cs2=%%d"
)

rem --- Remove possible leading spaces ---
for %%v in (h m s cs h2 m2 s2 cs2) do (
    set "val=!%%v!"
    for /f "tokens=* delims= " %%x in ("!val!") do set "%%v=%%x"
)

rem --- Convert to hundredths of a second ---
set /a "start=((h*60+m)*60+s)*100+cs"
set /a "end=((h2*60+m2)*60+s2)*100+cs2"

rem --- Handle midnight wrap ---
if !end! lss !start! set /a end+=24*360000

set /a elapsed=!end!-!start!
set /a hh=!elapsed!/360000, rem=!elapsed!%%360000
set /a mm=!rem!/6000, rem=!rem!%%6000
set /a ss=!rem!/100, cs=!rem!%%100

echo.
echo ======================================
echo Build completed.
echo Elapsed time: !hh!h !mm!m !ss!.!cs!s
echo ======================================

endlocal
