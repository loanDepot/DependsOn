$Script:ModuleName = Get-ChildItem .\*\*.psm1 | Select-object -ExpandProperty BaseName
$Script:CodeCoveragePercent = 0.8 # 0 to 1
. $psscriptroot\BuildTasks\InvokeBuildInit.ps1

task Default Build, Test, UpdateSource
task Build Copy, Compile, BuildModule, BuildManifest, Helpify
task Helpify GenerateMarkdown, GenerateHelp
task Test Build, ImportModule, FullTests
task Publish Build, Test, PublishModule

Write-Host 'Import common tasks'
Get-ChildItem -Path $buildroot\BuildTasks\*.Task.ps1 |
    ForEach-Object {Write-Host $_.FullName;. $_.FullName}
