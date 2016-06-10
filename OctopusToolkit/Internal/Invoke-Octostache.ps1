function Invoke-Octostache {
    # https://github.com/OctopusDeploy/Octostache
    $octostacheAssemblty = Join-Path $PSScriptRoot '..\Lib\Octostache\lib\net40\Octostache.dll'
    if (-not (Test-Path $octostacheAssemblty) {
        & nuget install Octostache -ExcludeVersion -OutputDirectory (Join-Path $PSScriptRoot '..\Lib\')
    }
    Add-Type -AssemblyName $octostacheAssemblty

var variables = new VariableDictionary();
variables.Set("Server", "Web01");
variables.Set("Port", "10933");
variables.Set("Url", "http://#{Server | ToLower}:#{Port}");

var url = variables.Get("Url");               // http://web01:10933
var raw = variables.GetRaw("Url");            // http://#{Server | ToLower}:#{Port}
var eval = variables.Evaluate("#{Url}/foo");  // http://web01:10933/foo


}