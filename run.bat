@echo off
setlocal

:: Check if mvn is directly available in PATH
where mvn >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [Campus System] Launching application...
    mvn exec:java
    goto :end
)

:: Otherwise check portable tools directory
set "PORTABLE_JDK=%USERPROFILE%\.tools\jdk-17.0.20.1+1"
set "PORTABLE_MVN=%USERPROFILE%\.tools\apache-maven-3.9.6"

if exist "%PORTABLE_MVN%\bin\mvn.cmd" (
    echo [Campus System] Launching application with portable JDK 17...
    set "JAVA_HOME=%PORTABLE_JDK%"
    set "M2_HOME=%PORTABLE_MVN%"
    set "PATH=%PORTABLE_JDK%\bin;%PORTABLE_MVN%\bin;%PATH%"
    call "%PORTABLE_MVN%\bin\mvn.cmd" exec:java
    goto :end
)

echo [ERROR] Neither Maven nor portable tools were found.

:end
endlocal
