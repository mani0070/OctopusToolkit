function Get-OctopusVariableSets {
    param(
        [switch]$ResolveVariableSets
    )
    
    $variableSets = @(Invoke-Octopus '/Projects/All' | % { @{ Id = $_.Id; Name = $_.Name; Type = "Project"; VariableSetId = $_.VariableSetId; IncludedLibraryVariableSetIds = $_.IncludedLibraryVariableSetIds } }) +
                    @(Invoke-Octopus '/LibraryVariableSets/All?ContentType=Variables' | % { @{ Id = $_.Id; Name = $_.Name; Type = "Library"; VariableSetId = $_.VariableSetId }}) 
    if ($ResolveVariableSets) {
        $init = [scriptblock]::Create("function Invoke-Octopus { ${function:Invoke-Octopus} }")
        $jobs = $variableSets | select-object -first 4 |  % {
            Start-Job -InitializationScript $init -ScriptBlock {
                param($VariableSetId, $BaseUri, $ApiKey)
                @{ VariableSetId = $VariableSetId; Variables = (Invoke-Octopus ('/Variables/{0}' -f $VariableSetId) -BaseUri $BaseUri -ApiKey $ApiKey | % Variables) }
            } -ArgumentList @($_.VariableSetId, ($ExecutionContext.SessionState.Module.PrivateData['OctopusApi'].BaseUri), ($ExecutionContext.SessionState.Module.PrivateData['OctopusApi'].ApiKey))
        }
        while ($jobs | Wait-Job -Any | Receive-Job | % {
            $_.Variables | % GetEnumerator | % { @{ Name = $_.Name; Value = $_.Value; Scope = $_.Scope } } | ft | out-host
            $variableSets | ? VariableSetId -eq $retrievedVariables.VariableSetId | % { write-host $retrievedVariables.Variables }
            $true
        }) {}
    }             
     
    $variableSets | select-object -first 2 |  % { New-Object -TypeName PSCustomObject -Property $_ }
}