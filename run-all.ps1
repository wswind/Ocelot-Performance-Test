$rootFolder = (Get-Item -Path "./" -Verbose).FullName

$solutionPaths = (
    "api1",
    "api2",
    "ocelothost"
)

foreach ($solutionPath in $solutionPaths) {    
    $solutionAbsPath = (Join-Path $rootFolder $solutionPath)
    Set-Location $solutionAbsPath
	Start-Process powershell -ArgumentList "dotnet build;dotnet run"
}

Set-Location $rootFolder
