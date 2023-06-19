# getResources.ps1

function Get-Resources {
    [CmdletBinding()]
    param(
        [string]$outputDirectory = "raw"
    )

    # Ensure the user is logged in
    Login-ToAzure

    # Get all resource groups
    $resources = Get-AzResource
    $currentdirectory = Get-Location
    
    # Check if the output directory exists, if not create it
    if (!(Test-Path (Join-Path $currentdirectory $outputDirectory) )) {
        $new = join-path $currentdirectory $outputDirectory
        New-Item -ItemType Directory -Force -Path $new
    }

    # Loop through each resource group
    foreach ($resourceGroupName in $resources.ResourceGroupName) {
        # Create a subfolder for the resource group
        $subfolderPath = Join-Path $currentdirectory $outputDirectory $resourceGroupName
        
        if (!(Test-Path $subfolderPath)) {
            New-Item -ItemType Directory -Force -Path $subfolderPath
       }
        
        # Loop through each resource
        foreach ($resource in $resources) {
            $resourceId = $resource.ResourceId
            $rName = $resource.Name, '.json' -join ""
            $filePath = Join-Path $subfolderPath $rName

            # Check if file exists and last updated within 15 minutes
            if (Test-Path $filePath) {
                $lastWriteTime = (Get-Item $filePath).LastWriteTime
                $timeElapsed = [DateTime]::Now - $lastWriteTime
                if ($timeElapsed.TotalMinutes -le 15) {
                    Write-Host "$filePath has been updated in the last 15 minutes. Skipping..."
                    continue
                }
                else {
                    Write-host "$filePath can be updated"

                    # Export the resource
                    try {
                        Export-AzResourceGroup -ResourceGroupName $resourceGroupName -IncludeParameterDefaultValue -Resource $resourceId -Path $filePath -ErrorAction SilentlyContinue
                        Write-Host "Exported resource $resourceId to $filePath"
                    } catch {
                        Write-Host "Failed to export resource $resourceId"
                    }
                }
            }
            else {
                Write-Host "$filePath does not exist. Creating..."
                 # Export the resource
                 try {
                    Export-AzResourceGroup -ResourceGroupName $resourceGroupName -IncludeParameterDefaultValue -Resource $resourceId -Path $filePath -ErrorAction SilentlyContinue
                    Write-Host "Exported resource $resourceId to $filePath"
                } catch {
                    Write-Host "Failed to export resource $resourceId"
                }
            }
        }
    }
}

Get-Resources