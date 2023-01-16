while ($true) {
    $ports = @(1433, 3306)
    $serviceNames = @("SQL", "MySQL")
    $whitelistFile = "C:\nssm\whitelist.txt"
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Error "This script must be run as an administrator. Please re-run the script as an administrator."
        exit
    }        
    function Update-FirewallRule($port, $myservice) {
        $serviceName = "Firewall" + $myservice + "Rule"
        $serviceDisplayName = "Firewall " + $myservice + " Rule"
        $ruleName = $serviceName
        $myerror = ""
        $rule = Get-NetFirewallRule -Name $ruleName -ErrorVariable myerror -ErrorAction SilentlyContinue
        if ($rule) {
            $currentIps = $rule.RemoteAddress
            $ips = @()
            $items = Get-Content $whitelistFile
            foreach ($item in $items) {
                if ($item -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\/\d{1,2}$') {
                    $ips += $item
                }
                elseif([System.Net.IPAddress]::TryParse($item, [ref]$null)) {
                    $ips += $item
                } else {
                    $ip = [System.Net.Dns]::GetHostAddresses($item) | Select-Object -ExpandProperty IPAddressToString
                    $ips += $ip
                }
            }
            $ips = $ips | Select-Object -Unique
            $newIps = $ips | Where-Object {$currentIps -notcontains $_}
            $removedIps = $currentIps | Where-Object {$ips -notcontains $_}
            $currentIps += $newIps
            $currentIps = $currentIps | Where-Object {$removedIps -notcontains $_}
            Set-NetFirewallRule -Name $ruleName -RemoteAddress $currentIps
        } else {
            $ips = @()
            $items = Get-Content $whitelistFile
            foreach ($item in $items) {
                if ($item -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\/\d{1,2}$') {
                    $ips += $item
                }
                elseif([System.Net.IPAddress]::TryParse($item, [ref]$null)) {
                    $ips += $item
                } else {
                    $ip = [System.Net.Dns]::GetHostAddresses($item) | Select-Object -ExpandProperty IPAddressToString
                    $ips += $ip
                }
            }
            $ips = $ips | Select-Object -Unique
            New-NetFirewallRule -Name $ruleName -DisplayName $serviceDisplayName -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow -RemoteAddress $ips | Out-Null
        }
    }
    
            for ($i = 0; $i -lt $ports.Count; $i++) {
            Update-FirewallRule $ports[$i] $serviceNames[$i]
            }
            Start-Sleep -Seconds 300
            }    