@echo off
setlocal

:: wmic /format:list strips trailing spaces (at least for path win32_pnpentity)
for /f "tokens=1* delims==" %%I in ('wmic path win32_pnpentity get caption  /format:list ^| find "Arduino Leonardo bootloader"') do (
    call :setCOM "%%~J"
)

:: end main batch
goto :EOF

:setCOM <WMIC_output_line>
:: sets _COM#=line
setlocal
set "str=%~1"
set "num=%str:*(COM=%"
set "num=%num:)=%"
set port=COM%num%
echo %port%
goto :flash

:flash
avrdude -v -C./avrdude.conf -patmega32u4 -cavr109 -P%port% -b57600 -D -V -Uflash:w:./firmware.hex:i