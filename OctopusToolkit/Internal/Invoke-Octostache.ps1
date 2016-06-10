function Invoke-Octostache {
    # https://github.com/OctopusDeploy/Octostache
    $octostacheAssemblty = Join-Path $PSScriptRoot '..\Lib\Octostache\lib\net40\Octostache.dll'
    if (-not (Test-Path $octostacheAssemblty) {
        & nuget install Octostache -ExcludeVersion -OutputDirectory (Join-Path $PSScriptRoot '..\Lib\')
    }
    Add-Type -AssemblyName $octostacheAssemblty


}