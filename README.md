# Ocelot Performance Test

this is a demo to test ocelot performance.

use .net core 3.1 sdk and ab(apache benchmark)

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


http://localhost:5000/api1/values -> http://localhost:5001/api/values


## use ab to test

install ab on ubuntu/debian

```
apt install apache2-utils
```

install ab on centos

```
yum install httpd-tools -y

```

test the performance

```
ab -n 20000 -c 1000 http://localhost:5001/api/values


Server Software:        Kestrel
Server Hostname:        localhost
Server Port:            5001

Document Path:          /api/values
Document Length:        19 bytes

Concurrency Level:      1000
Time taken for tests:   15.992 seconds
Complete requests:      20000
Failed requests:        0
Total transferred:      3160000 bytes
HTML transferred:       380000 bytes
Requests per second:    1250.66 [#/sec] (mean)
Time per request:       799.575 [ms] (mean)
Time per request:       0.800 [ms] (mean, across all concurrent requests)
Transfer rate:          192.97 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0  382  49.0    384     533
Processing:    29  407  80.6    402     782
Waiting:        4  347  69.8    353     532
Total:        174  789  81.8    784    1139

Percentage of the requests served within a certain time (ms)
  50%    784
  66%    802
  75%    815
  80%    822
  90%    836
  95%    887
  98%   1071
  99%   1121
 100%   1139 (longest request)


ab -n 20000 -c 1000 http://localhost:5000/api1/values


Server Software:        Kestrel
Server Hostname:        localhost
Server Port:            5000

Document Path:          /api1/values
Document Length:        19 bytes

Concurrency Level:      1000
Time taken for tests:   40.206 seconds
Complete requests:      20000
Failed requests:        0
Total transferred:      3560000 bytes
HTML transferred:       380000 bytes
Requests per second:    497.44 [#/sec] (mean)
Time per request:       2010.278 [ms] (mean)
Time per request:       2.010 [ms] (mean, across all concurrent requests)
Transfer rate:          86.47 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   40  88.4      4     517
Processing:   250 1910 429.2   1949    5421
Waiting:      173 1851 413.0   1926    5266
Total:        345 1950 406.6   1955    5549

Percentage of the requests served within a certain time (ms)
  50%   1955
  66%   1987
  75%   2008
  80%   2019
  90%   2050
  95%   2353
  98%   3574
  99%   3643
 100%   5549 (longest request)
```
Test results vary according to machine environment.