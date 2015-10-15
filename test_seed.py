from influxdb import client as idb
from datetime import datetime, timedelta
from random import random
import os

client = idb.InfluxDBClient("192.168.99.100", 8086,
                            os.getenv("E2_INFLUXDB_ADMIN_USER") or "root",
                            os.getenv("E2_INFLUXDB_INIT_PWD") or "root",
                            os.getenv("E2_INFLUXDB_NAME") or "e2_influxdb")

# modified from https://github.com/influxdb/influxdb-python
now = datetime.utcnow()
minutes = 120
test_data = []
for i in range(minutes):
    test_data.append({
        'measurement': 'cpu_load_short',
        'time': (now - timedelta(minutes=i)),
        'fields': {
            'value': random()
        }
    })

if client.write_points(test_data, tags={'host': 'server01', 'region': 'us-west'}):
    print 'Success!'
