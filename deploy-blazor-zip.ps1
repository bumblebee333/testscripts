param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroup,

    [Parameter(Mandatory = $true)]
    [string]$WebAppName,

    # [Parameter(Mandatory = $false)]
    # [string]$ZipUrl

    [Parameter(Mandatory = $true)]
    [string]$GitHubToken
)

$ErrorActionPreference = "Stop"
$ZipUrl = "https://github.com/bumblebee333/TestBlazorApp/tree/master/Releases/app.zip"

Write-Host "Starting Zip Deploy"
Write-Host "Resource Group : $ResourceGroup"
Write-Host "Web App        : $WebAppName"
Write-Host "ZIP URL        : $ZipUrl"


$ZipFile = "$env:TEMP\app.zip"

$Headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes("x-access-token:$GitHubToken")
    )
}

# ----------------------------
# Download ZIP artifact
# ----------------------------
Write-Host "Downloading ZIP artifact..."

Invoke-WebRequest  -Uri $ZipUrl -Headers $Headers -OutFile $ZipFile -UseBasicParsing

if (-Not (Test-Path $ZipFile)) {
    Write-Error "ZIP file was not downloaded"
}

if ((Get-Item $ZipFile).Length -eq 0) {
    Write-Error "ZIP file is empty"
}

# ----------------------------
# Zip Deploy
# ----------------------------
Write-Host "Deploying ZIP to App Service..."

#az webapp deployment source config-zip --resource-group $ResourceGroup  --name $WebAppName --src $ZipFile
Publish-AzWebApp -ResourceGroupName $ResourceGroup -Name $WebAppName -ArchivePath $ZipFile -Force

Write-Host "Zip Deploy completed successfully"
