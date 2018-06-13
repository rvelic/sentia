#Requires -Version 3.0
#Requires -Module AzureRM.Resources
#Requires -Module @{ModuleName="AzureRm.Profile";ModuleVersion="3.0"}

Param(
    [string] [Parameter(Mandatory=$true)] $StagingDirectory,
    [string] [Parameter(Mandatory=$true)] $SubscriptionId,
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
    [array]  [Parameter(Mandatory=$true)] $AllowedResourceTypes,
    [string] $TemplateRulesFile = $StagingDirectory + '\azurepolicy.rules.json',
    [string] $TemplateParametersFile = $StagingDirectory + '\azurepolicy.parameters.json',
    [string] $DebugOptions = "None"
)

try {
    [Microsoft.Azure.Common.Authentication.AzureSession]::ClientFactory.AddUserAgent("AzureQuickStarts-$UI$($host.name)".replace(" ","_"), "1.0")
} catch { }

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3

$TemplateArgs = New-Object -TypeName Hashtable

Write-Host "Using parameter file: $TemplateParametersFile"

$TemplateRulesFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $TemplateRulesFile))
$TemplateParametersFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $TemplateParametersFile))

$TemplateArgs.Add('TemplateRulesFile', $TemplateRulesFile)
$TemplateArgs.Add('TemplateParameterFile', $TemplateParametersFile)

Write-Host "Depoying policy definition"

$PolicyDefinition = New-AzureRmPolicyDefinition -Name "allowed-resourcetypes" `
                                          -DisplayName "Allowed resource types" `
                                          -Description "Resource types that your organization can deploy." `
                                          -Policy $TemplateRulesFile `
                                          -Parameter $TemplateParametersFile `
                                          -Mode All -Verbose

Write-Host "Deploying policy assignment"

New-AzureRMPolicyAssignment -Name "allowed-resourcetypes-assignment" `
                            -Description "Resource types that your organization can deploy." `
                            -Scope "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName" `
                            -listOfResourceTypesAllowed $AllowedResourceTypes `
                            -PolicyDefinition $PolicyDefinition
