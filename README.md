# Ocelot Performance Test

this is a demo to test ocelot performance.

use .net core 3.1 sdk

use apache bench for load test 

wsl for nginx proxy test has an error: apr_socket_recv: Transport endpoint is not connected (107) . So I changed to use a linux vm to run the tests.

host ip : 192.168.56.1
vm ip : 192.168.56.10


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


## without proxy test result

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

## ocelot proxy test result
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
```

## config nginx for compare

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


set linux(centos) open file limits


```
vi /etc/security/limits.conf

* soft nofile 655350
* hard nofile 655350

ulimit -n 655350 #or re-login


vi /etc/nginx/nginx.conf

error_log /var/log/nginx/error.log;
worker_rlimit_nofile 655350; # add this line

events {
    worker_connections 2048; #change this line
}

service nginx reload


#to see error log
tail /var/log/nginx/error.log
```

## nginx proxy test result


```
Server Software:        nginx/1.16.1
Server Hostname:        192.168.56.10
Server Port:            5010

Document Path:          /api1/values
Document Length:        19 bytes

Concurrency Level:      1000
Time taken for tests:   5.264 seconds
Complete requests:      20000
Failed requests:        0
Write errors:           0
Total transferred:      3260000 bytes
HTML transferred:       380000 bytes
Requests per second:    3799.44 [#/sec] (mean)
Time per request:       263.196 [ms] (mean)
Time per request:       0.263 [ms] (mean, across all concurrent requests)
Transfer rate:          604.79 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    4  19.2      1    1002
Processing:     2  181 605.2     29    3165
Waiting:        1  179 603.9     28    3158
Total:          2  185 609.0     30    3187
```


The ab test with ocelot proxy could be very slow at the first time. But it would be faster and faster when you run it multiple times. So the first time test result is not included.
nginx server is not at the same machine like ocelot does.
Test results varies according to machine environment

