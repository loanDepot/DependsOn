
task ImportDevModule {

    if (-not(Test-Path -Path "$Source\$ModuleName.psd1"))
    {
        "Module [$ModuleName] is not built; cannot find [$Source\$ModuleName.psd1]."
        Write-Error -Message "Could not find module manifest [$Source\$ModuleName.psd1]."
    }
    else
    {
        $loaded = Get-Module -Name $ModuleName -All
        if ($loaded)
        {
            "Unloading Module [$ModuleName] from a previous import..."
            $loaded | Remove-Module -Force
        }

        "Importing Module [$ModuleName] from [$Source\$ModuleName.psd1]..."
        Import-Module -FullyQualifiedName "$Source\$ModuleName.psd1" -Force
    }
}
