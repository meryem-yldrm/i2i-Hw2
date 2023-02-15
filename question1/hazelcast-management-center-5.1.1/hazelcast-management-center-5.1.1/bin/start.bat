@ECHO OFF
echo Warning: start.bat is deprecated. Please use mc-start.cmd instead.
cd %~dp0 && cd ..

set argC=0
for %%x in (%*) do Set /A argC+=1
set help=false

if %argC% gtr 3 set help=true
if %argC% equ 1 (
    if "%1" == "--help" (
        set help=true
    )
)

if %help% == true (
    echo usage: start.bat
    echo usage: start.bat [port]
    echo usage: start.bat [port] [path]
    echo usage: start.bat [port] [path] [classpath]
    exit /b
)

if %argC% == 3 (
    java %JAVA_OPTS% -Dhazelcast.mc.http.port=%1 -Dhazelcast.mc.contextPath=%2 -cp "hazelcast-management-center-5.1.1.jar;%3" com.hazelcast.webmonitor.Launcher
)

if %argC% == 2 (
    java %JAVA_OPTS% -Dhazelcast.mc.http.port=%1 -Dhazelcast.mc.contextPath=%2 -cp "hazelcast-management-center-5.1.1.jar" com.hazelcast.webmonitor.Launcher
)

if %argC% == 1 (
    java %JAVA_OPTS% -Dhazelcast.mc.http.port=%1 -cp "hazelcast-management-center-5.1.1.jar" com.hazelcast.webmonitor.Launcher
)

if %argC% == 0 (
    java %JAVA_OPTS% -cp "hazelcast-management-center-5.1.1.jar" com.hazelcast.webmonitor.Launcher
)
