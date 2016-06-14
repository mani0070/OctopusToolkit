function Get-OctopusMachines {
    Invoke-Octopus '/Machines/All' | % { @{ Id = $_.Id; Name = $_.Name; EnvironmentIds = $_.EnvironmentIds; RolesIds = $_.Roles } }
}