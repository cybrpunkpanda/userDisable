Write-Host "#########################################################################################################"
Write-Host "##"
Write-Host "##"
Write-Host "## User Disable Tool"
Write-Host "##"
Write-Host "## By: Devrryn Jenkins"
Write-Host "##"
Write-Host "##"
Write-Host "#########################################################################################################"

write-host -ForegroundColor White -BackgroundColor Cyan "Welcome to the User Removal Tool for <YOUR_ORG>!"
Write-Host ""
write-host "Alas, we bid farewell to another."
write-host ""
Write-Host ""
write-host ""
write-host -BackgroundColor Red -ForegroundColor White "NOTE: YOU NEED TO HAVE RSAT AND ACTIVE DIRECTORY MODULE INSTALLED FOR THIS TOOL TO WORK!" 
write-host ""

read-host "Press enter to continue"

$usersam = read-host "What is the SAMAccountName of the user we are banishing?"

write-host "Alight then, let's get started"

 

Get-ADPrincipalGroupMembership -Identity  $usersam | Format-Table -Property name

$ADgroups = Get-ADPrincipalGroupMembership -Identity  $usersam | where {$_.Name -ne “Domain Users”}
Remove-ADPrincipalGroupMembership -Identity  $usersam -MemberOf $ADgroups -Confirm:$false

disable-adaccount $usersam
write-host "User disabled!"
$userprop = get-aduser $usersam -properties *

if ($userprop.Company -like '<SEARCH_BASED_ON_DOMAIN') {

write-host "User is a member of either <INCLUDE_SEPERATE_ORGS> User will be moved to proper OU"

get-aduser $usersam | move-adobject -targetpath "<INSERT_DISABLED_USERS_OU>"

write-host "User moved!"
}


Add-Type -AssemblyName PresentationFramework

$discbox = [System.Windows.MessageBox]::Show('Done! The user has been disabled and removed from all groups','Input','Ok')

 switch ($discbox) {

  'Ok' {

   Write-Host "All done!!"

   }
   }
