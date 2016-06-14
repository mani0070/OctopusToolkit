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

   $project =  Invoke-Octopus '/Projects/All' | 
            ? Name -eq $ProjectName |
            % {
                @{
                    Id = $_.Id
                    VariableSetId = $_.VariableSetId
                    IncludedLibraryVariableSetIds = $_.IncludedLibraryVariableSetIds
                }
            }
    if ($null -eq $project) {
        throw "$ProjectName project not found."
    }
    $project.IncludedVariableSetIds = $project.IncludedLibraryVariableSetIds | % { Invoke-Octopus "/LibraryVariableSets/$_" } | % VariableSetId
    
    $variableSets = @($project.VariableSetId) + @($project.IncludedVariableSetIds) | % { Get-OctopusVariableSets -VariableSetId $_ }
    $deploymentProcess  = Get-OctopusDeploymentProcess -ProjectId $project.Id
    $machines = Get-OctopusMachines
    
    @($variableSets, $deploymentProcess, $machines) |
        ? { $_.Scope.$Scope -contains $scopeId } |
        Format-Table @(
                @{Name = 'Type'; Expression = { $_.Type } }
                @{Name = 'Owner Id'; Expression = { $_.OwnerId } }
                @{Name = 'Name'; Expression = { $_.Name } }
                @{Name = 'Value'; Expression = { $_.Value } }
            ) -AutoSize
}