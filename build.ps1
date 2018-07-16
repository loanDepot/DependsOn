$module = 'DependsOn'
Push-Location $PSScriptroot
dotnet build $PSScriptRoot\src -o $PSScriptRoot\output\$module\bin
Copy-Item $PSScriptRoot\$module\* $PSScriptRoot\output\$module -Recurse -Force
Import-Module $PSScriptRoot\Output\DependsOn\DependsOn.psd1
Invoke-Pester $PSScriptRoot\Tests
