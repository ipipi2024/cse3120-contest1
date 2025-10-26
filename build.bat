@echo off
REM Build script for Blackjack Assembly Project
REM Requires: MASM32 or Visual Studio with MASM installed

echo Building main.asm...

REM Assemble the .asm file
ml /c /coff /Zi main.asm
if errorlevel 1 goto error

echo Linking...
REM Link with Irvine32 library
link /SUBSYSTEM:CONSOLE main.obj Irvine32.lib kernel32.lib
if errorlevel 1 goto error

echo Build successful! Run main.exe to test.
goto end

:error
echo Build failed! Make sure MASM and Irvine32 library are installed.
pause

:end
