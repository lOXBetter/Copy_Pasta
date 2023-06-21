# Import the Selenium module
Import-Module Selenium

# Start Chrome
$driver = Start-SeChrome

# Get the process ids of all running Chrome instances
$chromePIDs = (Get-Process chrome).Id

# Loop through each process id and get the URL from the address bar
foreach ($pid in $chromePIDs) {
    $driver.url = (Get-Process -Id $pid).MainWindowTitle
    if ($url -ne "") {
        Write-Host "URL of the tab is: $url"
    }
}


# Get the title of the page
$title = $driver.Title
Write-Host "Title of the page is: $title"

# Example: Find an element by name (e.g., the Google search box)
$searchBox = $driver.FindElementByName('q')
Write-Host "Search box element: $($searchBox.TagName)"

# Close the browser
$driver.Quit()
