function Connect-OctopusApi {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][ValidateScript({ -not ([string]::IsNullOrWhiteSpace($_)) })]$Uri,
        [Parameter(Mandatory=$true)][ValidateScript({ -not ([string]::IsNullOrWhiteSpace($_)) })]$ApiKey
    )
    
    $success = $false
    try {
        $ExecutionContext.SessionState.Module.PrivateData['Cache'] = @{}
        $baseUri = '{0}/api' -f $Uri.Replace('/api', '').Trim('/')
        if (Invoke-Octopus -BaseUri $baseUri -ApiKey $ApiKey | ? Application -eq "Octopus Deploy") {
            $ExecutionContext.SessionState.Module.PrivateData['OctopusApi'] = @{
                BaseUri = $baseUri
                ApiKey = $ApiKey
            }
            $success = $true           
        }
    }
    catch {
        Write-Host -ForegroundColor Red "ERROR: $($_.Exception.Message)"
    }
    
    if ($success) { Write-Host -ForegroundColor Green "Connection successful." }
    else {
        Write-Host -ForegroundColor Red "Connection unsuccessful."
    }
}