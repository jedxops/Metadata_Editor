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

# make counter

# Declare paths
$files_to_copy_metadata_to    = Get-ChildItem c:\Users\zombi\Desktop\originals
$files_to_copy_metadata_from  = Get-ChildItem c:\Users\zombi\Desktop\copies
$copy_to_path = '.\originals\'
$copy_from_path = '.\copies\'

ForEach($file1 in $files_to_copy_metadata_to) {
  Write-Host "`nExamining (in copy-to folder): " $file1.name
  ForEach($file2 in $files_to_copy_metadata_from) {
    Write-Host "`tExamining (in copy-from folder): " $file2.name
	
    # Compare the text of the two files
	$fc_rv = fc.exe $copy_to_path$file1 $copy_from_path$file2
    $contains_string = "$fc_rv" -Match "no differences encountered"

    # If its a match, THEN ALSO perform a binary comparison
	# Double check that these are ACTUALLY the same files
	#
	
    if("$contains_string" -eq "True") {
	  $fc_rv = fc.exe /B $copy_to_path$file1 $copy_from_path$file2
	  $contains_string = "$fc_rv" -Match "no differences encountered"

      # If and only if this second comparison returns true, THEN we copy the metadata
      if("$contains_string" -eq "True") {
        Write-Host "`n`tMATCH. Copying " $file2.name "\'s metadata into " $file1.name "\'s metadata.`n"
        $file1.CreationTime = $file2.CreationTime
        break
      }
    }
  }
}

# $rv = fc.exe .\MetaDataEditorScriptTestTextFile__V1.txt .\MetaDataEditorScriptTestTextFile__V1.txt
# Write-Host $rv
# $c_s = "$rv" -Match "no differences encountered"
# Write-Host $c_s

# $fc_rv = fc.exe "$copy_to_path""$file1" "$copy_from_path""$file2"
# $fc_rv = fc.exe .\originals\$file1 .\copies\$file2
# $fc_rv = fc.exe /B "$copy_to_path""$file1" "$copy_from_path""$file2"
# $fc_rv = fc.exe /B .\originals\$file1 .\copies\$file2