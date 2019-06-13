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
ab -n 100000 -c 10 http://localhost:5000/api1/values
ab -n 100000 -c 10 http://localhost:5002/api/values
ab -n 100000 -c 10 http://localhost:5000/api2/values
```