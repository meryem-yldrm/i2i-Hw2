#!/bin/sh

cd "$(dirname "$0")" && cd ..

#Management Center Docker container passes JAVA_OPTS_DEFAULT
if [ -n "${JAVA_OPTS}" ]; then
    export JAVA_OPTS="${JAVA_OPTS_DEFAULT} ${JAVA_OPTS}"
else
    export JAVA_OPTS="${JAVA_OPTS_DEFAULT}"
fi

java $JAVA_OPTS -cp hazelcast-management-center-5.1.1.jar com.hazelcast.webmonitor.cli.MCConfCommandLine "$@"
