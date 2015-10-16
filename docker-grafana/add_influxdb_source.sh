#!/bin/bash
set -e

if [ "${INFLUXDB_HOST}" = "**ChangeMe**" ] || \
        [ "${INFLUXDB_PORT}" = "**ChangeMe**" ] || \
        [ "${INFLUXDB_NAME}" = "**ChangeMe**" ]; then
    echo "=> Required environment variables for initial InfluxDB are not specified!"
    echo "=> Aborting initial setup."
    exit 0
fi

DAEMON_RETRIES=5

add_influxdb_source() {
    local code success payload
    success=0
    for i in $(eval echo "{1..$DAEMON_RETRIES}"); do
        sleep 1
        code=$(curl "http://admin:admin@localhost:3000/api/datasources" 2>/dev/null)
        if [ $? -eq 0 ] && [[ ! "${code}" =~ "404" ]]; then
            success=1
            break
        fi
    done
    if [ ${success} -ne 1 ]; then
        echo "=> Failed to configure InfluxDB!"
        echo "Could not find running Grafana instance."
        exit 1
    fi

    read -r -d '' payload <<- EOP
    {
        "name":      "${GRAFANA_INFLUXDB_SOURCE_NAME}",
        "type":      "influxdb",
        "url":       "${INFLUXDB_PROTO}://${INFLUXDB_HOST}:${INFLUXDB_PORT}",
        "access":    "proxy",
        "basicAuth": false,
        "database":  "${INFLUXDB_NAME}",
        "user":      "${INFLUXDB_USER}",
        "pass":      "${INFLUXDB_PASS}",
        "isDefault": true
    }
EOP

    code=$(curl "http://admin:admin@localhost:3000/api/datasources" \
            -X POST \
            -H 'Content-Type: application/json;charset=UTF-8' \
            --data-binary "${payload}" 2>/dev/null)

    if [ $? -eq 1 ] || [[ "${code}" =~ "404" ]]; then
        echo "=> Failed to configure InfluxDB!"
        echo "Response: ${code}"
        exit 1
    fi

    echo "=> InfluxDB has been configured as follows:"
    echo "   InfluxDB ADDRESS:  ${INFLUXDB_HOST}"
    echo "   InfluxDB PORT:     ${INFLUXDB_PORT}"
    echo "   InfluxDB DB NAME:  ${INFLUXDB_NAME}"
    echo "   InfluxDB USERNAME: ${INFLUXDB_USER}"
    echo "   InfluxDB PASSWORD: ${INFLUXDB_PASS}"
    echo "   ** Please check your environment variables if you find something is misconfigured. **"
}

echo "=> Spawning daemon to hit Grafana API. (Will retry ${DAEMON_RETRIES} times)"

set +e
add_influxdb_source &
