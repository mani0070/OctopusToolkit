function Get-Cache {
    if ($null -eq $global:DevelopmentCache) { $global:DevelopmentCache = @{} }
    return $global:DevelopmentCache
    
    #if ($null -eq $ExecutionContext.SessionState.Module.PrivateData['Cache']) { $ExecutionContext.SessionState.Module.PrivateData['Cache'] = @{} }
    #return $ExecutionContext.SessionState.Module.PrivateData['Cache']
}