$ExecutionContext.SessionState.Module.PrivateData['OctopusApi'] = $null

<# Interface #>
. "$(Join-Path $PSScriptRoot '\Interface\StepTemplates\Format-StepTemplateProxyFunction.ps1')"
#. "$(Join-Path $PSScriptRoot '\Interface\Variables\Find-OctopusVariable.ps1')"
#. "$(Join-Path $PSScriptRoot '\Interface\Variables\Find-OctopusVariableUsage.ps1')"
. "$(Join-Path $PSScriptRoot '\Interface\Connect-OctopusApi.ps1')"
. "$(Join-Path $PSScriptRoot '\Interface\Get-OctopusScope.ps1')"

<# Internal #>
. "$(Join-Path $PSScriptRoot '\Internal\Model\Get-OctopusDeploymentSteps.ps1')"
. "$(Join-Path $PSScriptRoot '\Internal\Model\Get-OctopusMachines.ps1')"
. "$(Join-Path $PSScriptRoot '\Internal\Model\Get-OctopusScopeValues.ps1')"
. "$(Join-Path $PSScriptRoot '\Internal\Model\Get-OctopusVariableSets.ps1')"
#. "$(Join-Path $PSScriptRoot '\Internal\Model\Request-VariableSeVaiablest.ps1')"
. "$(Join-Path $PSScriptRoot '\Internal\Invoke-Octopus.ps1')"
