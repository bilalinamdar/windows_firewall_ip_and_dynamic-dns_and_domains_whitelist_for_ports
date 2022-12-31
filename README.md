# windows_firewall_ip_and_dynamic-dns_and_domains_whitelist_for_ports
Whitelist IP address / Dynamic DNS / Domain / IP block on Ports in Windows server


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
    **Single Port**<br /> 
    $ports = @(1433)<br />
      $serviceNames = @("SQL")<br /> 
    **For multiple Ports use below format values**<br /> 
    $ports = @(1433, 3306, 8080)<br />
      $serviceNames = @("SQL", "MySQL", "HTTP")<br />
   4. run the service "FirewallPortWhitelistAccess" in services.msc again.
   5. You can check the rule in the firewall adavanced "Firewall <ServiceName> Rule" go to scope you will find the whitelisted ips extracted from whitelist.txt

# Usage
   1) Every 5 minutes the Whitelist gets updated.
   2) Just add IPs, domains, dyn dns based domains, and IP blocks that you need to **WHITELIST** or permit access to ports to `c:\nssm\whitelist.txt`
 
     `c:\nssm\whitelist.txt`
     <br /> 
     12.34.56.78<br /> 
     91.35.55.45<br /> 
     172.16.0.0/12<br /> 
     103.21.244.0/22<br /> 
     8.8.8.8<br /> 
     mycompany.com<br /> 
     91.108.4.0/22<br /> 
     104.16.0.0/12<br /> 
     system36.mycompany.com<br />
     <br />
   
     3) You can start, stop, or top the service to take immediate effect of the whitelist. The service is called "FirewallPortWhitelistAccess" in `services.msc`.

# Uninstall Steps
1. `C:\nssm\nssm-2.24\win64\nssm remove FirewallPortWhitelistAccess` from firewall inbound rules
2. Remove `Block Incoming SQL` and other if installed, e.g. `Block Incoming SQL/MYSQL/RDP/FTP`
3. Delete `Firewall SQL/MYSQL/RDP/FTP Rule` from inbound rule
4. Take backup of `c:\nssm\whitelist.txt`
5. Remove `c:\nssm`
