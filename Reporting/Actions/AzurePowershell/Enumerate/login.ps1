# login.ps1

function Login-ToAzure {
    [CmdletBinding()]
    param()

    # Check if the user is already authenticated
    try {
        $token = (Get-AzAccessToken).Token
    } catch {
        Write-Host "Not logged in or unable to retrieve token."
        $token = $null
    }

    # If the token is null or empty, connect to Azure
    if ([string]::IsNullOrEmpty($token)) {
        try {
            # Check for module updates
            $moduleName = 'Az'
            $latestModule = Find-Module -Name $moduleName

            # If a newer version is available, update the module
            if ((Get-InstalledModule -Name $moduleName).Version -lt $latestModule.Version) {
                Write-Host "Updating $moduleName module from version $((Get-InstalledModule -Name $moduleName).Version) to $latestModule.Version"
                Update-Module -Name $moduleName -Force
            }

            # Connect to Azure
            Connect-AzAccount
        } catch {
            Write-Host "Failed to connect to Azure."
            return
        }
    } else {
        Write-Host "Already logged into Azure."
    }
}

Login-ToAzure