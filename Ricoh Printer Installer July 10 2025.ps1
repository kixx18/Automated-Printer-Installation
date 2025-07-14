Write-Host "
#########################################################################
             
                # Automated LS-JP Office Printer Install #
                    # Win 11 - Corporate Machines #

                    # Developed by Aaron Kawahara #
         
#########################################################################"  
       
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please run this script as Administrator."
    Read-Host -Prompt "Press Enter to exit"
    exit
    }
Set-ExecutionPolicy Bypass -Force

# ============
# Configuration?
# ============


# SharedFolder (JP Exclusive) download path:
$downloadPath = "\\yourdomain.com\TYO\temp\JP-Office Printer Installer\Ricoh Installer"

# Download Destination
$DownloadFolder = "c:\temp\Ricoh_Printer"

# Extraction path after downloading and exe file extraction
#$DriverExtractPath = "C:\temp\Ricoh_Printer\RICOH Printer Installer.exe"

#Download File Location
#$downloadedFile = "C:\Temp\RICOH Printer Installer.exe"

#installer location
$DriverInfPath = "C:\temp\Ricoh_Printer\Ricoh Installer\disk1\*.inf"

$DriverName = "RICOH MP C6004 JPN RPCS"

#Printer names: Value and Keys
$Printers = @{
    "xxx.xxx.xxx.xxx" = "7F RICOH Printer"
    "xxx.xxx.xxx.xxx" = "5F RICOH Printer"
    "xxx.xxx.xxx.xxx" = "6F RICOH Printer"
    "xxx.xxx.xxx.xxx" = "4F RICOH Printer"
    }

#Create Download destination folder
New-Item -ItemType Directory -Name "Ricoh_Printer" -Path "C:\Temp\" -Verbose

# =======================
# DOWNLOAD FROM Shared Folder
# =======================
Write-Host "`nDownloading Driver from Shared Folder" -Font "Green"


#This Check the download directory
#Get-Item -ItemType Directory -Path (Split-Path $downloadURL) -Force -Verbose

#This will download the file from Sharepoint
Copy-Item -Path $downloadPath -Recurse -Destination $DownloadFolder -Verbose

# Chekc if download was completed
if (Test-Path $DownloadFolder) {
Write-Host "Download Complete"
}
else {
Write-Host "Download Failed"
}

#Extract/Run the driver
Write-Host "`n Extracting the Installer"
pnputil /add-driver "$DriverInfPath" /install

#Installing and assigning the Printer and Port
#This Test is working. So now I have to create a ForEach loop for it to be easier
#Add-PrinterPort -Name "xxx.xxx.xxx.xxx" -PrinterHostAddress "xxx.xxx.xxx.xxx" 
#Add-PrinterDriver -Name "RICOH MP C6004 JPN RPCS" -Verbose
#Add-Printer -Name "6F_RICOH_Printer" -PortName "xxx.xxx.xxx.xxx" -Verbose

Write-Host "n`Installing Printers for 5F - 6F - 7F"
foreach ($ip in $Printers.Keys) {
    $printerName = $Printers[$ip]

    if (Get-Printer -Name $printerName -ErrorAction SilentlyContinue) {
        Write-Host "Printer already exists: $printerName"
        continue
    }

    if (-not (Get-PrinterPort -Name $ip -ErrorAction SilentlyContinue)) {
        Add-PrinterPort -Name $ip -PrinterHostAddress $ip -Verbose
        Write-Host "Created port: $ip"
    }

    Add-Printer -Name $printerName -PortName $ip -DriverName $DriverName -Verbose
    Write-Host "Installed printer: $printerName"
    
}

Read-Host -Prompt "Press Enter to exit"




