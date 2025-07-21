param (
    [Parameter(Mandatory=$true)]
    [string]$UserPrincipalName
)

# connect to MS Graph
if (-not (Get-MgContext)) {
    Connect-MgGraph -Scopes "User.Read.All", "Group.Read.All"
}

# get user ID from UPN
try {
    $user= Get-MgUser -useerid  $UserPrincipalName
}
Catch {
    Write-Error "Failed to retrieve user with UPN $UserPrincipalName. Please check the UPN and try again."
    exit
}
# get group memberships
Write-Host "Retrieving groups for user: $($user.DisplayName) ($($user.UserPrincipalName))"
$groups = Get-MgGroupMemberOf -UserId $user.Id -All
if ($groups) {
    $groups | Select-Object DisplayName, Id | Format-Table -AutoSize
} else {
    Write-Host "No group memberships found for this user."
}

# export to CSV if needed
$exportPath = "c:\temp\Project\UserGroups_$($user.UserPrincipalName).csv"

#check if export path exists
if (-not (Test-Path -Path (Split-Path -Path $exportPath -IsContainer))) {
    New-Item -Path (Split-Path -Path $exportPath -Parent) -ItemType Directory | Out-Null
}
# export to CSV
$groups | Select-Object DisplayName, Id | Export-Csv -Path $exportPath -NoTypeInformation
Write-Host "Group memberships exported to $exportPath"
# end of script
Write-Host "Script completed successfully."

# exit with success code
exit 0