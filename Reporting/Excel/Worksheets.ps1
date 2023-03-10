# Import the ImportExcel module
Import-Module ImportExcel

# Define the workbook path
$WorkbookPath = "C:\example\Workbook.xlsx"

# Create a new workbook with multiple worksheets
New-ExcelPackage -Path $WorkbookPath |
  ForEach-Object {
    $_.Workbook.Worksheets.Add("Sheet1")
    $_.Workbook.Worksheets.Add("Sheet2")
    $_.Workbook.Worksheets.Add("Sheet3")
  } |
  Save-ExcelPackage -Path $WorkbookPath

