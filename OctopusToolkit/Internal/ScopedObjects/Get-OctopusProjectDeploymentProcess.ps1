function Get-OctopusProjectDeploymentProcess {
    param (
        $ProjectId = 'All'
    )

    Invoke-Octopus "/Projects/$ProjectId" | % {
        $currentProjectId = $_.Id
        Invoke-Octopus $_.Links.DeploymentProcess
        } | % {
            $id = $_.Id
            $_.Steps
        } | % {
            $stepName = $_.Name
            $targetRoles = $_.Properties['Octopus.Action.TargetRoles']
            $_.Actions
        } | % {
            if ($stepName -eq $_.Name) { $name = $_.Name }
            else { $name = '{0} - {1}' -f $stepName, $_.Name }

            New-Object -TypeName PSCustomObject -Property @{
                Id = $id
                OwnerId = $currentProjectId
                Type = "Action"
                Name = $name
                Value = ""
                Scope = @{
                    Role = $targetRoles
                    Environment = $_.Environments
                    Channel = $_.Channels
                }
            }
        }
}