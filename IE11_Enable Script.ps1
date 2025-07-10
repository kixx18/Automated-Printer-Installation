Write-Host "
#########################################################################
             
                  # Auto enable Internet Explorer 11 #
                    # Windows Optional Feature #
                    # Win 10 - Retail Machines #
          # Troubleshoots: Unable to open links directly from Outlook App #
                    # Developed by Aaron Kawahara #
         
#########################################################################"  
       
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please run this script as Administrator."
    Read-Host -Prompt "Press Enter to exit"
    exit
}


$ie11 = (Get-WindowsOptionalFeature -Online -FeatureName "Internet-Explorer-Optional").state

    if ($ie11 -ne "Enabled") {
        Write-Host "IE 11 not Enabled. Enabling Feature"
        Enable-WindowsOptionalFeature -FeatureName "Internet-Explorer-Optional-amd64" -Online -NoRestart -Verbose
}
    else {
        Write-Host "IE11 Feature already Enabled" -ForegroundColor Green
        }

Read-Host -Prompt "Press Enter to exit"