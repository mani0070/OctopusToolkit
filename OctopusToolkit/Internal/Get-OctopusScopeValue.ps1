function Get-OctopusScopeValue {
    param(
        $Scope
    )
    
    switch ($Scope) {
        "Environment" { Invoke-Octopus '/Environments/All' | % { @{ Id = $_.Id; Name = $_.Name } } }
        "Machine" { Invoke-Octopus '/Machines/All' | % { @{ Id = $_.Id; Name = $_.Name } } }
        "Role" { Invoke-Octopus '/MachineRoles/All' | % { @{ Id = $_; Name = $_ } } }
    }
}