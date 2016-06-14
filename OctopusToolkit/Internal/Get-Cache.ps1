function Get-Cache {
    #if ($null -eq $global:DevelopmentCache) { $global:DevelopmentCache = @{} }
    #return $global:DevelopmentCache
    return $ExecutionContext.SessionState.Module.PrivateData['Cache']
}