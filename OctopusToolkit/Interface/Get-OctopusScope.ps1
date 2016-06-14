function Get-OctopusScope {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]$Name,
        [Parameter(Mandatory=$true)][ValidateSet("Environment", "Machine", "Role")]$Scope,
        [Parameter(Mandatory=$true, ParameterSetName="ByProject")]$ProjectName
    )

     $scopeId = Get-OctopusScopeValues -Scope $Scope | ? Name -eq $Name | % Id
    if ($null -eq $scopeId) {
        throw "$Name scope of type $Scope not found."
    }

   $project =  Invoke-Octopus '/Projects/All' |  ? Name -eq $ProjectName | % { @{ Id = $_.Id; VariableSetId = $_.VariableSetId; IncludedLibraryVariableSetIds = $_.IncludedLibraryVariableSetIds } }
    if ($null -eq $project) {
        throw "$ProjectName project not found."
    }
    $project.IncludedVariableSetIds = $project.IncludedLibraryVariableSetIds | % { Invoke-Octopus ('/LibraryVariableSets/{0}' -f $_) } | % VariableSetId
    $variableSets = @($project.VariableSetId) + @($project.IncludedVariableSetIds) | % { Get-OctopusVariableSets -VariableSetId $_ }
    $deploymentProcess  = Get-OctopusDeploymentProcess -ProjectId $project.Id

    @($variableSets, $deploymentProcess) | ? { $_.Scope.$Scope -contains $scopeId } | Format-Table @(
        @{Name = 'In'; Expression = { $vs.Type } }
        @{Name = 'Set Name'; Expression = { $vs.Name } }
        @{Name = 'Variable Name'; Expression = { $_.Name } }
        @{Name = 'Variable Value'; Expression = { $_.Value } }
    ) -AutoSize

 #   $deploymentProcess | Write-Host
    

}