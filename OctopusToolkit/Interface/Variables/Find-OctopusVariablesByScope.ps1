function Find-OctopusVariablesByScopeType {
    [CmdletBinding()]
    param(
        $ScopeName,
        [ValidateSet("Environment", "Machine", "Action", "Role", "Channel")]$ScopeType = "Environment",
        $ProjectName
    )

    $project = Invoke-Octopus '/api/Projects/All' | % { $_ } | ? Name -eq $ProjectName
    if ($null -eq $project) {
        throw "Project $ProjectName can't be found"
    }
    
    $ScopeTypeId  = Invoke-Octopus ('/api/Variables/{0}' -f $project.VariableSetId) | % { $projectVariables = @(@{ Container = "Project $ProjectName"; Variables = $_.Variables }); $_.ScopeTypeValues."$($ScopeType)s" } | ? Name -eq $ScopeName | % Id
    Write-Verbose "ScopeTypeId:$ScopeTypeId"
    if ($null -eq $ScopeTypeId) {
        throw "ScopeType '$ScopeName' of ScopeType type $ScopeType can't be found"
    }
    $includedVariables = @($project.IncludedLibraryVariableSetIds |
        ? { $null -ne $_ } | 
        % { Invoke-Octopus ('/api/LibraryVariableSets/{0}' -f $_) } |
        % { $variableSetName = $_.Name; Invoke-Octopus $_.Links.Variables } |
        % { @{ Container = "Library Variable Set: $variableSetName"; Variables = $_.Variables } })

    $output = $projectVariables + $includedVariables |
    % { $container = $_.Container; $_.Variables } |
        ? { $_.ScopeType.$ScopeType -contains $ScopeTypeId } |
        % { New-Object -TypeName PSCustomObject -Property (@{
                Container = $container
                 Name = $_.Name
                Value = $_.Value
            })
        }
        
       $output | Format-Table -Property @('Container', 'Name', 'Value')  -AutoSize
}