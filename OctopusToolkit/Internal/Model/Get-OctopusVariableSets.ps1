function Get-OctopusVariableSets {
    param(
        $VariableSetId = 'All'
    )

    if ($VariableSetId -eq 'All') {
        @(Invoke-Octopus '/Projects/All' | % VariableSetId) + @(Invoke-Octopus '/LibraryVariableSets/All?ContentType=Variables' | % Items | % VariableSetId) |
        ? { $null -ne $_ } |
            % { Get-OctopusVariableSets -VariableSetId $_ }
    } else {
        Invoke-Octopus ('/Variables/{0}' -f $VariableSetId) | % {
            $ownerId = $_.OwnerId
            $type = $ownerId.Split('-')[0]
            $_.Variables
        } | % {
            @{
                Id = $_.Id
                Type = $type
                OwnerId = $ownerId
                Name = $_.Name
                Value = $_.Value
                Scope = $_.Scope
            }
        } |  % { New-Object -TypeName PSCustomObject -Property $_ }
    }
}