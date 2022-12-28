#Requires -Version 2
<#
.Synopsis
   Get and Set the PreviousBoot efivar that is read by rEFInd.
.DESCRIPTION
   Modify the PreviousBoot EFI variable that is read and modified by the rEFInd bootloader.
   If rEFInd is properly configured, modifying this variable to a substring
   of an available entry will boot the entry on the next boot.

   This script uses a complied Win32 API call to read and modify the EFI.

   It is effectively a re-write of https://gist.github.com/Darkhogg/82a651f40f835196df3b1bd1362f5b8c
   using a bundled C# script to avoid a compilation step or distributing a binary.
.PARAMETER action
   The action to take upon running the script. One of 'none' (default), 'get'
   or 'set'. Use `none` if you just want to source the script.
.PARAMETER value
   A value to set if $action = 'set'.
.EXAMPLE
   & RefindNextBoot.ps1 get
.EXAMPLE
   & RefindNextBoot.ps1 set Linux
.EXAMPLE
   . RefindNextBoot.ps1
   Get-RefindNextBoot
   Set-RefindNextBoot Linux
.NOTES
   Author: Denys Pavlov <me@denys.me>
#>
Param(
    [Parameter()]
    [ValidateSet('set', 'get', 'none')]
    [String]$action = 'none',

    [Parameter()]
    [String]$value = ''
)

# Inject the C# script into the PowerShell Session.
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$script = [io.file]::readalltext("$scriptDir\RefindNextBoot.cs")
Add-Type -Language CSharp -TypeDefinition $script

<#
.Synopsis
   Get the PreviousBoot efivar that is read by rEFInd.
.DESCRIPTION
   This function uses a complied Win32 API call to determine the underlying
   system firmware type.

   Inspired/guided by https://gist.github.com/Darkhogg/82a651f40f835196df3b1bd1362f5b8c
   and re-written using a C# bundled script to avoid a compilation step.
.OUTPUTS
   The PreviousBoot EFI variable value, or the error prefixed with "Error:" if encountered.
.EXAMPLE
   Get-RefindNextBoot
#>
function Get-RefindNextBoot {
    [RefindNextBoot]::Get()
}

<#
.Synopsis
   Get the PreviousBoot efivar that is read by rEFInd.
.DESCRIPTION
   This function uses a complied Win32 API call to determine the underlying
   system firmware type.

   Inspired/guided by https://gist.github.com/Darkhogg/82a651f40f835196df3b1bd1362f5b8c
   and re-written using a C# bundled script to avoid a compilation step.
.PARAMETER value
   The value to assign to the efivar.
.OUTPUTS
   "ok" if EFI variable set successfully, or the error prefixed with "Error:" if encountered.
.EXAMPLE
   Set-RefindNextBoot Linux
#>
function Set-RefindNextBoot {
    Param(
        [Parameter()]
        [String]$value = ''
    )
    [RefindNextBoot]::Set([string]$value)
}

if ($action -eq 'get') {
    Get-RefindNextBoot
}
elseif ($action -eq 'set') {
    Set-RefindNextBoot $value
}