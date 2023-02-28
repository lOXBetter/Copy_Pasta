function Get-ProcessByCompany {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Company
    )
 
    DynamicParam {
        $param = New-Object System.Management.Automation.RuntimeDefinedParameter("ProcessName", [string], "Mandatory", $null)
        $param.ValidValues.AddRange((Get-Process | Where-Object {$_.Company -eq $Company} | Select-Object -ExpandProperty Name))
 
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attribute.Mandatory = $true
        $param.Attributes.Add($attribute)
 
        return $param
    }
 
    Process {
        # Use the dynamic parameter value
        Get-Process -Name $ProcessName
    }
}
