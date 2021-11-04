# DELETE OLD AD USERS - POWERSHELL SCRIPT BY
# suuhm (c) 2014
#
# Root-Ordner in dem die Userordner liegen 
$profiles_dir = '\\vm-fs\Profiles$' 
$users_dir = '\\vm-fs\Users$'

# alle User aus dem AD lesen 
#$userdirs = get-aduser -Filter * | select -Expand SamAccountName 
$user = Get-ADObject -dis "LDAP://OU=STR_OU,DC=Domainname,DC=com" -Class user | select -Expand SamAccountName

# Unterordner einlesen und verteilen mit Operratoire <= {}
$fsdirs = gci $profiles_dir | ?{$_.PSIsContainer} | select -Expand Name
#NO $user_users = $user 
$user = $user | ForEach-Object{$_ + ".V2"}

# Vergleich durchfuehren und nur unzugeordnete Ordner verarbeiten 
compare $user $fsdirs | ?{$_.Sideindicator -eq "=>"} | %{ 

    $folder = $profiles_dir + "\" + $_.InputObject 
    #Users Dir Setting Vareiableshere
    $folder_users = $users_dir + "\" + $_.InputObject
    $folder_users = $folder_users -replace "\.V2$", "$null"
    $username_raw = $_.InputObject -replace "\.V2$", "$null"
    write-host "Killing teH cideamon first..."
    taskkill.exe /s vm-fs /FI "IMAGENAME eq cidaemon.exe"
    write-host ""
    sleep 2.2
    write-host "=================================================================================================================" -foregroundcolor black -backgroundcolor yellow
    write-host "=> '$username_raw' <= Ordner '$folder' => ist keinem Benutzer zugeordnet." -foregroundcolor black -backgroundcolor yellow
    write-host "=================================================================================================================" -foregroundcolor black -backgroundcolor yellow
    Write-Host "Zum Starten beliebige Taste druecken (Homer Simpson)"
    $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
   
    #### LOESCHE PROFILE$
    Write-Host "=> Loeschen und Rechte ACL setzen von '$folder'" -foregroundcolor black -backgroundcolor green
    sleep 2.6
    #icacls '$folder\*' /inheritance:e <- Vererbung aktivieren :r Loeschen
    takeown /F $folder /R /A
    icacls $folder /resize
    icacls $folder /inheritance:e /T
    #takeown /F $folder /R /A
    remove-item $folder -Recurse -Force -Confirm:$true
    
    #### LÖSCHE USERS$
    Write-Host "=> Loeschen von '$folder_users'" -foregroundcolor black -backgroundcolor green
    takeown /F $folder_users /R /A ; remove-item $folder_users -Recurse -Force -Confirm:$true
    }
