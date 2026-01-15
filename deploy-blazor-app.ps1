param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroup,

    [Parameter(Mandatory = $true)]
    [string]$WebAppName,

    # [Parameter(Mandatory = $false)]
    # [string]$ZipPath

    [Parameter(Mandatory = $true)]
    [string]$GitHubToken
)

$ErrorActionPreference = "Stop"
$ZipUrl = "https://github.com/bumblebee333/TestBlazorApp/raw/refs/heads/master/Releases/app.zip"

Write-Host "Starting Zip Deploy"
Write-Host "Resource Group : $ResourceGroup"
Write-Host "Web App        : $WebAppName"
Write-Host "ZIP Path       : $ZipPath"

# ----------------------------
# Zip Deploy
# ----------------------------
Write-Host "Deploying ZIP to App Service..."
 
Connect-AzAccount -Identity

Publish-AzWebApp -ResourceGroupName $ResourceGroup -Name $WebAppName -ArchivePath $ZipPath -Force

Write-Host "Zip Deploy completed successfully"
