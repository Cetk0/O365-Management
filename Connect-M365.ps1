# Connect to M365 Services

# Exchange online
Connect-ExchangeOnline

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.Read.All", "Group.Read.All", "Directory.Read.All"