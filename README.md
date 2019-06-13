# OcelotPerformanceTest

this is a demo to test ocelot performance.

inspired by:
<https://www.cnblogs.com/savorboard/p/wrk.html>


use powershell to run all projects:

```
./run-all.ps1
```

you may want to set powershell executionpolicy

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

then use [wrk](<https://github.com/wg/wrk>) to test this. you can build it with wsl 

```
wrk -t12 -c400 -d30s  http://localhost:5001/api/values
wrk -t12 -c400 -d30s  http://localhost:5000/api1/values

wrk -t12 -c400 -d30s  http://localhost:5002/api/values
wrk -t12 -c400 -d30s  http://localhost:5000/api2/values

```



