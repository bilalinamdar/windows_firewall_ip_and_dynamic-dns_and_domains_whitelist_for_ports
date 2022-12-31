#firewall_sql_access_rule.ps1
# Set variables for the firewall rule and the whitelist file
# Check if script is running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as an administrator. Please re-run the script as an administrator."
    exit
}
$ruleName = "SQL Access"
$port = 1433
$whitelistFile = "C:\whitelist.txt"

# Create a function to update the firewall rule
function Update-FirewallRule {
    # Check if the rule already exists
    $rule = Get-NetFirewallRule -Name $ruleName
    if ($rule) {
        # Update the rule with the current whitelist
        $ips = @()
        $items = Get-Content $whitelistFile
        foreach ($item in $items) {
            # Check if the item is an IP address or a domain
            if ([System.Net.IPAddress]::TryParse($item, [ref]$null)) {
                # Add the IP address to the list
                $ips += $item
            } else {
                # Resolve the domain to an IP address and add it to the list
                $ip = [System.Net.Dns]::GetHostAddresses($item) | Select-Object -First 1
                $ips += $ip
            }
        }
        Set-NetFirewallRule -Name $ruleName -RemoteAddress $ips
    } else {
        # Create the rule with the current whitelist
        $ips = @()
        $items = Get-Content $whitelistFile
        foreach ($item in $items) {
            # Check if the item is an IP address or a domain
            if ([System.Net.IPAddress]::TryParse($item, [ref]$null)) {
                # Add the IP address to the list
                $ips += $item
            } else {
                # Resolve the domain to an IP address and add it to the list
                $ip = [System.Net.Dns]::GetHostAddresses($item) | Select-Object -First 1
                $ips += $ip
            }
        }
        New-NetFirewallRule -Name $ruleName -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow -RemoteAddress $ips -Profile Public
    }
}

# Create a rule to block all incoming traffic on port 1433
New-NetFirewallRule -Name "Block Incoming 1433" -DisplayName "Block Incoming 1433" -Direction Inbound -Protocol TCP -LocalPort $port -Action Block -Profile Public

# Create a timer to update the firewall rule every 5 minutes
$timer = New-Object System.Timers.Timer
$timer.Interval = 300000
$timer.AutoReset = $true
$timer.Enabled = $true
$timer.Add_Elapsed({ Update-FirewallRule })

# Run the timer
$timer.Start()
