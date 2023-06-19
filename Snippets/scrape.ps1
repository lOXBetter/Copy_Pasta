function Convert-HTMLtoExcel {
    param (
        [Parameter(Mandatory = $true)]
        [string]$URL,
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$SheetName
    )
    function Install-PowerShellModule {
        param (
            [Parameter(Mandatory = $true)]
            [string]$ModuleName
        )
        
        # Check if the module is already installed
        $installedModule = Get-Module -ListAvailable | Where-Object { $_.Name -eq $ModuleName }
        
        if ($installedModule) {
            Write-Host "Module '$ModuleName' is already installed. Version: $($installedModule.Version)"
            return
        }
        
        # Construct the PowerShell Gallery URL
        $url = "https://www.powershellgallery.com/packages?q=$ModuleName"
        
        try {
            # Download the page content
            $response = Invoke-WebRequest -Uri $url -ErrorAction Stop
            
            # Parse the HTML content to find the latest version and download URL
            $latestVersion = $response.ParsedHtml.getElementsByTagName("span") | Where-Object { $_.className -eq "module-info-version" } | Select-Object -First 1 -ExpandProperty innerText
            $downloadUrl = "https://www.powershellgallery.com" + ($response.ParsedHtml.getElementById("latest-version-link").href)
            
            # Download the module
            $tempFile = [System.IO.Path]::GetTempFileName()
            Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile -ErrorAction Stop
            
            # Import the downloaded module
            Import-Module -Name $tempFile -Verbose
            
            # Clean up the temporary file
            Remove-Item -Path $tempFile -Force
            
            Write-Host "Module '$ModuleName' downloaded and imported successfully. Latest version: $latestVersion"
        }
        catch {
            Write-Host "An error occurred while downloading or importing the module: $_"
        }
    }
    
    Install-PowerShellModule -ModuleName PowerHTML
    

    $objectarray = @()
    $data = @()

    $webRequest = Invoke-WebRequest -Uri $URL
    $htmlContent = $webRequest.Content

    
    
    $head = $txtFiltered

    # Additional regex filter for <tbody> elements and recursively expanding till </td> tags
    $tbodyRegex = '(?<=<table\b[^>]*>).+?(?=</table>)'
    $tables = [regex]::Matches($htmlContent, $tbodyRegex)

    $idk = ConvertToPlainText $tbodyMatches

    $data | Export-Excel -Path $Path -WorksheetName $SheetName -Append
}
