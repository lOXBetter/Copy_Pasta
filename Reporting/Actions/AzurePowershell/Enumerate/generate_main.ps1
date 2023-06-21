# main.ps1

# Import the module
Import-Module ./ConvertJsonToHtmlModule.psm1

# Read the template HTML
$templateHtml = Get-Content -Path "./template.html" -Raw

# Generate content
$navbarHtml = # ... generate navbar HTML
$tabsHtml = # ... generate tabs HTML
$tabContentHtml = # ... generate tab content HTML
$javascriptCode = # ... generate JavaScript code

# Replace placeholders in the template
$finalHtml = $templateHtml -replace "{{NAVBAR}}", $navbarHtml `
                          -replace "{{TABS}}", $tabsHtml `
                          -replace "{{TAB_CONTENT}}", $tabContentHtml `
                          -replace "{{JAVASCRIPT}}", $javascriptCode

# Output the final HTML to a file
$finalHtml | Set-Content "output.html"

# Open in default browser
Start-Process "output.html"
