from influxdb import client as idb
from datetime import datetime, timedelta
from random import random, randint
import os

client = idb.InfluxDBClient("192.168.99.100", 8086,
                            os.getenv("E2_INFLUXDB_ADMIN_USER") or "root",
                            os.getenv("E2_INFLUXDB_INIT_PWD") or "root",
                            os.getenv("E2_INFLUXDB_NAME") or "e2_influxdb")

# modified from https://github.com/influxdb/influxdb-python
now = datetime.utcnow()
minutes = (60 * 10)

machines = ['machine%d' % i for i in range(1, 11)]
for machine in machines:
    test_data = []
    nf_base = randint(3, 6)
    for i in range(minutes):
        test_data.append({
            'measurement': 'cpu_load_short',
            'time': (now - timedelta(minutes=i)),
            'fields': {
                'value': random()
            }
        })
        test_data.append({
            'measurement': 'nf_instances',
            'time': (now - timedelta(minutes=i)),
            'fields': {
                'value': nf_base + randint(-1, 1),
            }
        })
        for v in range(10):
            test_data.append({
                'measurement': 'throughput_bytes',
                'time': (now - timedelta(minutes=i)),
                'fields': {
                    'value': 1000000 * random()
                },
                'tags': {
                    'vport_num': str(v)
                }
            })
            test_data.append({
                'measurement': 'throughput_packets',
                'time': (now - timedelta(minutes=i)),
                'fields': {
                    'value': 100 * random()
                },
                'tags': {
                    'vport_num': str(v)
                }
            })
            test_data.append({
                'measurement': 'queue_length',
                'time': (now - timedelta(minutes=i)),
                'fields': {
                    'value': randint(0, 4)
                },
                'tags': {
                    'vport_num': str(v)
                }
            })
    client.write_points(test_data, tags={'machine': machine})

print 'Done!'
