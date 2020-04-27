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
Time taken for tests:   15.410 seconds
Complete requests:      20000
Failed requests:        0
Total transferred:      3160000 bytes
HTML transferred:       380000 bytes
Requests per second:    1297.83 [#/sec] (mean)
Time per request:       770.516 [ms] (mean)
Time per request:       0.771 [ms] (mean, across all concurrent requests)
Transfer rate:          200.25 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0  358  85.9    364     537
Processing:    28  404 108.1    391    1324
Waiting:        7  345 106.1    344     970
Total:        196  762  75.9    761    1664

Percentage of the requests served within a certain time (ms)
  50%    761
  66%    769
  75%    776
  80%    784
  90%    850
  95%    859
  98%    940
  99%    958
 100%   1664 (longest request)


ab -n 20000 -c 1000 http://localhost:5000/api1/values


Server Software:        Kestrel
Server Hostname:        localhost
Server Port:            5000

Document Path:          /api1/values
Document Length:        19 bytes

Concurrency Level:      1000
Time taken for tests:   37.893 seconds
Complete requests:      20000
Failed requests:        0
Total transferred:      3560000 bytes
HTML transferred:       380000 bytes
Requests per second:    527.80 [#/sec] (mean)
Time per request:       1894.652 [ms] (mean)
Time per request:       1.895 [ms] (mean, across all concurrent requests)
Transfer rate:          91.75 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   67 121.4      5     539
Processing:   180 1743 770.9   1760    8078
Waiting:       13 1663 721.7   1735    7660
Total:        180 1809 723.6   1773    8087

Percentage of the requests served within a certain time (ms)
  50%   1773
  66%   1813
  75%   1846
  80%   1861
  90%   2067
  95%   3140
  98%   3828
  99%   5259
 100%   8087 (longest request)
```
Test results vary according to machine environment.