function Get-OctopusVariableSet {
    param(
        $VariableSetId = 'All',
        $OwnerType,
        $OwnerName
    )

    if ($VariableSetId -eq 'All') {
        Invoke-Octopus '/Projects/All' | % { Get-OctopusVariableSet -VariableSetId $_.VariableSetId -OwnerType "Project" -OwnerName $_.Name } 
        Invoke-Octopus '/LibraryVariableSets/All?ContentType=Variables' | % { Get-OctopusVariableSet -VariableSetId $_.VariableSetId -OwnerType "Library" -OwnerName $_.Name } 
    } else {
        Invoke-Octopus "/Variables/$VariableSetId" | % Variables | % {
            if ($_.IsSensitive) { $value = '**********' }
            else { $value = $_.Value }
            
            New-Object -TypeName PSCustomObject -Property @{
                Id = $_.Id
                OwnerType = $OwnerType
                OwnerName = $OwnerName
                Type = "VariableSet"
                Name = $_.Name
                Value = $value
                Scope = $_.Scope
            }
        }
    }
}