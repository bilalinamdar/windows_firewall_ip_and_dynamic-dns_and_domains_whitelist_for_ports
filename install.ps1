################################
# Set the values of the variables

#$port = 3389
#$myservice = "RDP" ### You can add service name such as RDP / SQL etc

#other variable keep as is.

$serviceName = "FirewallPortWhitelistAccess"
$serviceDisplayName = "Firewall Port Whitelist Access"


##Download NSSM
# Check if script is running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as an administrator. Please re-run the script as an administrator."
    exit
}

# Set the path to the nssm executable
$nssmPath = "C:\nssm\nssm-2.24\win64\nssm.exe"


# Download the latest version of nssm
Invoke-WebRequest -Uri "https://nssm.cc/release/nssm-2.24.zip" -OutFile "nssm.zip"

# Extract the nssm executable from the zip file
Expand-Archive -Path "nssm.zip" -DestinationPath "C:\nssm"

# Delete the zip file
Remove-Item "nssm.zip"

$url = "https://raw.githubusercontent.com/bilalinamdar/windows_firewall_ip_and_dynamic-dns_and_domains_whitelist_for_ports/main/firewall_sql_access_rule.ps1"
#https://github.com/bilalinamdar/windows_firewall_ip_and_dynamic-dns_and_domains_whitelist_for_ports/blob/main/firewall_sql_access_rule.ps1

$destination = "C:\nssm\firewall_sql_access_rule.ps1"

# Download file from URL and save it to C:\nssm
Invoke-WebRequest -Uri $url -OutFile $destination

# Check if firewall_sql_access_rule.ps1 file does not exist in the C:\nssm directory
if (!(Test-Path C:\nssm\firewall_sql_access_rule.ps1)) {
    Write-Error "firewall_sql_access_rule.ps1 file not found in the C:\nssm directory. Please make sure that the file is present and try again."
    exit
}

# Check if nssm.exe file does not exist in the C:\nssm directory
if (!(Test-Path C:\nssm\nssm-2.24\win64\nssm.exe)) {
    Write-Error "nssm.exe file not found in the C:\nssm directory. Please make sure that the file is present and try again."
    exit
}

if (-Not (Test-Path "C:\whitelist.txt")) {
    New-Item -ItemType File -Path "C:\whitelist.txt"
}


# Read the contents of the firewall_sql_access_rule.ps1 script into a variable
#$firewallScript = Get-Content -Path C:\nssm\firewall_sql_access_rule.ps1

# Replace the value of the $port variable with the value of the $port variable in the install.ps1 script
#$firewallScript = $firewallScript -replace '\$port = \d+', '$port = ' + $port

# Replace the value of the $myservice variable with the value of the $myservice variable in the install.ps1 script
#$firewallScript = $firewallScript -replace '\$myservice = "([A-Za-z]+)"', '$myservice = "' + $myservice + '"'

# Save the modified contents of the firewall_sql_access_rule.ps1 script back to the file
#Set-Content -Path C:\nssm\firewall_sql_access_rule.ps1 -Value $firewallScript

##Install Script as a service

# Set the name and display name for the service


# Set the command to run the script


$PathPowerShell = (Get-Command Powershell).Source # Path to PowerShell.exe
$PathScript = $destination
# Arguments for PowerShell, with your script and no personnalised profile
$ServiceArguments = '-ExecutionPolicy Bypass -NoProfile -File "{0}"' -f $PathScript 
# NSSM usage : nssm.exe install <service_name> "<path_to_exe_to_encapsulate>" "<argument1 argument2>"
& $nssmPath install $serviceName $PathPowerShell $ServiceArguments



# Install the service
#& $nssmPath install $serviceName
# Install the service using the service name and display name
# Replace path\to\nssm.exe with the actual path to nssm.exe on your system
#& $nssmPath install $serviceName "powershell.exe -ExecutionPolicy Bypass -File C:\nssm\firewall_sql_access_rule.ps1" -DisplayName $serviceDisplayName

& $nssmPath start $serviceName
# Start the service
#Start-Service $serviceName

& $nssmPath status $serviceName
#Start-Sleep -Seconds 5
###################################################################
