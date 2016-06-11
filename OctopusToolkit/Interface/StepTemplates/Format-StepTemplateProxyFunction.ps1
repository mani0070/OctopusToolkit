function Format-StepTemplateProxyFunction {
    [CmdletBinding()]
    [OutputType("System.String")]
    param(
        [Parameter(Mandatory=$true)][System.String]$Name
    )

    function Write-ParameterLine {
        param(
            $Name,
            $Value,
            $Indent = 2,
            [switch]$InlinePowerShell
        )
        if (-not $InlinePowerShell) {
            $Value = "`"$($Value)`""
        }
        Write-Output ("{0}'{1}' = {2}" -f ("`t" * $Indent), $Name, $Value)
    }

    $cmdlettMetaData = Get-Help -Name $Name 
    $firstParameter = $true

    '$StepTemplateName = ''{0}''' -f ($cmdlettMetaData  | % Synopsis | % Trim)

    '$StepTemplateDescription = ''{0}''' -f ($cmdlettMetaData | % description | % Text | % ToString | % Trim)

    $mappedCmdlet = ""
    $paramCmdlet = ""
    '$StepTemplateParameters = @('
     $cmdlettMetaData |  % { $_.parameters.parameter } | % {
         if ($_.name -in @('InformationAction', 'InformationVariable', 'Profile','Force','WhatIf','Confirm')) { return }
        $mappedCmdlet += "-$($_.name) `$$($_.Name) "
        $paramCmdlet += "`t`t`$$($_.Name),`n"
        
         if ($firstParameter) { "`t@{"; $firstParameter = $false }
         else { "`t}, @{" }
         
        Write-ParameterLine Name $_.name
        Write-ParameterLine Label ($_.name -creplace '(?<!^)([A-Z][a-z]|(?<=[a-z])[A-Z])', ' $&') # Pascal split
        if  ($_.required -eq "true") {
            $qualifier = "Required"
        } else {
            $qualifier = "Optional"
        }
        
        if ($_.type.name -eq "SwitchParameter") {
             Write-ParameterLine HelpText ("{0}" -f (($_.description | % Text | % Replace "`r" "`n" |  % Replace "`n" '`n'  ) -join '\n'))
             Write-ParameterLine DefaultValue False
             Write-ParameterLine DisplaySettings "@{ 'Octopus.ControlType' = 'Checkbox' }" -InlinePowerShell
        } else {
            Write-ParameterLine HelpText ("{0}: {1}" -f $qualifier, (($_.description | % Text | % Replace "`r" "`n" |  % Replace "`n" '`n'  ) -join '\n'))
            if  (-not ([string]::IsNullOrWhiteSpace($_.defaultValue)) -and $_.defaultValue -ne "none") {
                 Write-ParameterLine DefaultValue $_.defaultValue
            } else {
                 Write-ParameterLine DefaultValue '$null' -InlinePowerShell
            }

            $validateSet = $cmdlettMetaData | % { $_.syntax.syntaxItem.parameter } | ? name -eq $_.name | % parameterValueGroup | % parameterValue
            if (-not ([string]::IsNullOrWhiteSpace($validateSet))) {
                Write-ParameterLine DisplaySettings "@{" -InlinePowerShell
                Write-ParameterLine 'Octopus.ControlType' Select 2
                Write-ParameterLine 'Octopus.SelectOptions' ($validateSet -join '`n') 2
                "`t`t}"
            } else {
                 Write-ParameterLine DisplaySettings "@{ 'Octopus.ControlType' = 'SingleLineText' }" -InlinePowerShell
            }
        }
    }
@"
    }
)
function Invoke-StepTemplate {
    param(
    $($paramCmdlet.Trim().Trim(','))
    )

    $Name $mappedCmdlet
}

if (Test-Path Variable:OctopusParameters) {
     Invoke-StepTemplate $mappedCmdlet
}

"@
}
