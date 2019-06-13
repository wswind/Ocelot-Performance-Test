# Ocelot Performance Test

this is a demo to test ocelot performance.

use .net core 2.2 sdk and windows 10 1809 with wsl ubuntu

inspired by:
<https://www.cnblogs.com/savorboard/p/wrk.html>


## use powershell to run all projects:

```
./run-all.ps1
```

you may want to set powershell execution policy

```
Set-ExecutionPolicy -Scope CurrentUser remotesigned
```
| ip             | discription |
| -------------- | ------ |
| localhost:5000 | ocelot |
| localhost:5001 | api1 |
| localhost:5002 | api2 |

http://localhost:5000/api1/values -> http://localhost:5001/api/values

http://localhost:5000/api2/values -> http://localhost:5002/api/values



## use ab to test

use wsl ubuntu to test

install ab
```
sudo apt-get install apache2-utils
```

test the site
```
ab -n 10000 -c 10 http://localhost:5001/api/values
ab -n 10000 -c 10 http://localhost:5000/api1/values

ab -n 10000 -c 10 http://localhost:5002/api/values
ab -n 10000 -c 10 http://localhost:5000/api2/values
```

results:
```
Server Software:        Kestrel
Server Hostname:        localhost
Server Port:            5001

Document Path:          /api/values
Document Length:        19 bytes

Concurrency Level:      10
Time taken for tests:   2.656 seconds
Complete requests:      10000
Failed requests:        0
Total transferred:      1580000 bytes
HTML transferred:       190000 bytes
Requests per second:    3764.57 [#/sec] (mean)
Time per request:       2.656 [ms] (mean)
Time per request:       0.266 [ms] (mean, across all concurrent requests)
Transfer rate:          580.86 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   1.0      1      15
Processing:     0    2   1.3      1      16
Waiting:        0    1   1.1      1      15
Total:          1    3   1.6      2      16
```
```
Server Software:        Kestrel
Server Hostname:        localhost
Server Port:            5000

Document Path:          /api1/values
Document Length:        19 bytes

Concurrency Level:      10
Time taken for tests:   3.273 seconds
Complete requests:      10000
Failed requests:        0
Total transferred:      1780000 bytes
HTML transferred:       190000 bytes
Requests per second:    3055.38 [#/sec] (mean)
Time per request:       3.273 [ms] (mean)
Time per request:       0.327 [ms] (mean, across all concurrent requests)
Transfer rate:          531.11 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   1.0      1      17
Processing:     1    2   1.5      2      26
Waiting:        1    2   1.3      1      26
Total:          2    3   1.8      3      27

Percentage of the requests served within a certain time (ms)
  50%      3
  66%      3
  75%      3
  80%      3
  90%      4
  95%      5
  98%     11
  99%     13
 100%     27 (longest request)
```

```
Server Software:        Kestrel
Server Hostname:        localhost
Server Port:            5002

Document Path:          /api/values
Document Length:        19 bytes

Concurrency Level:      10
Time taken for tests:   2.664 seconds
Complete requests:      10000
Failed requests:        0
Total transferred:      1580000 bytes
HTML transferred:       190000 bytes
Requests per second:    3754.24 [#/sec] (mean)
Time per request:       2.664 [ms] (mean)
Time per request:       0.266 [ms] (mean, across all concurrent requests)
Transfer rate:          579.27 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   1.0      1      15
Processing:     0    2   1.3      1      16
Waiting:        0    1   1.2      1      15
Total:          1    3   1.6      2      29

Percentage of the requests served within a certain time (ms)
  50%      2
  66%      2
  75%      2
  80%      2
  90%      3
  95%      3
  98%     10
  99%     13
 100%     29 (longest request)
```
```
Server Software:        Kestrel
Server Hostname:        localhost
Server Port:            5000

Document Path:          /api2/values
Document Length:        19 bytes

Concurrency Level:      10
Time taken for tests:   3.284 seconds
Complete requests:      10000
Failed requests:        0
Total transferred:      1780000 bytes
HTML transferred:       190000 bytes
Requests per second:    3045.52 [#/sec] (mean)
Time per request:       3.284 [ms] (mean)
Time per request:       0.328 [ms] (mean, across all concurrent requests)
Transfer rate:          529.40 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   0.9      1      15
Processing:     1    2   1.4      2      18
Waiting:        0    2   1.2      1      16
Total:          1    3   1.6      3      19

Percentage of the requests served within a certain time (ms)
  50%      3
  66%      3
  75%      3
  80%      3
  90%      4
  95%      4
  98%      9
  99%     13
 100%     19 (longest request)
```