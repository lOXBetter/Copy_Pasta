$Runbooks = Get-AzAutomationRunbook -ResourceGroupName $AutomationAccount.ResourceGroupName -AutomationAccountName $AutomationAccount.Name

$DownloadFolderPath = Read-host -Prompt "Provide Download Path"
New-Item -ItemType Directory -Path $DownloadFolderPath -Force

foreach ($Runbook in $Runbooks) {
    $FolderPath = Join-Path $DownloadFolderPath $Runbook.RunbookType
    if (!(Test-Path $FolderPath)) {
        New-Item -ItemType Directory -Path $FolderPath -Force
    }
    if(!($FolderPath -eq "Python")) {
        $FilePath = Join-Path $FolderPath $Runbook.Name + ".ps1"
    }else{
        $FilePath = Join-Path $FolderPath Runbook.Name + ".py"
    }
    Export-AzAutomationRunbook -ResourceGroupName $AutomationAccount.ResourceGroupName -AutomationAccountName $AutomationAccount.Name -Name $Runbook.Name -Path $FilePath -Force
}
