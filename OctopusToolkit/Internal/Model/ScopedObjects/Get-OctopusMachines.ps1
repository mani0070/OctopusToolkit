function Get-OctopusMachines {
    Invoke-Octopus '/Machines/All' | % {
        New-Object -TypeName PSCustomObject -Property @{
            Id = $_.Id
            OwnerId = $null
            Type = "Machine"
            Name = $_.Name
            Value = ""
            Scope = @{
                Environment = $_.EnvironmentIds
                Role = $_.RolesIds
            }
        }
    }
}