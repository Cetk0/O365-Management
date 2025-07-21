# Check if connected to MS Graph
if (-not (Get-MgContext)) {
    Write-Host "Not connected to Microsoft Graph. Connecting now..." -ForegroundColor Yellow
    try {
        Connect-MgGraph -Scopes "User.Read.All", "Group.Read.All", "Directory.Read.All" -ErrorAction Stop
        Write-Host "Connected to Microsoft Graph successfully."
    } catch {
        Write-Error "Failed to connect to Microsoft Graph: $_"
        exit 1
    }
}

# Fetch all users from Microsoft Graph
$Users = Get-MgUser -All -Property "Id", "DisplayName", "UserPrincipalName", "Mail", "AccountEnabled", "Department" -ErrorAction Stop

# Display the users
$Users | Select-Object Id, DisplayName, UserPrincipalName, Mail, AccountEnabled, Department | Format-Table -AutoSize

# Export users to CSV
$ExportPath = "C:\Temp\Project\AllUsers.csv"
if (-not (Test-Path -Path (Split-Path -Path $ExportPath -Parent))) {
    # Suppress output from New-Item to avoid cluttering the console
    New-Item -ItemType Directory -Path (Split-Path -Path $ExportPath -Parent) | Out-Null
}
$Users | Select-Object Id, DisplayName, UserPrincipalName, Mail, AccountEnabled, Department | Export-Csv -Path $ExportPath -NoTypeInformation -Encoding UTF8
Write-Host "All users exported to $ExportPath successfully." -ForegroundColor Green