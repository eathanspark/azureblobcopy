#Import-Module Az.Storage

$scsv = 'source csv path'

$outfile = "output csv path"



$sourceStorageAccountName ="XXXXX"
$sourceStorageAccountKey = "XXXXX"
$sContainer = "sourceContainer"

$context = New-AzStorageContext -StorageAccountName $sourceStorageAccountName -StorageAccountKey $sourceStorageAccountKey

$desStorageAccountName ="XXXXX"
$desStorageAccountKey = "XXXXX"
$desContainer = "destinationContainer"

$desContext = New-AzStorageContext -StorageAccountName $desStorageAccountName -StorageAccountKey $desStorageAccountKey


$start = 0
$batchsize = 500
$end = $batchsize

$processrows = Import-Csv -Path $outfile -Delimiter '|'


if($processrows.count -gt 0)
{
    $start = [int]$processrows[$processrows.count -1].sn    
}
else
{
    $start = 0
}
$end = $start  + $batchsize

$rows = Import-Csv -Path $scsv -Delimiter '|'

$processrows = [System.Collections.ArrayList]@()

for($i=$start; $i -le $end -and $i -le $rows.Count-1 ; $i++)
{
    $item = $rows[$i]
    $blob = $item.downloadlink 
    
    if($item.filetype -ne "pdf" -and $item.filetype -ne "doc" -and $item.filetype -ne "docx" -and $item.filetype -ne "pptx" -and  $item.filetype -ne "ppt" -and  $item.filetype -ne "txt")
    {
        try
        {          
            
            $dblobpath = 'transferred-files/'+$item.downloadlink
            
            $srcBlob = Get-AzStorageBlob -Container $sContainer -Blob $blob -Context $context -ErrorAction Stop
            
            $destBlob =  $srcBlob | Copy-AzStorageBlob -DestContainer $desContainer -DestBlob $dblobpath -DestContext $desContext -Force -ErrorAction Stop
            
            #copy-AzStorageBlob -SrcBlob $srcBlob -SrcContainer $sContainer -DestContainer $desContainer -DestBlob $dblobpath -Context $context -DestContext $desContext -Force -ErrorAction Stop
          

            $hash = @{
                "sn" = $item.sn
                "filename" = $item.filename
                "filetype" = $item.filetype
                "downloadlink" = $blob
                "status" = "success"
                "at" = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                "size" = $item.metadata_storage_size
                "error" =""
              }
            
            $newRow = New-Object PsObject -Property $hash
            $processrows.Add($newRow)
            
        
        }
        catch {
            $hash = @{
                "sn" = $item.sn
                "filename" = $item.filename
                "filetype" = $item.filetype
                "downloadlink" = $blob
                "status" = "failed"
                "at" = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                "size" = $item.metadata_storage_size
                "error" = $_.Exception.Message
              }
            
            $newRow = New-Object PsObject -Property $hash
            $processrows.Add($newRow)
        }
    }
    else
    {
         $hash = @{
                "sn" = $item.sn
                "filename" = $item.filename
                "filetype" = $item.filetype
                "downloadlink" = $blob
                "status" = "skip"
                "at" = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                "size" = $item.metadata_storage_size
                "error" = $item.filetype
              }
            
            $newRow = New-Object PsObject -Property $hash
            $processrows.Add($newRow)
    }
}

$processrows |Export-Csv $outfile -Append -Delimiter '|' -Force -NoTypeInformation




