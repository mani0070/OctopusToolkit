function Find-OctopusVariable {
    [CmdletBinding()]
    param(
        $Name,
        [Parameter(Mandatory=$true, ParameterSetName="ByScope")][ValidateSet("Environment", "Machine", "Role")]$Scope
        #[Parameter(Mandatory=$true, ParameterSetName="ByProject")]$ProjectName,
        #[Parameter(Mandatory=$true, ParameterSetName="ByProject")][ValidateSet("Environment", "Machine", "Role", "Action", "Channel")]$Scope,
        #[Parameter(Mandatory=$true, ParameterSetName="ByUsage")][switch]$ByUsage
    )
    
    $scopeId = Get-OctopusScopeValues -Scope $Scope | ? Name -eq $Name | % Id
    if ($null -eq $scopeId) {
        throw "$Name scope of type $Scope not found."
    }
    
    Get-OctopusVariableSets -ResolveVariableSets |
        ? { write-host 1; $_.Variables.Scope.$Scope -contains $scopeId } |
        Group-Object -Property @('Type', 'Name') |
        Format-Table -AutoSize
}