@echo off
setlocal enabledelayedexpansion

echo Starting Nuitka build...
set "STARTTIME=%TIME%"

python -m nuitka ^
    --standalone ^
    --enable-plugin=tk-inter ^
    --nofollow-import-to=tkinter ^
    --output-dir=build ^
    --remove-output ^
    main.py

set "ENDTIME=%TIME%"

rem --- Convert times to hundredths of a second ---
for /f "tokens=1-4 delims=:.," %%a in ("%STARTTIME%") do (
    set /a "start=(((%%a*60)+%%b)*60+%%c)*100+%%d"
)
for /f "tokens=1-4 delims=:.," %%a in ("%ENDTIME%") do (
    set /a "end=(((%%a*60)+%%b)*60+%%c)*100+%%d"
)

rem Handle midnight wrap
if %end% lss %start% set /a end+=24*60*60*100

set /a elapsed=%end%-%start%
set /a hh=%elapsed% / 360000, rem=%elapsed% %% 360000
set /a mm=%rem% / 6000, rem=%rem% %% 6000
set /a ss=%rem% / 100, cs=%rem% %% 100

echo.
echo ======================================
echo Build completed.
echo Elapsed time: !hh!h !mm!m !ss!.!cs!s
echo ======================================

endlocal
