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

test the performance
```
ab -n 100000 -c 10 http://localhost:5001/api/values

Concurrency Level:      10
Time taken for tests:   28.441 seconds
Complete requests:      100000
Failed requests:        0
Total transferred:      15800000 bytes
HTML transferred:       1900000 bytes
Requests per second:    3516.01 [#/sec] (mean)
Time per request:       2.844 [ms] (mean)
Time per request:       0.284 [ms] (mean, across all concurrent requests)
Transfer rate:          542.51 [Kbytes/sec] received

ab -n 100000 -c 10 http://localhost:5000/api1/values

Concurrency Level:      10
Time taken for tests:   34.166 seconds
Complete requests:      100000
Failed requests:        0
Total transferred:      17800000 bytes
HTML transferred:       1900000 bytes
Requests per second:    2926.88 [#/sec] (mean)
Time per request:       3.417 [ms] (mean)
Time per request:       0.342 [ms] (mean, across all concurrent requests)
Transfer rate:          508.77 [Kbytes/sec] received

ab -n 100000 -c 10 http://localhost:5002/api/values

Concurrency Level:      10
Time taken for tests:   26.775 seconds
Complete requests:      100000
Failed requests:        0
Total transferred:      15800000 bytes
HTML transferred:       1900000 bytes
Requests per second:    3734.89 [#/sec] (mean)
Time per request:       2.677 [ms] (mean)
Time per request:       0.268 [ms] (mean, across all concurrent requests)
Transfer rate:          576.28 [Kbytes/sec] received

ab -n 100000 -c 10 http://localhost:5000/api2/values

Concurrency Level:      10
Time taken for tests:   37.993 seconds
Complete requests:      100000
Failed requests:        0
Total transferred:      17800000 bytes
HTML transferred:       1900000 bytes
Requests per second:    2632.09 [#/sec] (mean)
Time per request:       3.799 [ms] (mean)
Time per request:       0.380 [ms] (mean, across all concurrent requests)
Transfer rate:          457.53 [Kbytes/sec] received
```
Test results vary according to machine environment.