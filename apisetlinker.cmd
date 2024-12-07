@echo off
setlocal enabledelayedexpansion

REM to debug this: set RUSTC_LOG=rustc_codegen_ssa::back::link=info
if "%1" == "" goto args_count_wrong
if not "%2" == "" goto args_count_wrong

REM Remove the leading "@" character from the response file command line argument
set responsefile=%1
set responsefile=%responsefile:~1%

REM Remove the byte-order-mark from the answer file as it causes "for" to misbehave and not read the file
set responsefilenobom=%responsefile%-nobom
type %responsefile% > %responsefilenobom%

REM Clear the new response file
set newresponsefile=%responsefile%-filtered
cmd /c del %newresponsefile%

REM Include configurable additional arguments to the linker in linker_args.txt
for /F "tokens=*" %%I in  (%~dp0\linker-args.txt) do  (
   set LINE=%%I
   echo !LINE! >> %newresponsefile%
)

for /F "tokens=*" %%I in  (%responsefilenobom%) do  (
   set LINE=%%I
   REM remove lines that end in .lib with a closing quote, which are system libraries or the windows-targets library
   set CONDITION=!LINE:.lib"=replacement!
   if x!CONDITION! == x!LINE! echo !LINE! >> %newresponsefile%
)

REM If you'd like to diagnose the before or after of the linker arguments, uncomment the next two lines
REM cmd /c copy %responsefile%    %~dp0\diagnosis-before
REM cmd /c copy %newresponsefile% %~dp0\diagnosis-after

REM where link.exe
link.exe @%newresponsefile%
goto :EOF

:args_count_wrong
echo Need a single response-file argument
exit /b 1
