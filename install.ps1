# Install script as a service in windows
# We will be using NSSM - the Non-Sucking Service Manager for this task.
# Courtesy https://nssm.cc/release/nssm-2.24.zip

$serviceName = "FirewallPortWhitelistAccess"
$serviceDisplayName = "Firewall Port Whitelist Access"

# Check if script is running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as an administrator. Please re-run the script as an administrator."
    exit
}

# Set the path to the nssm executable
$nssmPath = "C:\nssm\nssm-2.24\win64\nssm.exe"


# Download the latest version of nssm
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12
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

if (-Not (Test-Path "C:\nssm\whitelist.txt")) {
    New-Item -ItemType File -Path "C:\nssm\whitelist.txt"
}

##Install Script as a service
$PathPowerShell = (Get-Command Powershell).Source # Path to PowerShell.exe
$PathScript = $destination
# Arguments for PowerShell, with your script and no personnalised profile
$ServiceArguments = '-ExecutionPolicy Bypass -NoProfile -File "{0}"' -f $PathScript 
# NSSM usage : nssm.exe install <service_name> "<path_to_exe_to_encapsulate>" "<argument1 argument2>"
& $nssmPath install $serviceName $PathPowerShell $ServiceArguments

& $nssmPath start $serviceName
