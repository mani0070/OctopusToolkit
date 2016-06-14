function Request-VariableSetVaiablest {
        $init = [scriptblock]::Create("function Invoke-Octopus { ${function:Invoke-Octopus} }")
        $jobs = $variableSets | % {
            Start-Job -InitializationScript $init -ScriptBlock {
                param($VariableSetId, $BaseUri, $ApiKey)
            } -ArgumentList @($_.VariableSetId, ($ExecutionContext.SessionState.Module.PrivateData['OctopusApi'].BaseUri), ($ExecutionContext.SessionState.Module.PrivateData['OctopusApi'].ApiKey))
        }
        while ($jobs | Wait-Job -Any | Receive-Job | % {
            $_.Variables | % GetEnumerator | % { @{ Name = $_.Name; Value = $_.Value; Scope = $_.Scope } } | ft | out-host
            $variableSets | ? VariableSetId -eq $retrievedVariables.VariableSetId | % { write-host $retrievedVariables.Variables }
            $true
        }) {}
}