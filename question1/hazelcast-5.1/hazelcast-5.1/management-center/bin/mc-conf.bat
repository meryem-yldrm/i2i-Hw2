@ECHO OFF

cd %~dp0 && cd ..

java %JAVA_OPTS% -cp hazelcast-management-center-5.1.1.jar com.hazelcast.webmonitor.cli.MCConfCommandLine %*
