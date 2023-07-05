[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateScript({Test-Path $_ -PathType 'Container'})]
    [string]$JsonDirectory,

    [Parameter(Mandatory = $true, Position = 1)]
    [ValidateScript({Test-Path $_ -PathType 'Container'})]
    [string]$OutputDirectory
)

# Function to convert Azure JSON to XML
function Convert-AzureJsonToXml {
    param (
        [Parameter(Mandatory = $true)]
        [string]$JsonFilePath,

        [Parameter(Mandatory = $true)]
        [string]$XmlFilePath
    )

    $jsonContent = Get-Content -Raw -Path $JsonFilePath
    $jsonObject = ConvertFrom-Json -InputObject $jsonContent
    $xmlContent = $jsonObject | ConvertTo-Xml -NoTypeInformation

    $xmlContent.Save($XmlFilePath)
    Write-Output "Conversion completed for $JsonFilePath"
}

# Function to convert Azure JSON files in a directory to XML
function Convert-AzureJsonsToXmls {
    param (
        [Parameter(Mandatory = $true)]
        [string]$JsonDirectory,

        [Parameter(Mandatory = $true)]
        [string]$OutputDirectory
    )

    $jsonFiles = Get-ChildItem -Path $JsonDirectory -Filter *.json

    if (-not (Test-Path $OutputDirectory)) {
        New-Item -ItemType Directory -Path $OutputDirectory | Out-Null
    }

    foreach ($jsonFile in $jsonFiles) {
        $jsonFilePath = $jsonFile.FullName
        $xmlFileName = [System.IO.Path]::ChangeExtension($jsonFile.Name, ".xml")
        $xmlFilePath = Join-Path -Path $OutputDirectory -ChildPath $xmlFileName

        Convert-AzureJsonToXml -JsonFilePath $jsonFilePath -XmlFilePath $xmlFilePath
    }

    Write-Output "All conversions completed successfully!"
}

# Execute the conversion
Convert-AzureJsonsToXmls -JsonDirectory $JsonDirectory -OutputDirectory $OutputDirectory
