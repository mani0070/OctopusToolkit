function Invoke-Octopus {
    [CmdletBinding()]
    param(
        $Uri = "",
        $Body,
        [ValidateSet("Get", "Put", "Delete")]$Method = "Get",
        $BaseUri = ($ExecutionContext.SessionState.Module.PrivateData['OctopusApi'].BaseUri),
        $ApiKey = ($ExecutionContext.SessionState.Module.PrivateData['OctopusApi'].ApiKey)
    )
    
    Write-Verbose "BaseUri: $BaseUri"
    Write-Verbose "ApiKey: $ApiKey"
    
    $absoluteUri = "$($BaseUri)/$($Uri | % Trim '/')" | % Replace '/api/api/' '/api/'
    Write-Verbose "Uri: $($absoluteUri)"
    
    Invoke-WebRequest -Uri $absoluteUri -Method $Method -Body ($Body | ConvertTo-Json) -Headers @{ "X-Octopus-ApiKey" = $ApiKey } -UseBasicParsing | % Content | ConvertFrom-Json | Write-Output
}   