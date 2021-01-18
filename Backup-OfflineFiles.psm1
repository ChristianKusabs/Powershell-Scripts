<#
.SYNOPSIS
  Backup Offline Files to specified destination
.DESCRIPTION
  Takes ownership of the csc folder and move files to specified destination
.PARAMETER destination
  Location to copy the files to
.INPUTS
  None
.OUTPUTS
  Copy of csc folder to specified destination
.NOTES
  Version:        1.0
  Author:         Christian Kusabs
  Creation Date:  31-07-2020
  Purpose/Change: Initial script
  
.EXAMPLE
  Backup-OfflineFiles -destination "C:\backupfolder"
#>

function Backup-OfflineFiles {

    param(
        [string[]] $destination
    )

    Try {
        takeown /f C:\windows\csc /r /d y
        icacls C:\windows\csc /grant administrators:F /T
        reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system\ -v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1
        robocopy C:\windows\csc $destination /s
    } Catch {
        Throw "Error occured: $_"
    }

}

Export-ModuleMember -Function Backup-OfflineFiles