# Ocelot Performance Test

this is a demo to test ocelot performance.

use .net core 3.1 sdk

use apache bench for load test 

wsl for nginx proxy test has an error: apr_socket_recv: Transport endpoint is not connected (107) . So I changed to use a linux vm to run the tests.

host ip : 192.168.56.1
vm ip : 192.168.56.10

set linux(centos) open file limits

```
ulimit -n 65535

#/etc/security/limits.conf

* soft nofile 65535
* hard nofile 65535
```

use nginx on centos, configure proxy for compare test:

```
/etc/nginx/conf.d/abtest.conf

server {
        listen       5010;
        server_name  _;

        location /api1/ {
            proxy_pass         http://192.168.56.1:5001/api/;
            proxy_http_version 1.1;
            proxy_set_header   Upgrade $http_upgrade;
            proxy_set_header   Connection keep-alive;
            proxy_set_header   Host $host;
            proxy_cache_bypass $http_upgrade;
            proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header   X-Forwarded-Proto $scheme;
        }
    }
```


inspired by:

<https://www.cnblogs.com/myzony/p/10401298.html>

## use cmd to run all projects:

```
run.cmd
```


| url             | discription |
| -------------- | ------ |
| 192.168.56.1:5000 | ocelot |
| 192.168.56.1:5001 | api1 |
| 192.168.56.10:5010 | nginx |


http://192.168.56.1:5000/api1/values -> http://192.168.56.1:5001/api/values

http://192.168.56.10:5010/api1/values -> http://192.168.56.1:5001/api/values

## use ab to test

install ab

```
#centos
yum install httpd-tools -y

#ubuntu/debian
apt install apache2-utils -y
```

test commands:

```
#without proxy
ab -n 20000 -c 1000 http://192.168.56.1:5001/api/values
#ocelot
ab -n 20000 -c 1000 http://192.168.56.1:5000/api1/values
#nginx
ab -n 20000 -c 1000 http://192.168.56.10:5010/api1/values
```


test the performance without proxy

```
Server Software:        Kestrel
Server Hostname:        192.168.56.1
Server Port:            5001

Document Path:          /api/values
Document Length:        19 bytes

Concurrency Level:      1000
Time taken for tests:   3.339 seconds
Complete requests:      20000
Failed requests:        0
Write errors:           0
Total transferred:      3160000 bytes
HTML transferred:       380000 bytes
Requests per second:    5989.33 [#/sec] (mean)
Time per request:       166.964 [ms] (mean)
Time per request:       0.167 [ms] (mean, across all concurrent requests)
Transfer rate:          924.13 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0  115 308.9     13    1060
Processing:     2   25  18.9     19     172
Waiting:        1   25  18.9     18     172
Total:          3  141 319.1     30    1154
```

use ocelot for proxy
```
Server Software:        Kestrel
Server Hostname:        192.168.56.1
Server Port:            5000

Document Path:          /api1/values
Document Length:        19 bytes

Concurrency Level:      1000
Time taken for tests:   3.772 seconds
Complete requests:      20000
Failed requests:        0
Write errors:           0
Total transferred:      3560000 bytes
HTML transferred:       380000 bytes
Requests per second:    5301.72 [#/sec] (mean)
Time per request:       188.618 [ms] (mean)
Time per request:       0.189 [ms] (mean, across all concurrent requests)
Transfer rate:          921.59 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0  110 305.4      9    3019
Processing:     5   45  30.1     37     245
Waiting:        1   44  29.8     36     238
Total:         11  155 312.5     46    3078

Percentage of the requests served within a certain time (ms)
  50%     46
  66%     60
  75%     78
  80%     89
  90%    191
  95%   1066
  98%   1120
  99%   1147
 100%   3078 (longest request)
```

use nginx for proxy (have Non-2xx responses with 502 status code , I don't know why)

```
Server Software:        nginx/1.16.1
Server Hostname:        192.168.56.10
Server Port:            5010

Document Path:          /api1/values
Document Length:        19 bytes

Concurrency Level:      1000
Time taken for tests:   4.889 seconds
Complete requests:      20000
Failed requests:        31
   (Connect: 0, Receive: 0, Length: 31, Exceptions: 0)
Write errors:           0
Non-2xx responses:      31
Total transferred:      3265456 bytes
HTML transferred:       384898 bytes
Requests per second:    4090.92 [#/sec] (mean)
Time per request:       244.444 [ms] (mean)
Time per request:       0.244 [ms] (mean, across all concurrent requests)
Transfer rate:          652.28 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   77 312.6      3    3018
Processing:     0   88 217.7     30    1158
Waiting:        0   85 218.0     28    1158
Total:          0  165 381.8     33    3070

```

The ab test with ocelot proxy could be very slow at the first time. But it would be faster and faster when you run it multi times. So the first time test result is not included.

Test results varies according to machine environment

