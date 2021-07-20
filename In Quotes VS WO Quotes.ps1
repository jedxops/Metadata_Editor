# Get paths
$files_to_copy_metadata_to    = Get-ChildItem c:\Users\zombi\Desktop\originals
$files_to_copy_metadata_from  = Get-ChildItem c:\Users\zombi\Desktop\copies

ForEach($file1 in $files_to_copy_metadata_to) {
  ForEach($file2 in $files_to_copy_metadata_from) {
    Write-Host "Without quotes: " $file1.name $file2.Name
    Write-Host "Versions in quotes: " "$file1.name" " " "$file2.name"
  }
}