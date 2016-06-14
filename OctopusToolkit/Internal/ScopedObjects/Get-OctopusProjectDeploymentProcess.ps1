function Get-OctopusProjectDeploymentProcess {
    param (
        $ProjectId = 'All'
    )

    Invoke-Octopus "/Projects/$ProjectId" | % {
        $currentProject = $_
        Invoke-Octopus $_.Links.DeploymentProcess
        } | % {
            $id = $_.Id
            $_.Steps
        } | % {
            $stepName = $_.Name
            $targetRoles = $_.Properties['Octopus.Action.TargetRoles']
            $_.Actions
        } | % {
            New-Object -TypeName PSCustomObject -Property @{
                Id = $id
                OwnerType = 'Project'
                OwnerName = $currentProject.Name
                Type = 'Action'
                Name = $stepName
                Value = $_.Name
                Scope = @{
                    Role = $targetRoles
                    Environment = $_.Environments
                    Channel = $_.Channels
                }
            }
        }
}