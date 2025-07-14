Write-Host "`n

###############################################################

      # Xstore - Account unlock and Password Reset Script #
                    # Using MNT Files #

                #Developed by: Aaron Kawahara#

###############################################################"

Write-Warning "Please run this script as Administrator."

#Set-ExecutionPolicy Bypass -Force

#Creating Directory For Local files
New-Item -ItemType Directory "C:\temp\XstoreAcctReset"

#Prompt for Employee ID to insert on the SQL
$employeeID = Read-Host "`n Please Enter your Employee ID:"

#Variable for the SQL Pullup Command
$sql = "RUN_SQL|update hrs_employee_password set EFFECTIVE_DATE = sysdate, PASSWORD ='{SHA512}790a494f7c61c57c3fbb736b9e449207c09a82d5e2f1b75c5d5028d5767fd82f4b28a6247a81a29b4aeef29ac531ea08b8da1042993f285822cd83cce3da2196$5dfb54260dc3b39e$100000' where employee_id = '$employeeID' and CURRENT_PASSWORD_FLAG='1'"


#Creating MNT File with Prompt.
Set-Content -Path "C:\xstore\download\ResetPassword_Employee 1.mnt" -Value $sql -Verbose

#Variable for Unlock pulling from SQL
$sqlUnlock = "RUN_SQL|update HRS_EMPLOYEE set LOCKED_OUT_FLAG = 0, LOCKED_OUT_TIMESTAMP = null where employee_id='$employeeID'"

#command to create MNT file for Acct unlock
Set-Content -Path "C:\xstore\download\Unlock_Employee 1.mnt" -Value $sqlUnlock -Verbose

Write-Host "`n Running Dataloader"

#Initialize the data loader.bat file
Start-Process -FilePath "C:\xstore\dataloader2.bat"

#Useless Progress bar - no use at all just for design
for ($i = 1; $i -le 30; $i++) {
    $percent = ($i / 30) * 100
    Write-Progress -Activity "Installing..." -Status "$percent% Complete" -PercentComplete $percent
    Start-Sleep -Seconds 1
}
Write-Host "✅ Password Reset/Unlock completed!" "Your NewPassword: XXXXXXXX" -ForegroundColor Yellow

Read-Host "Press Enter to Exit"




