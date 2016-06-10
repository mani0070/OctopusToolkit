function Find-OctopusVariableUsage {
    param(
        $Name
    )



    $allProjectVariables = Invoke-Octopus '/api/Projects/All' |
         % { $name = $_.Name; $_.VariableSetId } | 
         % { @{ Container = "Project $name"; Variables = $_.Variables } }

    
    $scopeId  = Invoke-Octopus ('/api/Variables/{0}' -f $project.VariableSetId) | % { $projectVariables = @(@{ Container = "Project $ProjectName"; Variables = $_.Variables }); $_.ScopeValues."$($Scope)s" } | ? Name -eq $Name | % Id
    Write-Verbose "ScopeId:$scopeId"
    if ($null -eq $scopeId) {
        throw "Scope '$Name' of scope type $Scope can't be found"
    }
    $includedVariables = @($project.IncludedLibraryVariableSetIds |
        ? { $null -ne $_ } | 
        % { Invoke-Octopus ('/api/LibraryVariableSets/{0}' -f $_) } |
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