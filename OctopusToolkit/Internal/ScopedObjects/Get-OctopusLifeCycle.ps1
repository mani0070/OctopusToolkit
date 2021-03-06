function Get-OctopusLifeCycle {
    param(
        $LifecycleId = 'All',
        $OwnerType,
        $OwnerName
    )
    
    Invoke-Octopus "/LifeCycles/$LifecycleId" | % {
        $id = $_.Id
        $lifecycleName = $_.Name
        $_.Phases
    } | % {
         New-Object -TypeName PSCustomObject -Property @{
            Id = $id
            OwnerType = $OwnerType
            OwnerName = $OwnerName
            Type = "LifeCycle"
            Name = $lifecycleName
            Value = "Phase: $($_.Name)"
            Scope = @{
                Environment = ($_.OptionalDeploymentTargets + $_.AutomaticDeploymentTargets)
            }
         }
    }
}