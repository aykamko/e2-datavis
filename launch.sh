# run influxdb docker
docker run -d --name influxdb -p 8083:8083 -p 8086:8086 \
    -e ADMIN_USER="${E2_INFLUXDB_ADMIN_USER:-root}" \
    -e INFLUXDB_INIT_PWD="${E2_INFLUXDB_INIT_PWD:-root}" \
    -e PRE_CREATE_DB="${E2_INFLUXDB_NAME:-e2_influxdb}" \
    tutum/influxdb:latest

# run grafana docker
docker run -d --name grafana -p 8080:3000 \
    --link influxdb:influxdbhost \
    -v $(echo "$(pwd)/${E2_GRAFANA_SQLITE_MOUNT:-grafanadb}"):/var/lib/grafana \
    -e INFLUXDB_HOST=influxdbhost \
    -e INFLUXDB_PORT=8086 \
    -e INFLUXDB_NAME="${E2_INFLUXDB_NAME:-e2_influxdb}" \
    -e INFLUXDB_USER="${E2_INFLUXDB_ADMIN_USER:-root}" \
    -e INFLUXDB_PASS="${E2_INFLUXDB_INIT_PWD:-root}" \
    -e GRAFANA_INFLUXDB_SOURCE_NAME="${E2_GRAFANA_INFLUXDB_SOURCE_NAME:-E2}" \
    aykamko/e2-grafana:latest
