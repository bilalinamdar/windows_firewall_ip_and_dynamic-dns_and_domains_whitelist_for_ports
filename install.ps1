################################
# Set the values of the variables

$port = 1433
$myservice = "RDP" ### You can add service name such as RDP / SQL etc

#other variable keep as is.
$serviceName = "Firewall$myserviceRule"
$serviceDisplayName = "Firewall $myservice Rule"

# Read the contents of firewall_sql_access_rule.ps1 into a variable
$firewallScript = Get-Content .\firewall_sql_access_rule.ps1

# Replace the values of the variables in firewall_sql_access_rule.ps1 with the new values

# Replace the $port variable with the value of $port
$firewallScript = $firewallScript -replace '\$port = \d+', '$port = ' + $port

# Replace the $myservice variable with the value of $myservice
$firewallScript = $firewallScript -replace '\$myservice = "([A-Za-z]+)"', '$myservice = "' + $myservice + '"'

# Save the modified firewall_sql_access_rule.ps1 script
Set-Content .\firewall_sql_access_rule.ps1 -Value $firewallScript


##Download NSSM
# Check if script is running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as an administrator. Please re-run the script as an administrator."
    exit
}

# Set the path to the nssm executable
$nssmPath = "C:\nssm\nssm.exe"

# Download the latest version of nssm
Invoke-WebRequest -Uri "https://nssm.cc/release/nssm-2.24.zip" -OutFile "nssm.zip"

# Extract the nssm executable from the zip file
Expand-Archive -Path "nssm.zip" -DestinationPath "C:\nssm"

# Delete the zip file
Remove-Item "nssm.zip"

$url = "https://github.com/bilalinamdar/windows_firewall_ip_and_dynamic-dns_and_domains_whitelist_for_ports/blob/e55849fcb05e2e488a231f93b5ee4b2142833eda/firewall_sql_access_rule.ps1"
$destination = "C:\nssm\firewall_sql_access_rule.ps1"

# Download file from URL and save it to C:\nssm
Invoke-WebRequest -Uri $url -OutFile $destination

# Check if firewall_sql_access_rule.ps1 file does not exist in the C:\nssm directory
if (!(Test-Path C:\nssm\firewall_sql_access_rule.ps1)) {
    Write-Error "firewall_sql_access_rule.ps1 file not found in the C:\nssm directory. Please make sure that the file is present and try again."
    exit
}

# Check if nssm.exe file does not exist in the C:\nssm directory
if (!(Test-Path C:\nssm\nssm.exe)) {
    Write-Error "nssm.exe file not found in the C:\nssm directory. Please make sure that the file is present and try again."
    exit
}


##Install Script as a service

# Set the name and display name for the service


# Set the command to run the script
$command = "powershell.exe -ExecutionPolicy Bypass -File C:\nssm\firewall_sql_access_rule.ps1"

# Install the service
& $nssmPath install $serviceName

# Set the command to run the service
& $nssmPath set $serviceName AppExit DefaultRestart
& $nssmPath set $serviceName AppNoConsole 1
& $nssmPath set $serviceName AppStdout "C:\nssm\service.out"
& $nssmPath set $serviceName AppStderr "C:\nssm\service.err"
& $nssmPath set $serviceName AppDirectory "C:\"
& $nssmPath set $serviceName AppType Own_Process
& $nssmPath set $serviceName AppThrottle 2500
& $nssmPath set $serviceName AppStdoutCreationDisposition 2
& $nssmPath set $serviceName AppStderrCreationDisposition 2
& $nssmPath set $serviceName AppStdoutRotationTime 1
& $nssmPath set $serviceName AppStderrRotationTime 1
& $nssmPath set $serviceName AppStdoutRotationSize 100000000
& $nssmPath set $serviceName AppStderrRotationSize 100000000
& $nssmPath set $serviceName AppStdoutRotationOnTimeChange 1
& $nssmPath set $serviceName AppStderrRotationOnTimeChange 1

# Set the display name for the service
& $nssmPath set $serviceName DisplayName $serviceDisplayName

# Set the command for the service
& $nssmPath set $serviceName AppCommand $command

net start $serviceName
#Start-Service -Name $serviceName
Get-Service $serviceName
Start-Sleep -Seconds 15
###################################################################
################################
# Set the values of the variables

$port = 1433
$myservice = "RDP" ### You can add service name such as RDP / SQL etc

#other variable keep as is.
$serviceName = "Firewall$myserviceRule"
$serviceDisplayName = "Firewall $myservice Rule"

# Read the contents of firewall_sql_access_rule.ps1 into a variable
$firewallScript = Get-Content .\firewall_sql_access_rule.ps1

# Replace the values of the variables in firewall_sql_access_rule.ps1 with the new values

# Replace the $port variable with the value of $port
$firewallScript = $firewallScript -replace '\$port = \d+', '$port = ' + $port

# Replace the $myservice variable with the value of $myservice
$firewallScript = $firewallScript -replace '\$myservice = "([A-Za-z]+)"', '$myservice = "' + $myservice + '"'

# Save the modified firewall_sql_access_rule.ps1 script
Set-Content .\firewall_sql_access_rule.ps1 -Value $firewallScript


##Download NSSM
# Check if script is running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as an administrator. Please re-run the script as an administrator."
    exit
}

# Set the path to the nssm executable
$nssmPath = "C:\nssm\nssm.exe"

# Download the latest version of nssm
Invoke-WebRequest -Uri "https://nssm.cc/release/nssm-2.24.zip" -OutFile "nssm.zip"

# Extract the nssm executable from the zip file
Expand-Archive -Path "nssm.zip" -DestinationPath "C:\nssm"

# Delete the zip file
Remove-Item "nssm.zip"

$url = "https://github.com/bilalinamdar/windows_firewall_ip_and_dynamic-dns_and_domains_whitelist_for_ports/blob/e55849fcb05e2e488a231f93b5ee4b2142833eda/firewall_sql_access_rule.ps1"
$destination = "C:\nssm\firewall_sql_access_rule.ps1"

# Download file from URL and save it to C:\nssm
Invoke-WebRequest -Uri $url -OutFile $destination

# Check if firewall_sql_access_rule.ps1 file does not exist in the C:\nssm directory
if (!(Test-Path C:\nssm\firewall_sql_access_rule.ps1)) {
    Write-Error "firewall_sql_access_rule.ps1 file not found in the C:\nssm directory. Please make sure that the file is present and try again."
    exit
}

# Check if nssm.exe file does not exist in the C:\nssm directory
if (!(Test-Path C:\nssm\nssm.exe)) {
    Write-Error "nssm.exe file not found in the C:\nssm directory. Please make sure that the file is present and try again."
    exit
}


##Install Script as a service

# Set the name and display name for the service


# Set the command to run the script
$command = "powershell.exe -ExecutionPolicy Bypass -File C:\nssm\firewall_sql_access_rule.ps1"

# Install the service
& $nssmPath install $serviceName

# Set the command to run the service
& $nssmPath set $serviceName AppExit DefaultRestart
& $nssmPath set $serviceName AppNoConsole 1
& $nssmPath set $serviceName AppStdout "C:\nssm\service.out"
& $nssmPath set $serviceName AppStderr "C:\nssm\service.err"
& $nssmPath set $serviceName AppDirectory "C:\"
& $nssmPath set $serviceName AppType Own_Process
& $nssmPath set $serviceName AppThrottle 2500
& $nssmPath set $serviceName AppStdoutCreationDisposition 2
& $nssmPath set $serviceName AppStderrCreationDisposition 2
& $nssmPath set $serviceName AppStdoutRotationTime 1
& $nssmPath set $serviceName AppStderrRotationTime 1
& $nssmPath set $serviceName AppStdoutRotationSize 100000000
& $nssmPath set $serviceName AppStderrRotationSize 100000000
& $nssmPath set $serviceName AppStdoutRotationOnTimeChange 1
& $nssmPath set $serviceName AppStderrRotationOnTimeChange 1

# Set the display name for the service
& $nssmPath set $serviceName DisplayName $serviceDisplayName

# Set the command for the service
& $nssmPath set $serviceName AppCommand $command

net start $serviceName
#Start-Service -Name $serviceName
Get-Service $serviceName
Start-Sleep -Seconds 15
###################################################################
