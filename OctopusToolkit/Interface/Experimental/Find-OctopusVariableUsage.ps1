function Find-OctopusVariableUsage {
    param(
        $Name
    )
    
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

    $allProjectVariables = Invoke-Octopus '/api/Projects/All' |
         % { $name = $_.Name; Invoke-Octopus ('/api/Variables/{0}' -f $_.VariableSetId) } |
         % { @{ Container = "Project $name"; Variables = $_.Variables } }

    $includedVariables = @($project.IncludedLibraryVariableSetIds |
        ? { $null -ne $_ } | 
        % { Invoke-Octopus '/api/LibraryVariableSets/All?ContentType=Variables' } |
        % { $variableSetName = $_.Name; Invoke-Octopus $_.Links.Variables } |
        % { @{ Container = "Library Variable Set: $variableSetName"; Variables = $_.Variables } })

    $output = $projectVariables + $includedVariables |
    % { $container = $_.Container; $_.Variables } |
}