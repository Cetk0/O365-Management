# Connect to M365 Services

# Exchange online
try {
	Connect-ExchangeOnline -ErrorAction Stop
	Write-Host "Connected to Exchange Online successfully."
} catch {
	Write-Error "Failed to connect to Exchange Online: $_"
	exit 1
}

# Connect to Microsoft Graph
try {
	Connect-MgGraph -Scopes "User.Read.All", "Group.Read.All", "Directory.Read.All" -ErrorAction Stop
	Write-Host "Connected to Microsoft Graph successfully."
} catch {
	Write-Error "Failed to connect to Microsoft Graph: $_"
	exit 1
}