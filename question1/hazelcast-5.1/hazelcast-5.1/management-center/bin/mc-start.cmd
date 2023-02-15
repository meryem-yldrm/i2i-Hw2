@ECHO OFF
SETLOCAL
CD %~p0
CD ..

REM ECHO %*

REM Skipping JAVA_OPTS_DEFAULT handling, that's docker-only

if "%LOGGING_LEVEL%" NEQ "" (
    SET JAVA_OPTS=-Dhazelcast.mc.log.level=%LOGGING_LEVEL% %JAVA_OPTS%
)

SET JAVA_OPTS=%* %JAVA_OPTS%

IF "%CONTAINER_SUPPORT%"=="" (
    SET CONTAINER_SUPPORT=true
)

ECHO Container support disabled. Using manual heap sizing by specifying MIN_HEAP_SIZE, MAX_HEAP_SIZE or custom settings configured by JAVA_OPTS.
IF "%MIN_HEAP_SIZE%" NEQ "" (
    SET JAVA_OPTS=%JAVA_OPTS% -Xms%MIN_HEAP_SIZE%
)
IF "%MAX_HEAP_SIZE%" NEQ "" (
    SET JAVA_OPTS=%JAVA_OPTS% -Xms%MAX_HEAP_SIZE%
)

SET MC_RUNTIME=hazelcast-management-center-5.1.1.jar
SET USER_LIB=./bin/user-lib/*

IF "%MC_CLASSPATH%" NEQ "" (
    SET MC_CLASSPATH=%MC_RUNTIME%;%MC_CLASSPATH%;%USER_LIB%
) ELSE (
    SET MC_CLASSPATH=%MC_RUNTIME%;%USER_LIB%
)


REM Skipping MC_INIT_CMD , no reliable way to run it on Windows

if "%MC_INIT_SCRIPT%" NEQ "" (
   ECHO Executing command specified by MC_INIT_SCRIPT.
   CALL  %MC_INIT_SCRIPT%
)

if "%MC_ADMIN_USER%" NEQ "" (
    IF "%MC_ADMIN_PASSWORD%" NEQ "" (
        ECHO Creating admin user.
        bin/mc-conf.bat user create --lenient=true -n="%MC_ADMIN_USER%" -p="%MC_ADMIN_PASSWORD%" -r=admin
        IF ERRORLEVEL 1 (
            ECHO "Failed to create user %MC_ADMIN_USER%"
            EXIT 1
        ) ELSE (
            ECHO "User %MC_ADMIN_USER% was created successfully."
        )
    )
)


FOR /F "tokens=* USEBACKQ" %%F IN (`CALL java -cp "hazelcast-management-center-5.1.1.jar" com.hazelcast.internal.util.JavaVersion`) DO SET JAVA_VERSION=%%F

IF NOT "%JAVA_VERSION%" == "8" (
	set JAVA_OPTS=--add-opens java.base/java.lang=ALL-UNNAMED %JAVA_OPTS%
)

java -server %JAVA_OPTS% -cp %MC_CLASSPATH% com.hazelcast.webmonitor.Launcher
