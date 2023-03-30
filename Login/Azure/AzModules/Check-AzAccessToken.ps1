function Test-AzAccessToken {
    [CmdletBinding()]
    param()

    Import-Module Az.Accounts

    $context = Get-AzContext

    if ($null -eq $context) {
        Write-Host "Not logged into Azure" -ForegroundColor Red
        return $false
    }

    $currentDate = [datetime]::UtcNow
    $accessTokenExpiration = if($currentDate -lt $context.ExpiresOn.UtcDateTime) {$context.ExpiresOn.UtcDateTime} else {"no token"}

    if ($currentDate -lt $accessTokenExpiration) {
        Write-Host "Logged into Azure. Access token is still valid." -ForegroundColor Green
        $status = $true
        return $status
    }
    else {
        Write-Host "Access token has expired or is not present. Please log in again." -ForegroundColor Yellow
        $status = $false
        return $status
    }
}