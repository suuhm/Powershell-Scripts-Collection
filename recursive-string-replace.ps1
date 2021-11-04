#
## PWSH Find Replace Recusrive Strings in Files and Dirs v0.1
#
## (c) suuhm 2021
#
## SHORT:
## ls *.config -rec | %{ $f=$_; (gc $f.PSPath) | %{ $_ -replace "emit", "Q_Emit" } | sc $f.PSPath }
#
#
## Using in Batchfile like:
## ________________________
## @echo off
## powershell.exe -NoProfile -ExecutionPolicy Bypass "& {& '%~dp0scripts\recusive-string-replace.ps1' %*}"
#
#
# TODO: replacing with regex strings / Opening GUI Interface? 
#

#param ([Parameter(Mandatory)]$dir_filter='G:\',$file_filter='*.txt',$find_string='',$replace_string='')
param ($dir_filter,$file_filter,$find_string,$replace_string)

function find_replacestrings()
{
    $Q = $find_string
    $R = $replace_string

    $file_ARRAY = Get-ChildItem $dir_filter $file_filter -rec
    Write-Host "There are $($file_ARRAY.Count) $file_filter-Files in $dir_filter"
    sleep 3.2
    Write-Host "Starting..."
    sleep 2.4

    foreach ($file in $file_ARRAY)
    {
        Write-Host "* Replacing in File: $(Get-Item $file.PSPath).Name:"
        (Get-Content $file.PSPath) |
        Foreach-Object { $_ -replace $Q, $R } |
        Set-Content $file.PSPath
    }

    Write-Host "Done , Success!"
}

Write-Host ("__________________________________________________________")
           ("PWSH Find Replace Recusrive Strings in Files and Dirs v0.1")
           ("__________________________________________________________")
           ("")

Write-Host ("Usage: .\recursive-string-replace.ps1 -dir_filter 'G:\' -file_filter '*.txt' -find_string='String_old' -replace_string 'String_new'")
           ("")

if ($dir_filter -eq $null) {
$dir_filter = read-host -Prompt "Please enter folder path: "
} if ($file_filter -eq $null) {
$file_filter = read-host -Prompt "Please enter file/file-extension (default: *.txt): "
} if ($find_string -eq $null) {
$find_string = read-host -Prompt "Please enter strings to find "
} if ($replace_string -eq $null) {
$replace_string = read-host -Prompt "Please enter strings to replpace "
}
write-host "Starting to replace $find_string in the $dir_filter environment"

#Starting main function to replace:
find_replacestrings