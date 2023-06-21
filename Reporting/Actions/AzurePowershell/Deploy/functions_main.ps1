# Import the AzureRM module
Import-Module Az.Resources

# Function to retrieve the subdirectories and index them
function Index-Subdirectories {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $false)]
        [ValidateSet("microsoft.compute", "microsoft.storage", "microsoft.network", "microsoft.web", "microsoft.keyvault")]
        [string]$Subdirectory
    )
    
    $subdirectories = Get-AzureQuickstartTemplateSubdirectories -Subdirectory $Subdirectory
    
    # Create an indexed hashtable of the subdirectories
    $subdirectoryIndex = @{}
    for ($i = 0; $i -lt $subdirectories.Count; $i++) {
        $subdirectoryIndex["$i"] = $subdirectories[$i]
    }
    
    Write-Output $subdirectoryIndex
}

# Retrieve the indexed subdirectories
#$subdirectoryIndex = Index-Subdirectories -Subdirectory "quickstarts"

# Usage example: Display the indexed subdirectories
#$subdirectoryIndex

function Get-AzureQuickstartTemplate {
    [CmdletBinding()]
    param (
        
        [Parameter(Mandatory = $true)]
        [ValidateSet("microsoft.compute", "microsoft.storage", "microsoft.network", "microsoft.web")]
        [string]$Subdirectory,
        
        [Parameter(Mandatory = $true)]
        [ValidateSet("azuredeploy.parameters.json")]
        [string]$TemplateFile

    )
    
    $templateUrl = Get-AzureDeployJsonLink -Subdirectory $Subdirectory -actionFolder $actionFolder -TemplateFile $TemplateFile
    
    try {
        $template = Invoke-RestMethod -Uri $templateUrl -ErrorAction Stop
        Write-Output $template
    }
    catch {
        Write-Error "Failed to retrieve the template from $templateUrl. $_"
    }
}

function Get-AzureQuickstartTemplateSubdirectories {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("microsoft.compute", "microsoft.storage", "microsoft.network", "microsoft.web", "microsoft.keyvault")]
        [string]$subDirectory
    )
    
    $baseUrl = "https://api.github.com/repos/Azure/azure-quickstart-templates/contents/quickstarts/$subDirectory"
    
    try {
        $response = Invoke-RestMethod -Uri $baseUrl -ErrorAction Stop
        $subdirectories = $response | Where-Object { $_.type -eq "dir" } | Select-Object -ExpandProperty name
        Write-Output $subdirectories
    }
    catch {
        Write-Error "Failed to retrieve subdirectories from $baseUrl. $_"
    }
}

function Get-AzureDeployJsonLink {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("quickstarts")]
        [string]$Source,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("microsoft.compute", "microsoft.storage", "microsoft.network", "microsoft.web")]
        [string]$Subdirectory,
        
        [Parameter(Mandatory = $true)]
        [ValidateSet("azuredeploy.parameters.json")]
        [string]$TemplateFile,
        
        [Parameter(Mandatory = $true)]
        [string]$actionFolder
    )
    
    $baseUrl = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts"
    
    if ($Subdirectory) {
        $baseUrl += "/$Subdirectory"
    }
    
    $baseUrl += "/$actionFolder/$TemplateFile"
    
    return $baseUrl
}

function Invoke-WhatIfDeployment {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("microsoft.compute", "microsoft.storage", "microsoft.network", "microsoft.web", "microsoft.keyvault")]
        [string]$Subdirectory,
        
        [Parameter(Mandatory = $true)]
        [ValidateSet("azuredeploy.parameters.json")]
        [string]$TemplateFile,

        [Parameter(Mandatory = $true)]
        [string]$resourceGroupName
    )
    
    try {
        # Retrieve the indexed subdirectories
        $subdirectoryIndex = Index-Subdirectories -Subdirectory $Subdirectory
    
        # Prompt user to select a subdirectory
        $subdirectorySelection = $subdirectoryIndex | Out-GridView -Title "Select a subdirectory" -PassThru
    
        # Get the selected subdirectory name
        $selectedSubdirectory = $subdirectorySelection.Value
    
        # Get the template content
        $templateContent = Get-AzureQuickstartTemplate -Subdirectory $selectedSubdirectory -TemplateFile $TemplateFile
    
        # Convert template content to HTML parameter form
        $parameterForm = ConvertTo-Html -InputObject $templateContent.parameters | Out-String
    
        # Save HTML parameter form to a file
        $parameterFormPath = Join-Path -Path $PSScriptRoot -ChildPath "parameterForm.html"
        $parameterForm | Out-File -FilePath $parameterFormPath
    
        # Open HTML parameter form in the default browser
        Start-Process $parameterFormPath
    
        # Prompt user to fill out parameter values in the HTML form
        $userInput = Read-Host -Prompt "Enter parameter values in the HTML form and press Enter when done"
    
        # Convert user input to a hashtable
        $parameters = $userInput | ConvertFrom-StringData
    
        # Get the content of azuredeploy.json
        $template = Get-AzureQuickstartTemplate -Source "quickstarts" -Subdirectory $selectedSubdirectory -TemplateFile "azuredeploy.json"
    
        # Perform the what-if deployment
        $whatIfResult = Test-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateObject $template -TemplateParameterObject $parameters -WhatIf
        
        Write-Output $whatIfResult
    }
    catch {
        Write-Error "Failed to perform the what-if deployment. $_"
    }
}



# Usage example
#Invoke-WhatIfDeployment -Source "quickstarts" -Subdirectory "microsoft.compute" -ParentFolder "101-vm-custom-script" -TemplateFile "azuredeploy.json"
