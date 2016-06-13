function Connect-OctopusApi {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][ValidateScript({ -not ([string]::IsNullOrWhiteSpace($_)) })]$Uri,
        [Parameter(Mandatory=$true)][ValidateScript({ -not ([string]::IsNullOrWhiteSpace($_)) })]$ApiKey
    )
    
    $success = $false
    try {
        if (Invoke-Octopus -BaseUri $Uri -ApiKey $ApiKey | ? Application -eq "Octopus Deploy") {
            $ExecutionContext.SessionState.Module.PrivateData['OctopusApi'] = @{
                BaseUri = ('{0}/api' -f ($Uri.Replace('/api', '').Trim('/')))
                ApiKey = $ApiKey
            }
            $success = $true           
        }
    }
    catch {
        Write-Host -ForegroundColor Red "ERROR: $($_.Message)"
    }
    
    if ($success) { Write-Host -ForegroundColor Green "Connection successful." }
    else {
        Write-Host -ForegroundColor Red "Connection unsuccessful."
    }
}