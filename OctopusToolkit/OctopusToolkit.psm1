<# Interface #>
. "$(Join-Path $PSScriptRoot '\Interface\ScopedObjects\Get-OctopusScope.ps1')"
. "$(Join-Path $PSScriptRoot '\Interface\StepTemplates\Format-StepTemplateProxyFunction.ps1')"
. "$(Join-Path $PSScriptRoot '\Interface\Connect-OctopusApi.ps1')"

<# Internal #>
. "$(Join-Path $PSScriptRoot '\Internal\Model\ScopedObjects\Get-OctopusMachines.ps1')"
. "$(Join-Path $PSScriptRoot '\Internal\ScopedObjects\Get-OctopusMachines.ps1')"
. "$(Join-Path $PSScriptRoot '\Internal\ScopedObjects\Get-OctopusProjectDeploymentProcess.ps1')"
. "$(Join-Path $PSScriptRoot '\Internal\ScopedObjects\Get-OctopusVariableSets.ps1')"
. "$(Join-Path $PSScriptRoot '\Internal\Get-OctopusScopeValues.ps1')"
. "$(Join-Path $PSScriptRoot '\Internal\Invoke-Octopus.ps1')"