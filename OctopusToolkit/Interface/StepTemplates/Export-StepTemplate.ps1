function Export-StepTemplate {
    [CmdletBinding()]
    [OutputType("System.String")]
    param(
        [Parameter(Mandatory=$true)][ValidateScript({ Test-Path $_ })][System.String]$Path,
        [Parameter(Mandatory=$true, ParameterSetName="File")][System.String]$ExportPath,
        [Parameter(Mandatory=$false, ParameterSetName="File")][System.Management.Automation.SwitchParameter]$Force,
        [Parameter(Mandatory=$true, ParameterSetName="Clipboard")][System.Management.Automation.SwitchParameter]$ExportToClipboard
    )
    
    $resolvedPath = Resolve-Path -Path $Path
    $stepTemplate = Convert-ToOctopusJson (New-StepTemplateObject -Path $resolvedPath)
    
    switch ($PSCmdlet.ParameterSetName) {
        "File" {
            if ((Test-Path $ExportPath) -and -not $Force) {
                throw "$ExportPath already exists. Specify -Force to overwrite"
            }
            
            Set-Content -Path $ExportPath -Value $stepTemplate -Force:$Force -Encoding UTF8
            
            "Step Template exported to $ExportPath"
        }
        "Clipboard" {
            Microsoft.PowerShell.Management\Set-Clipboard -Value $stepTemplate
            
            "Step Template exported clipboard"
        }
    }
}