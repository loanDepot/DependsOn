[CmdletBinding()]

param($Task = 'Default')

$Script:Modules = @(
    'BuildHelpers',
    'InvokeBuild',
    'Pester',
    'platyPS',
    'PSScriptAnalyzer'
)

$Script:ModuleInstallScope = 'CurrentUser'

'Starting build...'
'Installing module dependencies...'

Get-PackageProvider -Name 'NuGet' -ForceBootstrap | Out-Null

Install-Module -Name $Script:Modules -Scope $Script:ModuleInstallScope -Force -SkipPublisherCheck

Set-BuildEnvironment
Get-ChiltItem Env:BH*
$Error.Clear()

'Invoking build...'

Invoke-Build $Task -Result 'Result'
if ($Result.Error)
{
    $Error[-1].ScriptStackTrace | Out-String
    exit 1
}

exit 0
