$ExecutionContext.SessionState.Module.PrivateData['OctopusApi'] = $null

<# Interface #>
. "$(Join-Path $PSScriptRoot '\Interface\StepTemplates\Format-StepTemplateProxyFunction.ps1')"
. "$(Join-Path $PSScriptRoot '\Interface\Variables\Find-OctopusVariable.ps1')"
#. "$(Join-Path $PSScriptRoot '\Interface\Variables\Find-OctopusVariableUsage.ps1')"
. "$(Join-Path $PSScriptRoot '\Interface\Connect-OctopusApi.ps1')"

<# Internal #>
. "$(Join-Path $PSScriptRoot '\Internal\Variables\Get-OctopusScopeValues.ps1')"
. "$(Join-Path $PSScriptRoot '\Internal\Variables\Get-OctopusVariableSets.ps1')"
. "$(Join-Path $PSScriptRoot '\Internal\Invoke-Octopus.ps1')"