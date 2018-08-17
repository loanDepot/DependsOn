task PublishModule {

    if((git branch) -match '\* master'  )
    {
        Publish-Module -Path $Destination -NuGetApiKey $env:NuGetApiKey -Repository $PSRepository -Force -Verbose
    }
    else
    {
        Write-Output "Can only publish to the psgallery from the master branch"
        git -branch
    }
}
