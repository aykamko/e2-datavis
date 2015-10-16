FROM phusion/baseimage:0.9.17

ENV GRAFANA_VERSION 2.1.3

RUN apt-get update && \
    apt-get -y install libfontconfig curl adduser openssl ca-certificates sqlite3 && \
    apt-get clean && \
    curl -o /tmp/grafana.deb https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb -O && \
    dpkg -i /tmp/grafana.deb && \
    rm /tmp/grafana.deb

RUN mkdir -p /etc/service/grafana
ADD grafana_runit /etc/service/grafana/run

ENV INFLUXDB_PROTO http
ENV INFLUXDB_HOST **ChangeMe**
ENV INFLUXDB_PORT **ChangeMe**
ENV INFLUXDB_NAME **ChangeMe**
ENV INFLUXDB_USER root
ENV INFLUXDB_PASS root
ENV GRAFANA_INFLUXDB_SOURCE_NAME E2

ADD init_influxdb.sql /tmp/init_influxdb.sql

RUN mkdir -p /etc/my_init.d
# prefix with z so it runs last, after grafana startup (since init.d scripts run in lexicographic order)
ADD add_influxdb_source.sh /etc/my_init.d/z_add_influxdb_source.sh

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

CMD ["/sbin/my_init"]

EXPOSE 3000
