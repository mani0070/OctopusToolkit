function Get-OctopusScope {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]$Name,
        [Parameter(Mandatory=$true)][ValidateSet("Environment", "Machine", "Role")]$Scope,
        [Parameter(Mandatory=$true, ParameterSetName="ByProject")]$ProjectName,
        [switch]$IncludeUnScoped
    )

   $scopeId = Get-OctopusScopeValue -Scope $Scope |  ? Name -eq $Name | % Id
   if ($null -eq $scopeId) {
       throw "$Name scope of type $Scope not found."
   }
   Write-Verbose "ScopeId: $scopeId"

   $project = Invoke-Octopus '/Projects/All' | 
            ? Name -eq $ProjectName |
            % {
                $project = $_
                @{
                    Id = $_.Id
                    VariableSet = (Get-OctopusVariableSet -VariableSetId $_.VariableSetId -OwnerType "Project" -OwnerName $project.Name)
                    LibraryVariableSets = ($project.IncludedLibraryVariableSetIds | % { Invoke-Octopus "/LibraryVariableSets/$_" } | % { Get-OctopusVariableSet -VariableSetId $_.VariableSetId -OwnerType "Library" -OwnerName $_.Name })
                }
            }
    if ($null -eq $project) {
        throw "$ProjectName project not found."
    }
    
    $project.DeploymentProcess = Get-OctopusProjectDeploymentProcess -ProjectId $project.Id
    $project.Machines = Get-OctopusMachine -OwnerType $Scope -OwnerName $Name
    $project.LifeCycle = Get-OctopusLifeCycle -OwnerType $Scope -OwnerName $Name
    
    @($project.VariableSet, $project.LibraryVariableSets, $project.DeploymentProcess, $project.Machines, $project.LifeCycle) |
         % { $_ } |
         ? {
            if ($null -eq $_.Scope.$Scope -or $_.Scope.$Scope.Count -eq 0) { $IncludeUnScoped.ToBool() }
            else { $_.Scope.$Scope -contains $scopeId }
        } |
        Sort-Object -Property @(
                @{ Expression = {
                    $e = $_
                    switch ($e.Type) {
                        "LifeCycle" { 1 }
                        "VariableSet" {
                            if ($e.OwnerType -eq 'Library') { 2 }
                            if ($e.OwnerType -eq 'Project') { 3 }
                        }
                        "Action" { 4 }
                        "Machine" { 5 }
                    }
                }
            }
            'OwnerName'
            'Name') |
        Format-Table -GroupBy Type -Property @(
                @{Name = 'Container'; Expression = {
                    if ($_.Type -eq 'VariableSet') { '{0} ({1})' -f $_.OwnerName, $_.OwnerType }
                    else { $_.OwnerName }
                    }; Width = 50 }
                @{Name = 'Name'; Expression = { $_.Name } }
                @{Name = 'Value'; Expression = { $_.Value } }                
            )
}