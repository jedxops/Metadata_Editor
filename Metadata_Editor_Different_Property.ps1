# Jeff Austin
# 07/17/2021
# Automated Metadata Editor In Windows Powershell

# Windows Powershell (to be run in Windows Powershell ISE)
# This script is designed to copy metadata from one collection of data (Dataset 1)
# into another equivalent collection of data (Dataset 2)
# Equivalent here means that the two datasets have the same contents
# Metadata is data about data. Its like the Date Created data on an image file,
# or the size of a file, or the extension of a file, etc.

# This automated script is useful in situations where Dataset 1 and Dataset 2
# have the same contents, but differing metadata, and the user needs the metadata
# between the two datasets to be mirrored (i.e., the user needs the metadata
# [and only that metadata] to be copied from one dataset to another)

# I personally designed this script because, in my case, dataset 2 contained
# thousands of valuable image edits that dataset 1 did not have and dataset 2's
# metadata [accidentally] became overwritten during a backup with the incorrect
# metadata and I had no backup of the edited files with the _correct_ metadata_
#
# Dataset 1's metadata was correct, but it didn't contain dataset 2's edits.
# Dataset 2's edits were correct, but each file had incorrect metadata, and I
# couldn't sort the files in the preferred manner (by Date Created). I needed
# the edited files to have the correct metadata.
#
# I had two obvious choices:
#
#   1. Manually edit the metadata (the Date Created Field of each file) using a
#      metadata editor
#      ( like SKTimeStamp, for example:
#        https://sourceforge.net/projects/stefanstools/files/SKTimeStamp/ ,
#        https://tools.stefankueng.com/SKTimeStamp.html                   ).
#
#   2. Re-edit the files that I previously edited
#
# Both of these options would have taken me countless hours (during which I
# likely would have lost my sanity). So... I decided to automate..
# 
# Have a script enter both folders. For each file in the edited folder, look for
# the equivalent file in the folder with the correct metadata. Double check that
# it is indeed the equivalent file by performing a normal file comparison (fc)
# as well as a binary fc. If the files are determined to be equivalent, copy
# the metadata accordingly. Rinse and repeat. Output information about the
# copied data as well as a data copy count

# Declare paths
$files_to_copy_metadata_to    = Get-ChildItem 'drive_name:dest_path_name'
$files_to_copy_metadata_from  = Get-ChildItem 'drive_name:source_path_name'
$copy_to_path = '.\end_of_dest_path_name_2'
$copy_from_path = '.\end_of_source_path_name'

# Other variables
$metadata_copied = 0
$destination_files_examined = 0

ForEach($file1 in $files_to_copy_metadata_to) {
  $destination_files_examined = $destination_files_examined + 1
  $f1_size = ($file1.length)/1kb  
  ForEach($file2 in $files_to_copy_metadata_from) {
    $f2_size = ($file2.length)/1kb
	if($f1_size -eq $f2_size) {
      Write-Host "MATCH. Copying " $file2.name"'s metadata into " $file1.name"'s metadata."
	  $file1.CreationTime = $file2.CreationTime
      $metadata_copied = $metadata_copied + 1
      break
    }
  }
}

Write-Host "Number of files in destination folder: "$destination_files_examined
$percentage_copied = ($metadata_copied/$destination_files_examined)*100
Write-Host $percentage_copied"% of the destination folder's files were copied." 
Write-Host "Total files with updated metadata: "$metadata_copied