param {
    [parameter(Mandatory=$true)]
    [string]$GroupNameorId
}

# connect to MS Graph
if (-not (get-msgraphcontext)) {
    Connect-msgraph -Scopes "User.read.all", "Group.read.all"
}

# try to get group by ID or name
try {
    $group = Get-MgGroup -groupId $GroupNameorId -ErrorAction Stop
} catch {
    #If failed, try by display name
    try {
        $group = Get-MgGroup -Filter "DisplayName eq '$GroupNameorId'" -ErrorAction Stop | Select-Object -First 1
    } catch {
        Write-Error "Failed to retrieve group with ID or name '$GroupNameorId'. Please check the input and try again."
        exit 1
    }

 #get members of the group
 $members = Get-MgGroupMember -GroupId   