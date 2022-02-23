# Jeff Austin
# 07/17/2021
# Automated Metadata Editor In Windows Powershell -find how many files contain the same size
# Output number of matched files based on their file size (in kilobytes) (number of couples)

# Windows Powershell (to be run in Windows Powershell ISE)

# Declare paths
$files_to_copy_metadata_to    = Get-ChildItem 'drive_name:dest_path_name'
$files_to_copy_metadata_from  = Get-ChildItem 'drive_name:source_path_name'

# Other variables
$destination_files_examined = 0
$files_with_multiple_partners = 0
$matched = $false

ForEach($file1 in $files_to_copy_metadata_to) {

  # Calculate the size of file1, output its name and size
  $f1_size = ($file1.length)/1kb
  Write-Host "Examining "$file1.name" Size: "$f1_size
  $destination_files_examined = $destination_files_examined + 1

  ForEach($file2 in $files_to_copy_metadata_from) {

    # Calculate the size of file2
	$f2_size = ($file2.length)/1kb
	# If the sizes are equivalent and niether of the files has the .AAE extension
	if(($f2_size -eq $f1_size) -and (("$file1" -Match '.AAE') -eq $false) -and (("$file2" -Match '.AAE') -eq $false)) {
	  
	  # If file1 already had a match, then this file has multiple correspondents with the same size
	  # Thus file1 is in a polygamous relationship. Make note of the cheater!
	  #
	  
	  if($matched -eq $true) {
   	    $files_with_multiple_partners = $files_with_multiple_partners + 1
	    Write-Host "`n`tIDENTIFIED CHEATERS. "$file1.name" "$file2.name" "$f2_size"KB "$f1_size"KB`n"
	  }
	  $matched = $true
	}
  }
  $matched = $false
}

Write-Host "Number of files in destination folder: "$destination_files_examined
Write-Host "Number of couples (two files with the same size): "$files_with_multiple_partners
Write-Host "Note that there can theoretically be multiple couples which contain a partner from a previously identified couple"