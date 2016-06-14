function Invoke-Octopus {
    [CmdletBinding()]
    param(
        $Uri = "",
        $Body,
        [ValidateSet("Get", "Put", "Delete")]$Method = "Get",
        $BaseUri = ($ExecutionContext.SessionState.Module.PrivateData['OctopusApi'].BaseUri),
        $ApiKey = ($ExecutionContext.SessionState.Module.PrivateData['OctopusApi'].ApiKey),
        $Cache = (Get-Cache)
    )
    
    $absoluteUri = "$($BaseUri)/$($Uri | % Trim '/')" | % Replace '/api/api/' '/api/'
    Write-Verbose "Uri: $($absoluteUri)"

    if ($Method -eq "Get" -and $Cache.ContainsKey($absoluteUri)) {
        return $Cache.Item($absoluteUri)
    }

   $result = Invoke-WebRequest -Uri $absoluteUri -Method $Method -Body ($Body | ConvertTo-Json) -Headers @{ "X-Octopus-ApiKey" = $ApiKey } -UseBasicParsing | % Content | ConvertFrom-Json
  
    if ($Method -eq "Get") {
        $cache.Add($absoluteUri, $result)
    }

    $result | Write-Output
}   