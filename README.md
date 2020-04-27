# Ocelot Performance Test

this is a demo to test ocelot performance.

use .net core 3.1 sdk

use nginx-1.18.0 on windows, configure nginx proxy for compare test:

```
server {
        listen       80;
        server_name  _;

        location /api1/ {
            proxy_pass         http://localhost:5001/api/;
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




Debian wsl for nginx proxy test has an error: apr_socket_recv: Transport endpoint is not connected (107) . So I changed to use a linux vm to run the tests.

set linux(centos) open file limits

```
ulimit -n 65535

#/etc/security/limits.conf

* soft nofile 65535
* hard nofile 65535
```


inspired by:

<https://www.cnblogs.com/myzony/p/10401298.html>

## use cmd to run all projects:

```
run.cmd
```


| url             | discription |
| -------------- | ------ |
| localhost:5000 | ocelot |
| localhost:5001 | api1 |
| localhost:80 | nginx |


http://localhost:5000/api1/values -> http://localhost:5001/api/values

http://localhost/api1/values -> http://localhost:5001/api/values

## use ab to test

install ab

```
#centos
yum install httpd-tools -y

#ubuntu/debian
apt install apache2-utils -y
```


test the performance without proxy
```
ab -n 20000 -c 1000 http://192.168.56.1:5001/api/values


Server Software:        Kestrel
Server Hostname:        192.168.56.1
Server Port:            5001

Document Path:          /api/values
Document Length:        19 bytes

Concurrency Level:      1000
Time taken for tests:   3.306 seconds
Complete requests:      20000
Failed requests:        0
Write errors:           0
Total transferred:      3160000 bytes
HTML transferred:       380000 bytes
Requests per second:    6049.09 [#/sec] (mean)
Time per request:       165.314 [ms] (mean)
Time per request:       0.165 [ms] (mean, across all concurrent requests)
Transfer rate:          933.36 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   76 336.5     12    3031
Processing:     0   26  27.9     15     345
Waiting:        0   26  27.5     15     345
Total:          1  102 340.2     29    3086

Percentage of the requests served within a certain time (ms)
  50%     29
  66%     31
  75%     38
  80%     46
  90%    101
  95%    256
  98%   1080
  99%   1106
 100%   3086 (longest request)

```

use ocelot for proxy
```
ab -n 20000 -c 1000 http://192.168.56.1:5000/api1/values

Server Software:        Kestrel
Server Hostname:        192.168.56.1
Server Port:            5000

Document Path:          /api1/values
Document Length:        19 bytes

Concurrency Level:      1000
Time taken for tests:   3.796 seconds
Complete requests:      20000
Failed requests:        0
Write errors:           0
Total transferred:      3560000 bytes
HTML transferred:       380000 bytes
Requests per second:    5268.93 [#/sec] (mean)
Time per request:       189.792 [ms] (mean)
Time per request:       0.190 [ms] (mean, across all concurrent requests)
Transfer rate:          915.89 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0  103 332.1     10    3019
Processing:     4   54  43.2     41     465
Waiting:        1   50  42.3     38     465
Total:          8  157 339.4     53    3114

Percentage of the requests served within a certain time (ms)
  50%     53
  66%     76
  75%     97
  80%    115
  90%    187
  95%   1070
  98%   1122
  99%   1137
 100%   3114 (longest request)
```

use nginx for proxy

```
ab -n 20000 -c 1000 http://192.168.56.1/api1/values

Server Software:        nginx/1.18.0
Server Hostname:        192.168.56.1
Server Port:            80

Document Path:          /api1/values
Document Length:        494 bytes

Concurrency Level:      1000
Time taken for tests:   4.570 seconds
Complete requests:      20000
Failed requests:        0
Write errors:           0
Non-2xx responses:      20000
Total transferred:      13360000 bytes
HTML transferred:       9880000 bytes
Requests per second:    4376.38 [#/sec] (mean)
Time per request:       228.500 [ms] (mean)
Time per request:       0.228 [ms] (mean, across all concurrent requests)
Transfer rate:          2854.90 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0  123 494.7      0    3010
Processing:    14   42  20.4     37     209
Waiting:        1   42  20.4     37     209
Total:         17  166 495.0     37    3057

Percentage of the requests served within a certain time (ms)
  50%     37
  66%     41
  75%     42
  80%     43
  90%    128
  95%   1044
  98%   3044
  99%   3047
 100%   3057 (longest request)

```
The ab test with ocelot or nginx proxy could be slower at the first time. But it would be faster and faster when you run multi times. So the first time test result is not included.

Test results varies according to machine environment

