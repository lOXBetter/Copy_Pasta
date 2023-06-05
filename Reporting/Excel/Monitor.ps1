function Monitor-FileChange {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $Path
    $watcher.Filter = "*.xls*"
    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true
    
    # Use all of the NotifyFilters
    $watcher.NotifyFilter = [System.IO.NotifyFilters]'FileName, DirectoryName, Attributes, Size, LastWrite, LastAccess, CreationTime, Security'

    $onChange = Register-ObjectEvent $watcher "Changed" -Action {
       write-host "Changed: $($eventArgs.FullPath)"
    }
    if ($null -ne $onChange) {
        Write-Host $onChange
    }
    else {
        Continue
    }
    $onCreate = Register-ObjectEvent $watcher "Created" -Action {
       write-host "Created: $($eventArgs.FullPath)"
    }
    if ($null -ne $onChange) {
        Write-Host $onChange
    }
    else {
        Continue
    }
    $onDelete = Register-ObjectEvent $watcher "Deleted" -Action {
       write-host "Deleted: $($eventArgs.FullPath)"
    }
    if ($null -ne $onChange) {
        Write-Host $onChange
    }
    else {
        Continue
    }
    $onRename = Register-ObjectEvent $watcher "Renamed" -Action {
       write-host "Renamed: $($eventArgs.FullPath)"
    }
    if ($null -ne $onChange) {
        Write-Host $onChange
    }
    else {
        Continue
    }

    write-host "Monitoring changes to `"$Path`" - press Ctrl+C to exit"
    while ($true) { Start-Sleep -Seconds 1 }  # Infinite loop until user presses Ctrl+C
}

# Example usage
# Monitor-FileChange -Path "Z:\MyFolder"
