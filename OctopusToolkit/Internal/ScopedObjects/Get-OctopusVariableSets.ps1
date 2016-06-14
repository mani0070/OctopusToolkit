function Get-OctopusVariableSets {
    param(
        $VariableSetId = 'All'
    )

    if ($VariableSetId -eq 'All') {
        @(Invoke-Octopus '/Projects/All' | % VariableSetId) +
        @(Invoke-Octopus '/LibraryVariableSets/All?ContentType=Variables' | % Items | % VariableSetId) |
            % { Get-OctopusVariableSets -VariableSetId $_ }
    } else {
        Invoke-Octopus "/Variables/$VariableSetId" | % {
            $ownerId = $_.OwnerId
            $type = $ownerId.Split('-')[0]
            $_.Variables
        } | % {
            New-Object -TypeName PSCustomObject -Property @{
                Id = $_.Id
                OwnerId = $ownerId
                Type = $type
                Name = $_.Name
                Value = $_.Value
                Scope = $_.Scope
            }
        }
    }
}