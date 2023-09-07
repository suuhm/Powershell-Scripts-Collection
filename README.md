# Powershell/batch-Scripts-Collection
My Collection of some powershell Scripts. More coming soon.

## PWSH Find Replace Recusrive Strings in Files and Dirs v0.1
### Find and Replace Strings in Files / Folders

```
__________________________________________________________
PWSH Find Replace Recusrive Strings in Files and Dirs v0.1
__________________________________________________________
```

```
Usage: .\recursive-string-replace.ps1 -dir_filter 'G:\' -file_filter '*.txt' -find_string='String_old' -replace_string 'String_new'
```

### Sample:
```
PS G:\> .\recursive-string-replace.ps1 -dir_filter "C:\Dreamcast\PAL\Src" -file_filter '*.cpp' -find_string 'int var=34' -replace_string 'char *str'

```

## WLMS Disbaler

### Just Doewnload and Unzip file and rund wlms-disbaler.bat as Admin
