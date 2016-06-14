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
    # when checking for scopign also check for actions in projects which have been scoped
    Get-OctopusVariableSets -ResolveVariableSets |
    #    ? { $_.Variables.Scope.$Scope -contains $scopeId } |
        Group-Object -Property @('Type', 'Name') |
        % { 
            Write-Host "`n`t$($_.Name)"
            $_.Group.Variables | ft #.Variables | Format-Table -AutoSize -Property @('Name', 'Value')
        }
        
}