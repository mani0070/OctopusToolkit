function Get-OctopusScopeValues {
    param(
        [ValidateSet("Environment", "Machine", "Role")]$Scope
    )
    
    switch ($Scope) {
        "Environment" { Invoke-Octopus '/Environments/All' | % { write-verbose $_; @{ Id = $_.Id; Name = $_.Name } } }
        "Machine" { Invoke-Octopus '/Machines/All' | % { @{ Id = $_.Id; Name = $_.Name; EnvironmentIds = $_.EnvironmentIds; RolesIds = $_.Roles } } }
        "Role" { Invoke-Octopus '/MachineRoles/All' | % { @{ Id = $_; Name = $_ } } }
    }
}