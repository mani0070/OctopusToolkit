function Get-OctopusVariableSets {
    param(
        [switch]$ResolveVariableSets
    )
    
    $variableSets = @(Invoke-Octopus '/Projects/All' | % { @{ Id = $_.Id; Name = $_.Name; Type = "Project"; VariableSetId = $_.VariableSetId; IncludedLibraryVariableSetIds = $_.IncludedLibraryVariableSetIds } }) +
                    @(Invoke-Octopus '/LibraryVariableSets/All?ContentType=Variables' | % { @{ Id = $_.Id; Name = $_.Name; Type = "Library"; VariableSetId = $_.VariableSetId }}) 
    if ($ResolveVariableSets) {
        $init = [scriptblock]::Create("function Invoke-Octopus {$function:Invoke-Octopus}")
        $jobs = $variableSets | % {
            Start-Job -InitializationScript $init -ScriptBlock {
                param($VariableSetId, $BaseUri, $ApiKey)
                @{ VariableSetId = $VariableSetId; Variables = Invoke-Octopus ('/Variables/{0}' -f $VariableSet.VariableSetId) }
            } -ArgumentList @($_.VariableSetId, ($ExecutionContext.SessionState.Module.PrivateData['OctopusApi'].BaseUri), ($ExecutionContext.SessionState.Module.PrivateData['OctopusApi'].ApiKey)
        }
        while ($jobs | Wait-Job -Any | Receive-Job | % { write-host "got $($_.variableSetid) $($_.Variables)"; $true }) {}
    }             
     
    $variableSets | % { New-Object -TypeName PSCustomObject -Property $_ }
}