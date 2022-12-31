# windows_firewall_ip_and_dynamic-dns_and_domains_whitelist_for_ports
Whitelist IP address / Dynamic DNS / Domain / IP block on Ports in Windows server


If you try to add domain in the INBOUND WINDOWS FIREWALL Rule it will not accept.
So to allow dynamic DNS based domain and Domain's as well plus the IP's and IP block.
I have created this script.

The purpose is to allow secure access to ports mentioned. In this particular script i have 
added 1433 which is MS SQL port. Want to create something to access even if users are on dynamic ip.

So, If a user have a Dyn DNS service such as Duck DNS or NO-IP they can utilize this script.

Installation:


**Usage :**
Just add ip, domains, dyn dns based domain, IP block which you need to WHITELIST / permit access to the port 1433 (or any other if u modify the code)

c:\whitelist.txt<br /> 
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
