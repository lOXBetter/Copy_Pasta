# ConvertJsonToHtmlModule.psm1

function ConvertTo-Table {
    param (
        $Object
    )
    $html = "<table class='table table-striped table-hover table-bordered rounded'><tbody>"

    foreach ($property in $Object.PSObject.Properties) {
        $html += "<tr><th class='bg-light text-dark' data-bs-toggle='tooltip' data-bs-placement='top' title='Property Name'>$($property.Name)</th><td class='rounded'>"

        if ($property.Value -is [PSCustomObject]) {
            $html += ConvertTo-Table -Object $property.Value
        } elseif ($property.Value -is [Array]) {
            $html += "<span class='badge bg-info rounded-pill'>Count: $($property.Value.Count)</span>"
            foreach ($item in $property.Value) {
                $html += ConvertTo-Table -Object $item
            }
        } elseif ($property.Value -is [bool]) {
            $badgeColor = if ($property.Value) { 'bg-success' } else { 'bg-danger' }
            $html += "<span class='badge $badgeColor rounded-pill'>$($property.Value)</span>"
        } else {
            $html += $property.Value
        }

        $html += "</td></tr>"
    }

    $html += "</tbody></table>"

    return $html
}

function Generate-TabsHtml {
    param (
        $baseName,
        $tabIndex
    )

    $isActive = if ($tabIndex -eq 1) { 'active' } else { '' }
    return @"
        <li class="nav-item" role="presentation">
            <a class="nav-link $isActive" id="tab$tabIndex" data-bs-toggle="tab" href="#content$tabIndex" role="tab" aria-controls="content$tabIndex" aria-selected="true">$baseName</a>
        </li>
"@
}

function Generate-TabContentHtml {
    param (
        $jsonHtml,
        $tabIndex
    )

    $isActive = if ($tabIndex -eq 1) { 'active' } else { '' }
    return @"
        <div class="tab-pane fade show $isActive" id="content$tabIndex" role="tabpanel" aria-labelledby="tab$tabIndex">
            <div class='table-responsive'>
                $jsonHtml
            </div>
        </div>
"@
}

function Convert-JsonToHtml {
    [CmdletBinding()]
    param(
        [string]$inputDirectory = "raw",
        [string]$outputFile = "AzureResources.html"
    )
    # HTML header with Bootstrap for styling
    $htmlHeader = @"
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <title>Fun Bucket</title>
    </head>
    <body>
    <div class="container mt-4">
        <ul class="nav nav-tabs" id="resourceTab" role="tablist">
"@
   # New HTML navbar with dropdown filters
 

# Rest of the script for loading JSON files and creating tabs...

    # JavaScript for filtering and summary
    $javascriptCode = @"
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                var resourceGroups = [];
                var regions = [];
                // Populate resourceGroups and regions arrays...
                
                // Populate dropdowns
                var resourceGroupFilter = document.getElementById('resourceGroupFilter');
                var regionFilter = document.getElementById('regionFilter');
                resourceGroups.forEach(function(rg) {
                    var item = document.createElement('li');
                    item.innerHTML = '<a class="dropdown-item" href="#">' + rg + '</a>';
                    resourceGroupFilter.appendChild(item);
                });
                regions.forEach(function(region) {
                    var item = document.createElement('li');
                    item.innerHTML = '<a class="dropdown-item" href="#">' + region + '</a>';
                    regionFilter.appendChild(item);
                });

                // Add filtering functionality...
                
                // Populate summary on the home tab...
            });
        </script>
"@
    # HTML footer
    $htmlFooter = @"
            </ul>
            <div class="tab-content" id="resourceTabContent"></div>
        </div>
        <script>
            // Script for filtering by resource type
        </script>
    </body>
    </html>
"@

        # Initialize HTML content
    $htmlContent = ""
    $tabContent = "<div class='tab-pane fade show active' id='contentHome' role='tabpanel' aria-labelledby='tabHome'><h3>Summary</h3><div id='summary'></div></div>"
    $tabIndex = 1
    $currentdirectory = if(Test-Path $inputDirectory) {Join-Path $(Get-Location) $inputDirectory}
    
    # Loop through each subdirectory in the input directory
    Get-ChildItem $currentdirectory | ForEach-Object {
        $resourceGroupName = $_.Name
        $resourceGroupPath = $_.FullName
    
        # Loop through each JSON file in the subdirectory
        Get-ChildItem $resourceGroupPath -Filter "*.json" | ForEach-Object {
            $jsonContent = Get-Content $_.FullName | ConvertFrom-Json

            # Build HTML table for JSON content
            $jsonHtml = ConvertTo-Table -Object $jsonContent
            
           # Create HTML for tabs
            $htmlContent += Generate-TabsHtml -baseName $_.BaseName -tabIndex $tabIndex

            # Create HTML for tab content
            $tabContent += Generate-TabContentHtml -jsonHtml $jsonHtml -tabIndex $tabIndex

            $tabIndex++
        }


        # Combine HTML content
        $finalHtml = $htmlHeader + $htmlNavbar + $htmlContent + '<div class="tab-content" id="resourceTabContent">' + $tabContent + '</div>' + $javascriptCode + $htmlFooter    # Write HTML to file
        $finalHtml | Set-Content $outputFile

        # Open in default browser
        Start-Process $outputFile
    }
}

Export-ModuleMember -Function ConvertTo-Table, Generate-TabsHtml, Generate-TabContentHtml, Convert-JsonToHtml
