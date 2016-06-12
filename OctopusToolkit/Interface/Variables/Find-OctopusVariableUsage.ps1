function Find-OctopusVariableUsage {
    param(
        $Name
    )

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
        ? { $_.Scope.$Scope -contains $scopeId } |
        % { New-Object -TypeName PSCustomObject -Property (@{
                Container = $container
                 Name = $_.Name
                Value = $_.Value
            })
        }
        
       $output | Format-Table -Property @('Container', 'Name', 'Value')  -AutoSize
}