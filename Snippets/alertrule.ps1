# Connect to Azure
Connect-AzAccount

# Variables for the Alert Suppression rule
$resourceGroup = "YourResourceGroup"
$alertRuleName = "YourAlertRuleName"

# Function to enable the Alert Suppression rule
function Enable-AlertSuppressionRule {
    $rule = Get-AzAlertProcessingRule -ResourceGroupName $resourceGroup -Name $alertRuleName
    $rule.Enabled = $true
    Set-AzAlertProcessingRule -ResourceGroupName $resourceGroup -Name $alertRuleName -AlertProcessingRule $rule
    Write-Output "Alert Suppression rule enabled."
}

# Function to disable the Alert Suppression rule
function Disable-AlertSuppressionRule {
    $rule = Get-AzAlertProcessingRule -ResourceGroupName $resourceGroup -Name $alertRuleName
    $rule.Enabled = $false
    Set-AzAlertProcessingRule -ResourceGroupName $resourceGroup -Name $alertRuleName -AlertProcessingRule $rule
    Write-Output "Alert Suppression rule disabled."
}

# Main script

# Get the current date and time
$currentDateTime = Get-Date

# Set the target date and time when the rule should be enabled
$targetDateTime = Get-Date -Year $currentDateTime.Year -Month $currentDateTime.Month -Day $currentDateTime.Day -Hour 8 -Minute 0 -Second 0

# Calculate the number of days until the target date and time
$daysUntilTarget = ($targetDateTime - $currentDateTime).Days

# Determine if the rule should be enabled today
if ($daysUntilTarget % 14 -eq 0) {
    Enable-AlertSuppressionRule
} else {
    Disable-AlertSuppressionRule
}

# Disconnect from Azure
Disconnect-AzAccount
