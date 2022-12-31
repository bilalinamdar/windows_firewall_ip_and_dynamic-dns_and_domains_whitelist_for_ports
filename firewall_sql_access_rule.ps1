$ports = 1433
$serviceNames = "SQL"
## For multiple value example below
#$ports = 1433, 3306, 8080
#$serviceNames = "SQL", "MySQL", "HTTP"

function Update-FirewallRule($ports, $serviceNames) {
    for ($i = 0; $i -lt $ports.Length; $i++) {
        # Set variables for the firewall rule
        $serviceName = "Firewall" + $serviceNames[$i] + "Rule"
        $serviceDisplayName = "Firewall " + $serviceNames[$i] + " Rule"
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
            New-NetFirewallRule -Name $ruleName -DisplayName $serviceDisplayName -Direction Inbound -Protocol TCP -LocalPort $ports[$i] -Action Allow -RemoteAddress $ips -Profile Public | Out-Null
        }
    }
}
# Create a rule to block all incoming traffic on each port
# Check if the firewall rule already exists
for ($i = 0; $i -lt $ports.Length; $i++) {
    $blockRuleName = "Block Incoming " + $serviceNames[$i]
    $blockRuleDisplayName = "Block Incoming " + $serviceNames[$i]
    $ruleExists = Get-NetFirewallRule -Name $blockRuleName -ErrorAction SilentlyContinue

    # If the rule does not exist, create it
    if (-not $ruleExists) {
        New-NetFirewallRule -Name $blockRuleName -DisplayName $blockRuleDisplayName -Direction Inbound -Protocol TCP -LocalPort $ports[$i] -Action Block -Profile Public  | Out-Null
    }
}


while ($true) {
    Update-FirewallRule $ports $serviceNames
    Start-Sleep -Seconds 300
}
