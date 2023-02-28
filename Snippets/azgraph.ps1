$tenantId = "<your tenant ID>"
$appId = "<your application ID>"
$appSecret = "<your application secret>"
$subscriptionId = "<your subscription ID>"

$tokenEndpoint = "https://login.microsoftonline.com/$tenantId/oauth2/token"
$body = @{
    "grant_type" = "client_credentials"
    "client_id" = $appId
    "client_secret" = $appSecret
    "resource" = "https://graph.microsoft.com"
}
$accessToken = Invoke-RestMethod -Method Post -Uri $tokenEndpoint -Body $body

$graphApiEndpoint = "https://graph.microsoft.com/v1.0/subscriptions/$subscriptionId/resources"
$resources = Invoke-RestMethod -Method Get -Uri $graphApiEndpoint -Headers @{Authorization = "Bearer $($accessToken.access_token)"}

$resources.value
