task PublishModule {

    if( $ENV:BHBuildSystem -ne 'Unknown' -and
        $ENV:BHBranchName -eq "master" -and
        [string]::IsNullOrWhiteSpace($ENV:APPVEYOR_PULL_REQUEST_NUMBER) -and
        -not [string]::IsNullOrWhiteSpace($ENV:NugetApiKey))
    {
        Publish-Module -Path $Destination -NuGetApiKey $ENV:NugetApiKey -Repository $PSRepository -Force -Verbose
    }
    else
    {
        "Skipping deployment: To deploy, ensure that...`n" +
        "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
        "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
        "`t* This is not a pull request"
    }
}
