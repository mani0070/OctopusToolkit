# OctopusToolkit
A PowerShell Module with useful helper functions to use when developing or maintaining Octopus Deploy

## wip variable scope search example
```
$env:OctopusUri = "http://octopus.com/"
$env:OctopusApiKey = "API-X"
. .\OctopusToolkit\Internal\Invoke-Octopus.ps1
. .\OctopusToolkit\Interface\Variables\Find-OctopusVariablesByScope.ps1
Find-OctopusVariablesByScope -Name "MyEnv" -Scope Environment -ProjectName "Infrastructure"
```
