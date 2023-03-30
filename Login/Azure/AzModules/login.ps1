############################################################################################
##  script references
############################################################################################

.\Check-AzAccessToken.ps1
.\Use-chrome.ps1


function Connect-AzMod {
    [CmdletBinding(DefaultParameterSetName="ByEnvironment")]
    param(
        [Parameter(ParameterSetName="ByEnvironment", Mandatory=$true, HelpMessage="Enter Azure Environment (AzureCloud, AzureChinaCloud, AzureUSGovernment, AzureGermanCloud")]
        [ValidateSet("AzureCloud", "AzureChinaCloud", "AzureUSGovernment", "AzureGermanCloud")]
        [string]$Environment,

        [Parameter(ParameterSetName="ByEnvironment", Mandatory=$true, HelpMessage="Enter Tenant Domain")]
        [string]$TenantDomain,

        [Parameter(ParameterSetName="BySubscription", Mandatory=$true, HelpMessage="Enter Subscription ID")]
        [string]$SubscriptionId
    )

    if ($PSCmdlet.ParameterSetName -eq "ByEnvironment") {
        # Retrieve tenant ID using Azure AD Graph API
        $tenantInfo = (Invoke-WebRequest -Uri "https://login.windows.net/$TenantDomain/.well-known/openid-configuration" -UseBasicParsing).Content | ConvertFrom-Json 
        $tenantID = ($tenantInfo).Issuer -replace "https://sts.windows.net/","" -replace "/",""
         
        try {
           $access = Test-AzAccessToken | Where-Object {$_.Tenant -match $tenantID}

           if (!$access -and $Environment -match "AzureUSGovernment") {
                
                $ctx = Connect-AzAccount -Environment $Environment -TenantId $tenantID -UseDeviceAuthentication
                Open-Chrome "https://microsoft.com/deviceloginus/"

           } elseif (!$access -and $Environment -match "AzureCloud") {
                $ctx = Connect-AzAccount -Environment $Environment -TenantId $tenantID -UseDeviceAuthentication
                Open-Chrome "https://microsoft.com/devicelogin"
           }
        }
        catch {
            <#Do this if a terminating exception happens#>
        }
    }
}