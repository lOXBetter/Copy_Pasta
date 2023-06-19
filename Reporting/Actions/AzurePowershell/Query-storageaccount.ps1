function Get-TableEntries {
    param (
        [Parameter(Mandatory = $true)]
        [string]$StorageAccountName,
        
        [Parameter(Mandatory = $true)]
        [string]$StorageAccountKey,
        
        [Parameter(Mandatory = $true)]
        [string]$TableName
    )
    
    $context = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
    $table = Get-AzStorageTable -Name $TableName -Context $context
    $query = New-Object Microsoft.WindowsAzure.Storage.Table.TableQuery
    
    $entries = $table.CloudTable.ExecuteQuery($query)
    
    return $entries
}

$storageAccountName = "your-storage-account-name"
$storageAccountKey = "your-storage-account-key"
$tableName = "your-table-name"

$tableEntries = Get-TableEntries -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey -TableName $tableName

# Use the $tableEntries array as per your requirements

foreach ($entry in $tableEntries) {
    # Access individual properties of each table entry
    $partitionKey = $entry.PartitionKey
    $rowKey = $entry.RowKey
    $timestamp = $entry.Timestamp
    
    # Process the properties or make the necessary requests using Invoke-WebRequest
    # Example:
    $uri = "https://your-api-endpoint/$partitionKey/$rowKey"
    $response = Invoke-WebRequest -Uri $uri
    
    # Process the response as needed
}
