# Set variables for the firewall rule and the whitelist file
#Single Value
$ports = @(1433)
$serviceNames = @("SQL")

#For multiple Ports use below format values
#$ports = @(1433, 3306, 8080)
#$serviceNames = @("SQL", "MySQL", "HTTP")
$whitelistFile = "C:\nssm\whitelist.txt"

# Check if script is running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as an administrator. Please re-run the script as an administrator."
    exit
}

# Create a function to update the firewall rule
function Update-FirewallRule($port, $myservice) {
    # Set variables for the firewall rule
    $serviceName = "Firewall" + $myservice + "Rule"
    $serviceDisplayName = "Firewall " + $myservice + " Rule"
    $ruleName = $serviceName

    # Check if the rule already exists
    $error = ""
    $rule = Get-NetFirewallRule -Name $ruleName -ErrorVariable error -ErrorAction SilentlyContinue
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
        New-NetFirewallRule -Name $ruleName -DisplayName $serviceDisplayName -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow -RemoteAddress $ips -Profile Public | Out-Null
    }
}

# Create a rule to block all incoming traffic on each port
# Check if the firewall rule already exists

#for ($i = 0; $i -lt $ports.Length; $i++) {
    #$blockRuleName = "Block Incoming " + $serviceNames[$i]
    #$blockRuleDisplayName = "Block Incoming " + $serviceNames[$i]
    #$ruleExists = Get-NetFirewallRule -Name $blockRuleName -ErrorAction SilentlyContinue

    # If the rule does not exist, create it
    #if (-not $ruleExists) {
    #    New-NetFirewallRule -Name $blockRuleName -DisplayName $blockRuleDisplayName -Direction Inbound -Protocol TCP -LocalPort $ports[$i] -Action Block -Profile Public  | Out-Null
    #}
}

# Create or update the firewall rules for each port
while ($true) {
    for ($i = 0; $i -lt $ports.Length; $i++) {
        Update-FirewallRule $ports[$i] $serviceNames[$i]
    }
    Start-Sleep -Seconds 300
}
