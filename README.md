# Whitelist IP address / Dynamic DNS / Domain / IP block on Ports in Windows server

"The INBOUND WINDOWS Defender Firewall Rule does not accept the addition of a domain. This script allows users to securely access any desired ports and domains by whitelisting them via their domain names/ Static IP/ IP Block, even if the users have dynamic IP addresses that are managed using Dyn DNS services like Duck DNS or NO-IP. This ensures that users can access these resources even if their IP address is changing."

# Important
1. Disable any inbound rules using the same port after following installation and usage !! EXCEPT script created rule.
2. If having trouble in lan connection than remove "-Profile Public" from the firewall script and also add the lan ip block to the whitelist.txt file e.g 192.168.0.0/24

# Installation

   1. Download and run the install.ps1 in powershell with administration right
   2. Stop the service "FirewallPortWhitelistAccess" in services.msc
   3. Edit C:\nssm\firewall_sql_access_rule.ps1 and change the same $port and $myservice in it too. Change in as below format.
    <br /> 
    
    **Single Port**
    $ports = @(1433)
    $serviceNames = @("SQL")
    
    **For multiple Ports use below format values**
    $ports = @(1433, 3306, 8080)
    $serviceNames = @("SQL", "MySQL", "HTTP")
      
   4. run the service "FirewallPortWhitelistAccess" in services.msc again.
   5. You can check the rule in the firewall adavanced "Firewall <ServiceName> Rule" go to scope you will find the whitelisted ips extracted from whitelist.txt

# Usage
   1) Every 5 minutes the Whitelist gets updated.
   2) Just add IPs, domains, dyn dns based domains, and IP blocks that you need to **WHITELIST** or permit access to ports to `c:\nssm\whitelist.txt`
   
       ```
       12.34.56.78
       mypc.duckdns.org
       client.duckdns.org
       91.35.55.45
       172.16.0.0/12
       103.21.244.0/22
       8.8.8.8
       mycompany.com
       91.108.4.0/22
       104.16.0.0/12
       system36.mycompany.com
       ```
   
   3) You can restart the service to take immediate effect of the whitelist. The service is called "FirewallPortWhitelistAccess" in `services.msc`.

# Uninstall Steps
1. `C:\nssm\nssm-2.24\win64\nssm remove FirewallPortWhitelistAccess` from firewall inbound rules
2. Remove `Block Incoming SQL` and other if installed, e.g. `Block Incoming SQL/MYSQL/RDP/FTP`
3. Delete `Firewall SQL/MYSQL/RDP/FTP Rule` from inbound rule
4. Take backup of `c:\nssm\whitelist.txt`
5. Remove `c:\nssm`
