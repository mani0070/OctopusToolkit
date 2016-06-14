function Get-OctopusDeploymentProcess {
    param (
        $ProjectId = 'All'
    )

    Invoke-Octopus "/Projects/$ProjectId" | % {
        $currentProjectId = $_.Id
        Invoke-Octopus $_.Links.DeploymentProcess
        } | % {
            $currentId = $_.Id
            $_.Steps
        } | % {
            $stepName = $_.Name
            $targetRoles = $_.Properties['Octopus.Action.TargetRoles']
            $_.Actions
        } | % {
            @{
                Id = $currentId
                StepName = $stepName
                ActionName = $_.Name
                Type = "Action"
                ProjectId = $currentProjectId
                Scope = @{
                    TargetRoles = $targetRoles
                    EnvironmentIds = $_.Environments
                    Channels = $_.Channels
                }
            }
        } | % { New-Object -TypeName PSCustomObject -Property $_ }
}