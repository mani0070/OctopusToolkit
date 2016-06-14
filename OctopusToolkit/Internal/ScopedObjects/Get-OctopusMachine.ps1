function Get-OctopusMachine {
    param(
        $MachineId = 'All',
        $OwnerType,
        $OwnerName
    )

    Invoke-Octopus "/Machines/$MachineId" | % {
         New-Object -TypeName PSCustomObject -Property @{
            Id = $_.Id
            OwnerType = $OwnerType
            OwnerName = $OwnerName
            Type = "Machine"
            Name = $_.Name
            Value = ($_.Roles -join ', ')
            Scope = @{
                Environment = $_.EnvironmentIds
                Role = $_.Roles
            }
        }
    }
}