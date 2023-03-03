function Get-Files {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateScript({ Test-Path $_ })]
        [string]$Path,
        [switch]$IncludeSubdirectories,
        [string]$FileExtension
    )

    if ($IncludeSubdirectories) {
        $files = Get-ChildItem $Path -Recurse
    } else {
        $files = Get-ChildItem $Path
    }

    if ($FileExtension) {
        $files = $files | Where-Object { $_.Extension -eq $FileExtension }
    }

    return $files
}

Get-Files

Function Get-Windows {
    $OS = Get-CimInstance Win32_OperatingSystem

    return $OS.Caption,$OS.Version -join " "
}

# Calling all Functions

Get-Windows 