# Whitelist IP address / Dynamic DNS / Domain / IP block on Ports in Windows server


If you try to add domain in the INBOUND WINDOWS Defender Firewall Rule it will not accept.
So to allow dynamic DNS based domain and Domain's as well plus the IP's and IP block.
I have created this script.

The purpose is to allow secure access to ports mentioned. In this particular script i have 
added 1433 which is MS SQL port. Want to create something to access even if users are on dynamic ip.

So, If a user have a Dyn DNS service such as Duck DNS or NO-IP they can utilize this script.
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
 
     `c:\nssm\whitelist.txt`
     12.34.56.78
     mypc.duckdns.org
     client.duckdns.org
     91.35.55.45
     172.16.0.0/12
     103.21.244.0/22
     8.8.8.8<br /> 
     mycompany.com
     91.108.4.0/22
     104.16.0.0/12
     system36.mycompany.com
   
   3) You can start, stop, or top the service to take immediate effect of the whitelist. The service is called "FirewallPortWhitelistAccess" in `services.msc`.

# Uninstall Steps
1. `C:\nssm\nssm-2.24\win64\nssm remove FirewallPortWhitelistAccess` from firewall inbound rules
2. Remove `Block Incoming SQL` and other if installed, e.g. `Block Incoming SQL/MYSQL/RDP/FTP`
3. Delete `Firewall SQL/MYSQL/RDP/FTP Rule` from inbound rule
4. Take backup of `c:\nssm\whitelist.txt`
5. Remove `c:\nssm`
