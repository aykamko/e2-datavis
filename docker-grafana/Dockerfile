FROM phusion/baseimage:0.9.17

ENV GRAFANA_VERSION 2.1.3

RUN apt-get update && \
    apt-get -y install libfontconfig wget adduser openssl ca-certificates sqlite3 && \
    apt-get clean && \
    wget https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb -O /tmp/grafana.deb && \
    dpkg -i /tmp/grafana.deb && \
    rm /tmp/grafana.deb

RUN mkdir /etc/service/grafana
ADD grafana_runit /etc/service/grafana/run

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

CMD ["/sbin/my_init"]

EXPOSE 3000
