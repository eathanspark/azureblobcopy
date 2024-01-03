# PowerShell: Copy List of Blobs from One Azure Blob Container to Another
## Use Case / Requirment
We have a web portal which stores files in a azure blob conatiner by uploading from UI in different folder sturcture based on category, location, market ..etc inside same container. Now we have to copy some specific files from this container to another container with same folder struture. 
## Solution Features
- Find out the files which need to be copy to another conatine byt using this script [File Name List](https://github.com/eathanspark/azurebloblist) and create source csv file as given in sample file.
- Filter (exclude files having extention like .doc/.docx/.ppt/.pptx/.pdf/.txt etc)
- Exceiption handling
- Logging
- Copy status as output file 
## Prerequisite
- Azure Storage Account Name
- Azure Storage Account Key
- Azure Blob Container Name

## Library Used 
- Powershell Az Module
- New-AzStorageContext
- Get-AzStorageBlob
- Copy-AzStorageBlob
- Export-Csv

## Script
[FileTransfer.ps1](https://github.com/eathanspark/azureblobcopy/blob/main/FileTransfer.ps1)
## Source CSV File
[sourceFile.csv](https://github.com/eathanspark/azureblobcopy/blob/main/sourceFile.csv)
## Output CSV File
[outputFile.csv](https://github.com/eathanspark/azureblobcopy/blob/main/outputFile.csv)

