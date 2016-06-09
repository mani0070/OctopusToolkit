unction New-StepTemplateObject {
    param (
        $Path
    )

    New-Object -TypeName PSObject -Property (@{
        'Name' = Get-VariableFromScriptFile -Path $Path -VariableName StepTemplateName
        'Description' = Get-VariableFromScriptFile -Path $Path -VariableName StepTemplateDescription
        'ActionType' = 'Octopus.Script'
        'Properties' = @{
            'Octopus.Action.Script.ScriptBody' = Get-ScriptBody -Path $Path
            'Octopus.Action.Script.Syntax' = 'PowerShell'
            }
        'Parameters' = @(Get-VariableFromScriptFile -Path $Path -VariableName StepTemplateParameters)
        'SensitiveProperties' = @{}
        '$Meta' = @{'Type' = 'ActionTemplate'}
        'Version' = 1
    })
}