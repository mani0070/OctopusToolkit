function Reset-Cache {
    $ExecutionContext.SessionState.Module.PrivateData['Cache'] = @{}
}