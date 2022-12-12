##
## FAT STRINg CUTTEr & 7z to ZIP Convert 2.1a 
## (c) suuhmer 2021
##  
## Easy to use Script for Bulk- renaming and/or convert 7z files to zip.
## I Made this for using my Megadrive/SNES Roms on my og xbox, 
## which only supports the FAT FS /w limited filename-lengths
##
## Parameters: BulkRenamer-7zToZip.ps1 <bulkrename|7ztozip>

$DIR = ""
$GG = "FALSE"

##############################################################################################
#
## Rename files in given folder
#
##############################################################################################
function getRenamed() {

## Get-ChildItem $DIR | Write-Host $_.name.length ??

#GET ALL ITEMS XFAT max 42-2 ? -- 3 SIZE LONG EXTENS
$LONGFILES = @((Get-ChildItem $DIR | ? {$_.name.length -ge 42}) -match "\.[a-z,A-Z,0-9]{2,3}$")
#Get-Process | % { write-host $_ } ## % -> foreach-object
Write-Host -BackgroundColor DarkGray -ForegroundColor Yellow "Es wurden " $LONGFILES.Count "Files gefunden die zu lang sind!"

if ($GG -eq "TRUE") {
    #MAKE TMP DIR && COPY ITEMS
    $TMODOIR = $DIR + "/TMP-DIR"
    mkdir $TMODOIR
    Get-ChildItem $DIR | ? {$_.name.length -ge 42} | Copy-Item -Destination $TMODOIR
}

foreach ($f in $LONGFILES) {
    #$f.ToString()
    #Rename-Item -Path $DIR $f -NewName $f.ToString().Substring()
    Get-ChildItem -Path $DIR -File $f | Move-Item -Force -Destination {$_.Name.Substring(0,37) + $_.Extension}
}
Write-Host -BackgroundColor DarkGray -ForegroundColor Green "Done."

##
##

#GET ALL ITEMS /W NOT ALLOWED SPECIAL-CHARAS
$WRONGFILES = @((Get-ChildItem $DIR | ? {$_.name -match "\,|\+|\%"}) -match "\.[a-z,A-Z,0-9]{2,3}$")
Write-Host -BackgroundColor DarkGray -ForegroundColor Yellow "Es wurden " $WRONGFILES.Count "Files gefunden mit nicht erlaubten Zeichen!"

foreach ($w in $WRONGFILES) {
    #$w.ToString()
    #Rename-Item -Path $DIR $w -NewName $f.ToString().Substring()
    Get-ChildItem -Path $DIR -File $w | Move-Item -Force -Destination {$_.Name.Replace('%','').Replace('+','').Replace(',','')}
}
Write-Host -BackgroundColor DarkGray -ForegroundColor Green "Done."
}

##############################################################################################
#
##  7Z to ZIP
#
##############################################################################################
function convertZip() {

$7zipPath = "$env:ProgramFiles\7-Zip\7z.exe"
$_ext = ".7z"

if (-not (Test-Path -Path $7zipPath -PathType Leaf)) {
    throw "7 zip file '$7zipPath' not found"
}

# & $7zipPath e -so FILE | add a -mx=9
Set-Alias 7zip $7zipPath

$SrcArray = @(Get-ChildItem $DIR -File "*$_ext" | % { $_.BaseName } )
#mkdir tmp-zip
cd $DIR

foreach($z in $SrcArray) {
    7zip e -otmp-dir $($z + $_ext)
    7zip a -mx=9 -sdel $($z + ".zip") ".\tmp-dir\*"
}
}

##############################################################################################
#
##  M A I N
#
##############################################################################################

Write-Host -BackgroundColor DarkGray -ForegroundColor Yellow "FAT STRING CUTTEr 2.1a -- (c) suuhmer 2021"
$mode=$args[0]

if($mode -eq "bulkrename") {
    $DIR = Read-Host -Prompt "Choose Directory?: "
    if ($DIR -ne "") {
        Write-Host "Set up [$DIR] as Directory"
    } else {
        Write-Warning -Message "No input! :("
        exit
    }
    getRenamed
} elseif($mode -eq "7ztozip") {
    $DIR = Read-Host -Prompt "Choose Directory?: "
    if ($DIR -ne "") {
        Write-Host "Set up [$DIR] as Directory"
    } else {
        Write-Warning -Message "No input! :("
        exit
    }
    convertZip
} else {
    Write-Warning -Message "Please use a Parameter like: BulkRenamer-7zToZip.ps1 bulkrename or 7ztozip"
    exit
}
