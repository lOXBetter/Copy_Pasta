$excel = New-Object -ComObject Excel.Application

$workbook = $excel.Workbooks.Open("G:\My Drive\test1.xlsx")

$dataStreamer = $workbook.DataStreamers.Item(1)
$dataStreamer.Activate()

$data = @(
    [PSCustomObject]@{
        "Column1" = "Value1"
        "Column2" = "Value2"
    },
    [PSCustomObject]@{
        "Column1" = "Value3"
        "Column2" = "Value4"
    }
)

# Convert the data to a 2D array
$dataArray = $data | ConvertTo-Csv -NoTypeInformation -Delimiter "`t" | ConvertFrom-Csv | ConvertTo-Json -Depth 1 | ConvertFrom-Json

# Send the data to Data Streamer
$dataStreamer.ShowData($dataArray)

# Update an existing data point
$dataStreamer.UpdateDataPoint("A1", "NewValue")

# Modify settings
$dataStreamer.Settings.AutomaticUpdateFrequency = 1000  # Set update frequency to 1 second

$workbook.Save()
$workbook.Close()

# Quit Excel application
$excel.Quit()
