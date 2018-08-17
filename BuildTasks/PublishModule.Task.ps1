task PublishModule {

    if( $ENV:BHBuildSystem -ne 'Unknown' -and
        $ENV:BHBranchName -eq "master")
    {
        Publish-Module -Path $Destination -NuGetApiKey $env:NuGetApiKey -Repository $PSRepository -Force -Verbose
    }
    else
    {
        "Skipping deployment: To deploy, ensure that...`n" +
        "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
        "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n"
    }
}
